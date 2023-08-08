#!/bin/bash
#SBATCH --job-name=admixture
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 50G
#SBATCH -c 1
#SBATCH -p jic-long,nbi-long
#SBATCH --time=30-00:00:00

#bedfile=$1
#start=$2
#end=$3
#OutDir=$4

#source package /tgac/software/testing/bin/admixture-1.3.0

#result=""
#for (( i=start; i<=end; i++ )); do
#    result="${result}${i} "
#done
#result="${result% }"

#for K in ${result}; \
#do admixture -j32 --cv=10 --seed=1234 $bedfile $K | tee ${OutDir}/log${K}.out; done

bedfile=$1
K=$2
OutDir=$3

echo Bedfile: $bedfile
echo k=$K
echo OutDir: $OutDir

source package /tgac/software/testing/bin/admixture-1.3.0

admixture -j32 --cv=10 --seed=1234 $bedfile $K | tee ${OutDir}/log${K}.out
