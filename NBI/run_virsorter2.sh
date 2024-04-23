#!/bin/bash
#SBATCH --job-name=virsorter2
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 128G
#SBATCH --nodes=1
#SBATCH -c 32
#SBATCH -p jic-medium,nbi-medium
#SBATCH --time=02-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

Genome=$1
OutDir=$2
cpu=32

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo Genome:
echo $Genome

echo __
echo __


#source package 7a6ee408-8bf5-4cb5-9853-16d5ad415e8f

#virsorter run --keep-original-seq -i $Genome -w $OutDir --include-groups dsDNAphage,ssDNA,NCLDV,laviviridae --min-length 5000 --min-score 0.5 -j $cpu all
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/virsorter2.2.4.sif virsorter run --keep-original-seq -i $Genome -w $OutDir --include-groups dsDNAphage,ssDNA,NCLDV,laviviridae --min-length 5000 --min-score 0.5 -j $cpu all --db-dir /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/databases/virsorter/db

echo DONE
