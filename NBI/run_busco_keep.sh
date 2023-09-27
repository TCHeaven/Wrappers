#!/bin/bash
#SBATCH --job-name=busco
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 30G
#SBATCH -c 30
#SBATCH -p jic-medium
#SBATCH --time=02-00:00:00

# #SBATCH -p jic-short
# #SBATCH --nodelist=j64n11,j64n12,j64n13,j64n14,j64n15,j64n16

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
Genome=$1
Database=${2}
OutDir=${3}/$(basename $Database)
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
mkdir -p $OutDir
cp $Genome $WorkDir/${OutFile}.fa

cd $WorkDir
source package ad80b294-03bf-44cd-a1c2-1fc33efc411e

busco -i ${OutFile}.fa -l $Database -m geno -c 30 -f --tar --offline -o $OutDir

echo DONE
rm -r $WorkDir
