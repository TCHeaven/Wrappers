#!/bin/bash
#SBATCH -o /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH -e /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH --mem 1G
#SBATCH --nodes=1
#SBATCH -c 1
#SBATCH --account=shame
#SBATCH --partition=cpu-pre
#SBATCH --time=0-01:30:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

cpu="${SLURM_CPUS_PER_TASK:-1}"
OutDir=${1:?ERROR: Missing Output Directory}
shift 1
Reads=("$@")
if [ ${#Reads[@]} -eq 0 ]; then
    echo "ERROR: No read files provided. Exiting."
    exit 1
fi

echo "Running on node $SLURM_NODELIST"
echo "CurPath: $CurPath"
echo "WorkDir: $WorkDir"
echo "OutDir: $OutDir"
echo "ReadFiles: ${Reads[@]}"

echo _
echo _

mkdir -p $WorkDir
cd $WorkDir

module load fastqc/0.12.1-gcc-12.1.0

mkdir -p "$OutDir"
fastqc -t "$cpu" --extract -o "$OutDir" "${Reads[@]}"

echo DONE
rm -r $WorkDir
