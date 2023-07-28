#!/bin/bash
#SBATCH --job-name=admixture
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 50G
#SBATCH -c 16
#SBATCH -p jic-long,nbi-long
#SBATCH --time=30-00:00:00

bedfile=$1
start=$2
end=$3
OutDir=$4

result=""
for (( i=start; i<=end; i++ )); do
    result="${result}${i} "
done
result="${result% }"

for K in ${result}; \
do admixture --cv=10 --seed=1234 $bedfile $K | tee ${OutDir}/log${K}.out; done
