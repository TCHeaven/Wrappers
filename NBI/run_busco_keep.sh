#!/bin/bash
#SBATCH --job-name=busco
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 30G
#SBATCH -c 30
#SBATCH -p jic-short
#SBATCH --time=00-02:00:00

# #SBATCH -p jic-short
# #SBATCH --nodelist=j64n11,j64n12,j64n13,j64n14,j64n15,j64n16

CurPath=$PWD

Genome=$1
Database=${2}
WorkDir=${3}
OutFile=$4
OutDir=$(basename $Database)

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


cp $Genome $WorkDir/${OutFile}.fa

cd $WorkDir
echo pwd:
pwd
source package ad80b294-03bf-44cd-a1c2-1fc33efc411e

mkdir $OutDir
busco -i ${OutFile}.fa -l $Database -m geno -c 30 -f --tar --offline -o $OutDir
echo "BUSCO complete" > $OutDir/check.txt

echo DONE
rm $WorkDir/${OutFile}.fa
rm *hemiptera_odb10.fa
