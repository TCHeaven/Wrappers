#!/bin/bash
#SBATCH -o /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH -e /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH --mem 64G
#SBATCH --nodes=1
#SBATCH -c 16
#SBATCH --account=shame
#SBATCH --partition=bioagri
#SBATCH --time=14-00:00:00

CurPath=$PWD
WorkDir="${TMPDIR:-/tmp}/${SLURM_JOB_ID}"
InFile="${1:?ERROR: Missing Input}"
Database="${2:?ERROR: Missing database}"
OutDir="${3:?ERROR: Missing Output Directory}"
OutFile="${4:?ERROR: Missing Output Prefix}"
Max="${5:-1}"
cpu="${SLURM_CPUS_PER_TASK:-1}"

echo CurPth:
echo "$CurPath"
echo WorkDir:
echo "$WorkDir"
echo OutDir:
echo "$OutDir"
echo OutFile:
echo "$OutFile"
echo Input:
echo "$InFile"
echo Database:
echo "$Database"
echo Max target sequences:
echo "$Max"
echo "CPUs: $cpu"
echo _
echo _

cleanup() { echo "Cleaning up temp workspace: $WorkDir"; rm -rf "$WorkDir"; }
trap cleanup EXIT

mkdir -p "$WorkDir"
ln -s "$InFile" "$WorkDir"/InFile.fa

cd "$WorkDir"
module load apptainer/1.4.1-gcc-13.3.0-3coysxn
apptainer exec ~/git_repos/Containers/seqkit_2.9.0--h9ee0642_0 seqkit split -s 200 InFile.fa -O .


module load anaconda3
conda activate blast

if ls InFile.part_*.fa 1> /dev/null 2>&1; then
    echo "Using split files"
    files=(InFile.part_*.fa)
else
    echo "Using original file"
    files=(InFile.fa)
fi

threads_per_job=4
jobs=$((cpu / threads_per_job))

for file in "${files[@]}"; do
    blastn \
        -task megablast \
        -query "$file" \
        -db "$Database" \
        -outfmt '6 qseqid staxids bitscore std Taxonomy stitle' \
        -max_target_seqs "$Max" \
        -max_hsps 1 \
        -num_threads "$threads_per_job" \
        -evalue 1e-25 \
        -out "${file}.out" &

    while [ "$(jobs -r | wc -l)" -ge "$jobs" ]; do
        sleep 1
    done
done
wait

echo -e "qseqid\tstaxids\tbitscore\tqseqid_2\tsseqid\tpident\tlength\tmismatch\tgapopen\tqstart\tqend\tsstart\tsend\tevalue\tbitscore_2\tTaxonomy\tstitle" > ${OutFile}.vs."$(basename $Database)".mts"$Max".hsp1.1e25.megablast.out
cat InFil*.out >> "${OutFile}".vs."$(basename $Database)".mts"$Max".hsp1.1e25.megablast.out

ls -lh
cp "${OutFile}"* "${OutDir}"/.

conda deactivate
conda activate basic

echo DONE
echo
echo "OutDir:"
tree "${OutDir}"
rm -r "$WorkDir"
