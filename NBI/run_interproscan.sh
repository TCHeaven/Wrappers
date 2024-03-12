#!/bin/bash
#SBATCH --job-name=Interproscan
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 15G
#SBATCH --cpus-per-task=12
#SBATCH -p jic-medium,jic-long,nbi-medium,nbi-long,RG-Saskia-Hogenhout
#SBATCH --time=02-00:00:00

InFile=$1
OutDir=$2

InName=$(basename $InFile)

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo InFile:
echo $InFile

echo __
echo __


mkdir -p $WorkDir
cat $InFile | sed -r "s/\*/X/g" > $WorkDir/$InName

cd $WorkDir
source package 0dd71e29-8eb1-4512-b37c-42f7158718f4
interproscan.sh -cpu 12 --goterms --iprlookup --pathways -i $InName
cd $CurDir

cp $WorkDir/*.gff3 $OutDir/.
cp $WorkDir/*.tsv $OutDir/.
cp $WorkDir/*.xml $OutDir/.

echo DONE
rm -r $WorkDir