#!/bin/bash
#SBATCH --job-name=hisat2
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH -c 32
#SBATCH --mem 20G
#SBATCH -p jic-medium,jic-long,nbi-medium,nbi-long,RG-Saskia-Hogenhout
#SBATCH --time=02-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

Genome=$1
Fread=$2
Rread=$3
OutDir=$4
OutFile=$5
cpu=32

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo Genome:
echo $Genome
echo Freads:
echo $Fread
echo Rreads:
echo $Rread
echo __
echo __

mkdir -p $WorkDir

ln -s $Genome ${WorkDir}/genome.fa
ln -s $Fread ${WorkDir}/Fread.fq.gz
ln -s $Rread ${WorkDir}/Rread.fq.gz
cd $WorkDir

source package f9c1e0c5-d0e8-4ba0-9edd-88235400fa13
source package c92263ec-95e5-43eb-a527-8f1496d56f1a

hisat2-build -p $cpu genome.fa index
hisat2 --dta -p $cpu --summary-file alignment_summary.txt -x index -q -1 Fread.fq.gz -2 Rread.fq.gz -S ${OutFile}.sam
samtools view -bS ${OutFile}.sam -o ${OutFile}.bam

ls -lh

mv alignment_summary.txt ${OutDir}/${OutFile}_alignment_summary.txt
mv ${OutFile}.bam ${OutDir}/.

rm -r ${WorkDir}
