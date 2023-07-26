#!/bin/bash
#SBATCH --job-name=fastqc
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 4G
#SBATCH --nodes=1
#SBATCH -c 16
#SBATCH -p jic-short,nbi-short
#SBATCH --time=0-02:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
InFile=$1
OutDir=$2
OutFile=$3

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo InFile:
echo $InFile
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile

echo _
echo _

mkdir -p $WorkDir

cp $InFile $WorkDir/${OutFile}.fq.gz

cd $WorkDir

source package a138abc4-ed60-4774-8db8-80b4770b1710

fastqc -t 16 --nogroup ${OutFile}.fq.gz

cp *.html $OutDir/.
echo DONE
rm -r $WorkDir

