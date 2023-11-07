#!/bin/bash
#SBATCH --job-name=omniHiC
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 30G
#SBATCH -c 32
#SBATCH -p jic-medium,jic-long
#SBATCH --time=02-00:00:00

##https://omni-c.readthedocs.io/en/latest/fastq_to_bam.html

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

Assembly=$1
Enzyme=$2
OutDir=$3
OutFile=$4
Read1=$5
Read2=$6


echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo Assembly:
echo $Assembly
echo Enzyme:
echo $Enzyme
echo Reads:
echo $Read1
echo Read2
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo _
echo _

mkdir -p $WorkDir

ln -s $Assembly $WorkDir/genome.fa
ln -s $Read1 $WorkDir/Fread.fq.gz
ln -s $Read2 $WorkDir/Rread.fq.gz
cd $WorkDir

source package 638df626-d658-40aa-80e5-14a275b7464b
source package /tgac/software/testing/bin/preseq-3.1.2
source package /tgac/software/testing/bin/pairtools-0.3.0
source bwa-0.7.17

samtools faidx genome.fa
cut -f1,2 genome.fa.fai > genome.genome

bwa index genome.fa
bwa mem -5SP -T0 -t 32 genome.fa Fread.fq.gz Rread.fq.gz -o ${OutFile}.sam
samtools view -@32 -bS ${OutFile}.sam -o ${OutFile}.bam

cp ${OutFile}.bam ${OutDir}/. 
#cp unsorted.bam ../${OutFile}_unsorted.bam

echo DONE
rm -r $WorkDir
