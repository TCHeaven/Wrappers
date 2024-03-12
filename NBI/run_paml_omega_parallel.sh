#!/bin/bash
#SBATCH --job-name=paml8
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --ntasks=8
#SBATCH --mem-per-cpu 2G
#SBATCH -c 1
#SBATCH -p jic-medium,jic-long,nbi-medium,nbi-long
#SBATCH --time=02-00:00:00


CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
mkdir -p $WorkDir

Seqfile=$1
TreeFile=$2
OutDir=$3
OutFile=$4

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo Seqfiles in this batch:
for x in $Seqfile; do
    echo "$x"
    echo "$x" >> ${WorkDir}/Seqfiles.txt
done
echo TreeFiles in this batch:
for x in $TreeFile; do
    echo "$x"
    echo "$x" >> ${WorkDir}/Treefiles.txt
done
echo OutDirs in this batch:
for x in $OutDir; do
    echo "$x"
    echo "$x" >> ${WorkDir}/Outdirs.txt
done
echo OutFiles in this batch:
for x in $OutFile; do
    echo "$x"
    echo "$x" >> ${WorkDir}/Outfiles.txt
done
echo _
echo _

cd $WorkDir

source package ade453e1-535b-4ca8-bf5e-5d481e6ffcd5

srun ~/git_repos/Scripts/NBI/paml_omega.sh 

echo DONE
rm -r $WorkDir
