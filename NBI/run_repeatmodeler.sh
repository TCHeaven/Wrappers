#!/bin/bash
#SBATCH --job-name=repeatmodeler
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 200G
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=4
#SBATCH -p jic-long,nbi-long,jic-largemem,RG-Saskia-Hogenhout
#SBATCH --time=30-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

Genome=$1
OutFile=$2
OutDir=$3

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

echo __
echo __

mkdir $WorkDir
cd $WorkDir

source package 85eb6fb0-3eb7-43b2-9659-49e0142481fc

BuildDatabase -name ${OutFile}_RepMod ${Genome}
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/repeatmodeler2.0.5.sif RepeatModeler -threads 32 -database ${OutFile}_RepMod

tree
cp -r * ${OutDir}/.

echo DONE

rm -r $WorkDir
