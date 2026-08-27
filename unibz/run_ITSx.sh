#!/bin/bash
#SBATCH -o /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH -e /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH --mem 8G
#SBATCH --nodes=1
#SBATCH --cpus-per-task 1
#SBATCH --account=shame
#SBATCH --partition=bioagri
#SBATCH --time=14-00:00:00

CurPath=$PWD
WorkDir="${TMPDIR:-/tmp}/${SLURM_JOB_ID}"
InFile="${1:?ERROR: Missing Input}"
OutPrefix="${2:?ERROR: Missing OutPrefix}"
OutDir="${3:?ERROR: Missing Output Directory}"
cpu="${SLURM_CPUS_PER_TASK:-1}"

echo CurPth:
echo "$CurPath"
echo WorkDir:
echo "$WorkDir"
echo OutDir:
echo "$OutDir"
echo OutPrefix:
echo "$OutPrefix"
echo Input:
echo "$InFile"
echo "CPUs: $cpu"
echo _
echo _

cleanup() { echo "Cleaning up temp workspace: $WorkDir"; rm -rf "$WorkDir"; }
trap cleanup EXIT

mkdir -p "$WorkDir"
ln -s "$InFile" "$WorkDir"/InFile.fastq

cd "$WorkDir"

module load anaconda3
conda activate seqkit-2.10
seqkit fq2fa InFile.fastq > InFile.fasta


conda activate itsxpress
ITSx -i InFile.fasta \
-o "$OutPrefix" \
--preserve T \
--save_regions all \
--summary \
--cpu "$cpu"


ls -lh
mkdir -p "$OutDir"
cp "$OutPrefix"* "${OutDir}"/.

conda deactivate
conda activate basic

echo DONE
echo
echo "OutDir:"
tree "${OutDir}"
rm -r "$WorkDir"
