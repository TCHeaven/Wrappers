#!/bin/bash
#SBATCH --job-name=tiara
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 10G
#SBATCH --nodes=1
#SBATCH -c 8
#SBATCH -p nbi-short,jic-short
#SBATCH --time=00-02:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
InFile=$1
OutDir=$2
OutFile=$3

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo Input:
echo $InFile
echo _
echo _

mkdir -p $WorkDir
ln -s $InFile $WorkDir/InFile.fa

cd $WorkDir
source package 67a6fe3c-a190-435c-8bea-88336577343e

tiara -i InFile.fa -o ${OutFile}.tiara -t 8 --pr --tf all -m 1000

#mkdir ${OutDir}
cp *.tiara ${OutDir}/.
echo DONE
rm -r $WorkDir
