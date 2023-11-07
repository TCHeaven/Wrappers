#!/bin/bash
#SBATCH --job-name=pretext
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 50G
#SBATCH -c 32
#SBATCH -p jic-medium
#SBATCH --time=02-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

MappingFile=$1
OutDir=$2
OutFile=$3


echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo Mapping File:
echo $MappingFile
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo _
echo _

mkdir -p $WorkDir

ln -s $MappingFile $WorkDir/sam.bam
cd $WorkDir
ls -lh 

source package 638df626-d658-40aa-80e5-14a275b7464b
source /jic/software/staging/RCSUPPORT-2245/stagingloader

samtools view -h sam.bam | PretextMap -o ${OutFile}.pretext --sortby length --sortorder descend --mapq 0 --highRes

cp ${OutFile}.pretext ${OutDir}/.

echo DONE
rm -r $WorkDir