#!/bin/bash
#SBATCH --job-name=bam_sort
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem-per-cpu=4G
#SBATCH --cpus-per-task=1
#SBATCH -p jic-short,nbi-short
#SBATCH --time=00-02:00

#Collect inputs
CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
InFile=$1

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo InFile:
echo $InFile

source switch-institute ei
source package 3e7beb4d-f08b-4d6b-9b6a-f99cc91a38f9
source package 638df626-d658-40aa-80e5-14a275b7464b
source pilon-1.22
source package /tgac/software/testing/bin/picardtools-2.1.1

name=$(basename $InFile | cut -d '.' -f1)
OutDir=$(dirname $InFile)
samtools sort -o ${OutDir}/${name}_sorted.sam -T ${name}_1234 $InFile
samtools view -bS ${OutDir}/${name}_sorted.sam > ${OutDir}/${name}_sorted.bam

OutFile=$(basename ${OutDir}/${name}_sorted.bam | sed 's@mito@mitochondrial@g')
java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar SortSam I=${OutDir}/${name}_sorted.bam O=${OutDir}/${OutFile} SORT_ORDER=coordinate

OutFile2=$(echo ${OutDir}/${OutFile} | sed 's@.bam@_MarkDups.bam@g')
java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar MarkDuplicates REMOVE_DUPLICATES=true I=${OutDir}/${OutFile} O=${OutFile2} M=${OutDir}/${name}_marked_dup_metrics.txt
if [ -e ${OutFile2} ]; then
rm ${OutDir}/${name}_sorted.sam
rm ${OutDir}/${name}_sorted.bam
rm ${OutDir}/${OutFile}
else
echo Output3 missing
fi

cd ${OutDir}
samtools index ${OutFile2}

echo DONE
