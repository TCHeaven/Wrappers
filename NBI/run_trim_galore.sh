#!/bin/bash
#SBATCH --job-name=trim_galore
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 16G
#SBATCH --nodes=1
#SBATCH -c 4
#SBATCH -p jic-medium,nbi-medium,jic-long,nbi-long
#SBATCH --time=2-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
OutDir=$1
OutFile=$2
Quality=$3
Length=$4

Fread=$5
Rread=$6
Fread2=$7
Rread2=$8
Fread3=$9
Rread3=${10}
Fread4=${11}
Rread4=${12}
Fread5=${13}
Rread5=${14}

Sample=$(echo $OutDir | rev | cut -d '/' -f1 | rev)

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo Sample: ${Sample}

echo Forward reads 1:
echo $Fread
echo Reverse read 1:
echo $Rread
echo Forward reads 2:
echo $Fread2
echo Reverse read 2:
echo $Rread2
echo Forward reads 3:
echo $Fread3
echo Reverse read 3:
echo $Rread3
echo Forward reads 4:
echo $Fread4
echo Reverse read 4:
echo $Rread4
echo Forward reads 5:
echo $Fread5
echo Reverse read 5:
echo $Rread5

echo _
echo _

mkdir -p $WorkDir

zcat $Fread $Fread2 $Fread3 $Fread4 $Fread5 | gzip > $WorkDir/F.fq.gz
zcat $Rread $Rread2 $Rread3 $Rread4 $Rread5 | gzip > $WorkDir/R.fq.gz

cd $WorkDir

source package 04b61fb6-8090-486d-bc13-1529cd1fb791

trim_galore --gzip -j 4 --quality $Quality --length $Length --output_dir . --paired F.fq.gz R.fq.gz


cp F.fq.gz_trimming_report.txt ${OutDir}/${OutFile}_1_report.txt
cp R.fq.gz_trimming_report.txt ${OutDir}/${OutFile}_2_report.txt
cp F_val_1.fq.gz ${OutDir}/${OutFile}_1.fq.gz
cp R_val_2.fq.gz ${OutDir}/${OutFile}_2.fq.gz

#NOTE: to save space the script has been edited to save files to delete input files. 
#if [ -e ${OutDir}/${OutFile}_1.fq.gz ] && [ -e ${OutDir}/${OutFile}_2.fq.gz ]; then
#rm $Rread
#rm $Rread2
#rm $Fread
#rm $Fread2
#else
#echo Outputs not detected
#fi

ls -lh
echo DONE
rm -r $WorkDir