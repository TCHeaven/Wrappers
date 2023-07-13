#!/bin/bash
#SBATCH --job-name=trim_galore
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 16G
#SBATCH --nodes=1
#SBATCH -c 4
#SBATCH -p jic-medium,nbi-medium
#SBATCH --time=2-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
InFile=$1
Reverse=$2
OutDir=$3
OutFile=$4


echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo Forward_reads:
echo $InFile
echo Reverse_reads:
echo $Reverse
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile

echo _
echo _

mkdir -p $WorkDir

cp $InFile $WorkDir/F.fq.gz
cp $Reverse $WorkDir/R.fq.gz

cd $WorkDir

source package 04b61fb6-8090-486d-bc13-1529cd1fb791

trim_galore --gzip -j 4 --fastqc --quality 0 -length 150 --retain_unpaired --paired F.fq.gz R.fq.gz

cp # $OutDir/.
echo DONE
#rm -r $WorkDir

