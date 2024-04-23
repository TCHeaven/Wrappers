#!/bin/bash
#SBATCH --job-name=admixture
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 64G
#SBATCH -c 16
#SBATCH -p jic-long,nbi-long
#SBATCH --time=2-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
OutDir=$1
OutFile=$2

plink=$3
mink=$4
maxk=$5
boot=$6

echo CurPath:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile

echo Plink files:
echo $plink
echo Maximum value of K: $maxk
echo Minimum value of K: $mink
echo No. of bootstraps: $boot

echo _
echo _

source package /tgac/software/testing/bin/admixture-1.3.0
source package /nbi/software/testing/bin/bcftools-1.8
source package /nbi/software/testing/bin/plink-1.9 
source package 01ef5a53-c149-4c9e-b07d-0b9a46176cc0

k=${mink}
limit=$((maxk + 1))
for ((i=k; i<${limit}; i+=1)); do
echo Running admixture for population size: ${i}
mkdir -p ${WorkDir}/${i}
cp ${plink}* ${WorkDir}/${i}/.
cd $WorkDir/${i}
input=$(ls *.bed)
admixture -j16 --seed 1234 -B$boot $input ${i}
cd $CurPath
done

#mkdir -p $OutDir
#cp ${OutFile}* $OutDir/.
echo DONE
#rm -r $WorkDir
