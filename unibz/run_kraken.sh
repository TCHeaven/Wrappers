#!/bin/bash
#SBATCH -o /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH -e /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH --mem 320G
#SBATCH --nodes=1
#SBATCH -c 64
#SBATCH --account=shame
#SBATCH --partition=bioagri
#SBATCH --time=02-00:00:00

set -euo pipefail

#Mandatory:
CurPath=$PWD
WorkDir="${TMPDIR:-/tmp}/${SLURM_JOB_ID}"
Reads="${1:?ERROR: Missing Input}"
OutDir="${2:?ERROR: Missing OutDir}"
Database="${3:?ERROR: Missing DB}"
cpu="${SLURM_CPUS_PER_TASK:-12}"

echo CurPth:
echo "$CurPath"
echo WorkDir:
echo "$WorkDir"
echo OutDir:
echo "$OutDir"
echo "CPUs: $cpu"

echo Input:
echo "$Reads"
echo Database:
echo "$Database"
echo OutDir:
echo "$OutDir"

module load anaconda3
conda activate kraken2

mkdir -p "$OutDir"
kraken2 \
--threads 64 \
--db "$Database" \
--output "$OutDir"/output_nt.txt \
--unclassified-out "$OutDir"/unclassified_nt.txt \
--classified-out "$OutDir"/classified_nt.txt \
--report "$OutDir"/report_nt.txt \
--use-names \
"$Reads"

conda activate basic

echo DONE
echo
echo "OutDir:"
tree "${OutDir}"
