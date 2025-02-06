#!/bin/bash
#SBATCH --job-name=busco
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 80G
#SBATCH -c 20
#SBATCH -p short
#SBATCH --time=00-06:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
Genome=$1
Database=$2
OutDir=$3
OutFile=$4

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
echo Database:
echo $Database
echo _
echo _

mkdir -p $WorkDir
cp $Genome $WorkDir/genome.fa

cd $WorkDir
mkdir 1

busco -i genome.fa -l $Database -m geno -c 20 -f --tar --offline -o 1

cp 1/run*/short_summary.txt ${OutDir}/${OutFile}_short_summary.txt
echo DONE
rm -r $WorkDir
