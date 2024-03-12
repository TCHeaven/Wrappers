#!/bin/bash
#SBATCH --job-name=prokka
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 50G
#SBATCH --nodes=1
#SBATCH -c 8
#SBATCH -p jic-medium,nbi-medium,jic-long,nbi-long,RG-Saskia-Hogenhout
#SBATCH --time=02-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
Genome=$1
OutDir=$2
OutFile=$3
Locustag=$4
cpu=8

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
echo Locus tag:
echo $Locustag

echo _
echo _

mkdir -p $WorkDir

cd $WorkDir
source package 4e99f6f0-3ba1-4757-9962-ba3faa24d885

prokka --cpus $cpu --force --compliant --centre JIC --outdir $OutDir --locustag $Locustag --prefix $OutFile $Genome

echo DONE
rm -r $WorkDir
