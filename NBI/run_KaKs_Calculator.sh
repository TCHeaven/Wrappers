#!/bin/bash
#SBATCH --job-name=kaks
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 2G
#SBATCH -c 1
#SBATCH -p jic-short
#SBATCH --time=00-02:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

Seqfile=$1
OutDir=$2

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo Seqfile:
echo $Seqfile
echo OutDir:
echo $OutDir
echo _
echo _

mkdir -p $WorkDir

cd $WorkDir

grep -m 1 '>' $Seqfile > axt.axt
grep -v '>' $Seqfile >> axt.axt
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/kakscalculator2_2.0.1.sif KaKs_Calculator -i axt.axt -o $(basename $Seqfile | sed 's@.fasta@@g'| sed 's@.fa@@g')_kakscalculator.txt -c 1 -m MA

mv $(basename $Seqfile | sed 's@.fasta@@g'| sed 's@.fa@@g')_kakscalculator.txt ${OutDir}/. 

echo DONE
rm -r $WorkDir