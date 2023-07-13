#!/bin/bash
#SBATCH --job-name=fst
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 16G
#SBATCH -c 16
#SBATCH -p jic-medium, nbi-medium
#SBATCH --time=1-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

VcfFile=$1
OutDir=$2
OutFile=$3
PopulationFile=$4
WindowSize=$5
WindowSlide=$6

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile

echo VcfFile:
echo $VcfFile
echo PopulationFile:
echo $PopulationFile
echo WindowSize:
echo $WindowSize
echo WindowSlide:
echo $WindowSlide

echo _
echo _

mkdir -p $WorkDir

source package 01ef5a53-c149-4c9e-b07d-0b9a46176cc0

bgzip -cd $VcfFile > $WorkDir/vcf.vcf
cp $PopulationFile $WorkDir/population.txt

cd $WorkDir

singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 /hpc-home/did23faz/git_repos/Scripts/NBI/FST.py vcf.vcf population.txt $WindowSize $WindowSlide fst.txt

cp fst.txt ${OutDir}/${OutFile}
echo DONE
rm -r $WorkDir
