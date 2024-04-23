#!/bin/bash
#SBATCH --job-name=admixture
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 16G
#SBATCH -c 4
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

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
bedfile=$1
K=$2
OutDir=$3

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir

echo Bedfile: $bedfile
echo k=$K
echo OutDir: $OutDir

mkdir -p $WorkDir
cd $WorkDir

source package /tgac/software/testing/bin/admixture-1.3.0

admixture -j4 --cv=10 --seed=1234 -C 100 $bedfile $K | tee ${OutDir}/log${K}.out

echo DONE
#rm -r $WorkDir
