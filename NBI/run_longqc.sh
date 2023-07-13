#!/bin/bash
#SBATCH --job-name=longqc
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 4G
#SBATCH --nodes=1
#SBATCH -c 4
#SBATCH -p jic-medium,nbi-medium
#SBATCH --time=0-02:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
InFile=$1
OutDir=$2
OutFile=$3
Datatype=$4

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo InFile:
echo $InFile
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo Datatype:
echo $Datatype

echo _
echo _

mkdir -p $WorkDir

cp $InFile $WorkDir/fasta.fq.gz

cd $WorkDir

source package f6dcac33-2b3c-4fc1-ae27-bb374a11ed78

gunzip fasta.fq.gz
echo Running longQC
/software/f6dcac33-2b3c-4fc1-ae27-bb374a11ed78/bin/longQC.py sampleqc -x $Datatype --ncpu 4 --mem 4 --sample_name $OutFile --output $OutDir fasta.fq

echo DONE
rm -r $WorkDir

