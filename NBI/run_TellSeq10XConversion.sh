#!/bin/bash
#SBATCH --job-name=ust10x
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 10G
#SBATCH --nodes=1
#SBATCH -c 1
#SBATCH -p jic-medium,nbi-medium
#SBATCH --time=02-0:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
Fread=$1
Rread=$2
Sread=$3
OutDir=$4
OutFile=$5

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir

echo Fread:
echo $Fread
echo Rread:
echo $Rread
echo Sread:
echo $Sread
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile

echo _
echo _

mkdir -p $WorkDir

ln -s $Fread $WorkDir/Fread.fastq.gz
ln -s $Rread $WorkDir/Rread.fastq.gz
ln -s $Sread $WorkDir/Sread.fastq.gz

cd $WorkDir

/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/conversion_tool/ust10x -i1 Sread.fastq.gz -r1 Fread.fastq.gz -r2 Rread.fastq.gz -wl /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/conversion_tool/4M-with-alts-february-2016.txt

ls -lh

gzip *_sl.fastq.gz.4tenx.fastq

mv R1_sl.fastq.gz.4tenx.fastq.gz ${OutDir}/${OutFile}_S1_L001_R1_001.fastq.gz
mv R2_sl.fastq.gz.4tenx.fastq.gz ${OutDir}/${OutFile}_S1_L001_R2_001.fastq.gz

echo DONE
rm -r $WorkDir

