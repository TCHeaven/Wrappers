#!/bin/bash
#SBATCH -o /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH -e /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH --mem 64G
#SBATCH --nodes=1
#SBATCH -c 16
#SBATCH --account=shame
#SBATCH --partition=bioagri
#SBATCH --time=02-00:00:00

CurPath=$PWD
WorkDir="${TMPDIR:-/tmp}/${SLURM_JOB_ID}"
InFile="${1:?ERROR: Missing Input}"
Database="${2:?ERROR: Missing database}"
OutDir="${3:?ERROR: Missing Output Directory}"
OutFile="${4:?ERROR: Missing Output Prefix}"
Max="${5:-1}"
cpu="${SLURM_CPUS_PER_TASK:-1}"

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo Input:
echo $InFile
echo Database:
echo $Database
echo Max target sequences:
echo $Max
echo "CPUs: $cpu"
echo _
echo _

mkdir -p $WorkDir
ln -s $InFile $WorkDir/InFile.fa

cd $WorkDir
split -l 200 InFile.fa InFile_split_


module load anaconda3
conda activate blast

for file in InFile_split_*; do
blastn \
-task megablast \
-query "$file" \
-db $Database \
-outfmt '6 qseqid staxids bitscore std Taxonomy stitle' \
-max_target_seqs $Max \
-max_hsps 1 \
-num_threads $cpu \
-evalue 1e-25 \
-out "${file}.out"
done

echo -e echo -e "qseqid\tstaxids\tbitscore\tqseqid_2\tsseqid\tpident\tlength\tmismatch\tgapopen\tqstart\tqend\tsstart\tsend\tevalue\tbitscore_2\tTaxonomy\tstitle" > ${OutFile}.vs."$(basename $Database)".mts"$Max".hsp1.1e25.megablast.out
cat InFile_split_*.out >> ${OutFile}.vs."$(basename $Database)".mts"$Max".hsp1.1e25.megablast.out

ls -lh
cp ${OutFile}* ${OutDir}/.

conda deactivate
conda activate basic

echo DONE
echo
echo "OutDir:"
tree "${OutDir}"
rm -r "$WorkDir"
