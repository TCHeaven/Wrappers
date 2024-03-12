#!/bin/bash
#SBATCH --job-name=inspector
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 50G
#SBATCH --nodes=1
#SBATCH -c 32
#SBATCH -p jic-medium,jic-long,nbi-medium,nbi-long,RG-Saskia-Hogenhout
#SBATCH --time=02-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

OutFile=$1
OutDir=$2
Genome=$3
Datatype=$4
Correct_Datatype=$5
Read1=$6
Read2=$7
cpu=32

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
echo Datatype:
echo $Datatype	
echo Reads:
echo $Read1
echo $Read2

echo __
echo __

mkdir $WorkDir
cd $WorkDir
source package 3cadda3e-6121-405a-9ea3-125eec0fb336

inspector.py -c $Genome -r $Read1 $Read2 -o inspector/ --datatype $Datatype -t $cpu --min_contig_length 1000
inspector-correct.py -i inspector/ --datatype $Correct_Datatype -o inspector/ -t $cpu

echo DONE

tree
mv inspector/contig_corrected.fa inspector/${OutFile}_corrected.fa
rm inspector/read_to_contig.bam
cp -r inspector ${OutDir}/.

rm -r $WorkDir