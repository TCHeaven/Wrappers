#!/bin/bash
#SBATCH --job-name=braker
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 50G
#SBATCH --nodes=1
#SBATCH -c 32
#SBATCH -p jic-medium,jic-long,nbi-medium,nbi-long,RG-Saskia-Hogenhout
#SBATCH --time=02-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

Masked_Genome=$1
RNA_alignment=$2
Protein_database=$3
Species=$4
OutDir=$5
cpu=32

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir

echo Genome:
echo $Masked_Genome
echo Alignment:
echo $RNA_alignment
echo Protein:
echo $Protein_database
echo Species:
echo $Species

echo __
echo __

mkdir $WorkDir
cd $WorkDir

source package 85f2de80-4bd0-48dc-9303-bba1a19206e4
braker.pl --threads $cpu --gff3 --species $Species --genome=$Masked_Genome --bam=$RNA_alignment

echo DONE

tree
mv braker/* ${OutDir}/.

rm -r ${WorkDir}