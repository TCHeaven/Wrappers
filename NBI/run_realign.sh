#!/bin/bash
#SBATCH --job-name=gatk3
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem-per-cpu=25G
#SBATCH --cpus-per-task=1
#SBATCH -p jic-medium,nbi-medium
#SBATCH --time=02-00:00

#Collect inputs
CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
InFile=$1
Reference=$2

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo InFile:
echo $InFile
echo Reference genome:
echo $Reference

OutDir=$(dirname $InFile)/gatk
mkdir $OutDir

source switch-institute ei
source package 3e7beb4d-f08b-4d6b-9b6a-f99cc91a38f9
source package 638df626-d658-40aa-80e5-14a275b7464b
source package /tgac/software/testing/bin/picardtools-2.1.1
source package /nbi/software/testing/bin/GATK-3.8.0 #GATK 3.8.0

#AddOrReplaceReadGroups
OutFile1=$(basename $InFile | sed 's@.bam@_rg.bam@g' )
name=$(basename $InFile | sed 's@.bam@@g' )
java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar AddOrReplaceReadGroups VALIDATION_STRINGENCY=LENIENT \
I=$InFile O=${OutDir}/$OutFile1 \
RGID=$name RGLB=$name RGPL=illumina RGPU=run RGSM=$name

cd $OutDir
samtools index $OutFile1

RefName=$(basename $Reference | sed 's@.fasta@@g' |sed 's@.fa@@g' )
GenomeAnalysisTK.jar -T RealignerTargetCreator \
-nt 1 -R $Reference -I ${OutDir}/$OutFile1 \
-o ${OutDir}/${name}_${RefName}.intervals

OutFile2=$(basename $InFile | sed 's@.bam@_realigned.bam@g' )
GenomeAnalysisTK.jar -T IndelRealigner \
 -R $Reference -I ${OutDir}/$OutFile1 \
 -targetIntervals ${OutDir}/${name}_${RefName}.intervals -o ${OutDir}/$OutFile2

rm ${OutDir}/$OutFile1
rm ${OutDir}/${OutFile1}.bai
rm ${OutDir}/${name}_${RefName}.intervals
