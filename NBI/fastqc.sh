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
OutDir=$1
OutFile=$2
Fread=$3
Rread=$4

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo ReadFiles:
echo $Fread
echo $Rread

echo _
echo _

mkdir -p $WorkDir

ln -s $Fread $WorkDir/fastq1.fq.gz
ln -s $Rread $WorkDir/fastq2.fq.gz

cd $WorkDir

source package a138abc4-ed60-4774-8db8-80b4770b1710

fastqc -t 16 --extract -o . fastq1.fq.gz fastq2.fq.gz

echo DONE
#rm -r $WorkDir

