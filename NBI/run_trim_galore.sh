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
InFile=$(basename $1)
Reads_2=$(basename $2)
OutDir=$3
OutFile=$4


echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo Reads_1:
echo $1
echo $InFile
echo Reads_2:
echo $2
echo $Reads_2
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile

echo _
echo _

mkdir -p $WorkDir

cp $1 $WorkDir/$InFile
cp $2 $WorkDir/$Reads_2

cd $WorkDir

source package 04b61fb6-8090-486d-bc13-1529cd1fb791

trim_galore --gzip -j 4 --fastqc --quality 0 --length 150 $InFile $Reads_2

cp # $OutDir/.
echo DONE
#rm -r $WorkDir

