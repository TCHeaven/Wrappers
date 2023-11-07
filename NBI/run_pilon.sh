#!/bin/bash
#SBATCH --job-name=pilon
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 750G
#SBATCH -c 32
#SBATCH -p jic-largemem
#SBATCH --time=02-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

Assembly=$1
Alignment=$2
Index=$3
OutDir=$4
OutFile=$5

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo Assembly:
echo $Assembly
echo Alignment:
echo $Alignment
echo Index:
echo $Index
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo _
echo _

mkdir -p $WorkDir

ln -s $Assembly $WorkDir/genome.fa
ln -s $Index $WorkDir/alignment.bam.bai
ln -s $Alignment $WorkDir/alignment.bam
cd $WorkDir

source package 338afe4a-63a0-4048-8284-b7a3368d97bc
pilon -Xmx750G --genome genome.fa \
    --bam alignment.bam \
    --changes --mindepth 30 --tracks --diploid --threads 32 \
    --output ${OutFile}_pilon

cp ${OutFile}_pilon* ${OutDir}/.
echo DONE
rm -r $WorkDir