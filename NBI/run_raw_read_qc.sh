#!/bin/bash
#SBATCH --job-name=qualimap
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 32G
#SBATCH -c 16
#SBATCH -p jic-medium, nbi-medium
#SBATCH --time=1-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

OutDir=$1
Reference_genome=$2
GFF=$3

Fread=$4
Rread=$5
Fread2=$6
Rread2=$7

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo ReadFiles:
echo $Fread
echo $Rread
echo $Fread2
echo $Rread2
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo Reference_genome:
echo $Reference_genome
echo Gff file:
echo $GFF
echo _
echo _

mkdir -p $WorkDir

ln -s $Reference_genome $WorkDir/genome.fa
ln -s $GFF $WorkDir/gff.gff
ln -s $Fread $WorkDir/fastq1.fq.gz
ln -s $Rread $WorkDir/fastq2.fq.gz
ln -s $Fread2 $WorkDir/fastq3.fq.gz
ln -s $Rread2 $WorkDir/fastq4.fq.gz
cd $WorkDir

source package aeee87c4-1923-4732-aca2-f2aff23580cc
source package fa33234e-dceb-4a58-9a78-7bcf9809edd7
source package a138abc4-ed60-4774-8db8-80b4770b1710
source package bc2bbbd1-c5bc-43ae-9c92-03124ded0d14
source package 3e7beb4d-f08b-4d6b-9b6a-f99cc91a38f9 #java
java17 -Xmx20G
#java -Xmx16G -jar qualimap #max heap size = memory available

if [ -h "gff.gff" ] && [ -f "gff.gff" ]; then
if [ -h "fastq4.fq.gz" ] && [ -f "fastq4.fq.gz" ]; then
echo Four input read files
mkdir ${OutDir}/fastqc
echo FastQC of $Fread
OutFile1=$(basename -a $Fread | cut -d '.' -f1)
OutFile2=$(basename -a $Rread | cut -d '.' -f1)
OutFile3=$(basename -a $Fread2 | cut -d '.' -f1)
OutFile4=$(basename -a $Rread2 | cut -d '.' -f1)
zcat fastq1.fq.gz | fastqc -t 16 stdin 
mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile1}_fastqc.html
zcat fastq2.fq.gz | fastqc -t 16 stdin 
mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile2}_fastqc.html
zcat fastq3.fq.gz | fastqc -t 16 stdin 
mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile3}_fastqc.html
zcat fastq4.fq.gz | fastqc -t 16 stdin 
mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile4}_fastqc.html

bwa index genome.fa
#zcat fastq1.fq.gz | zcat fastq3.fq.gz | gzip > fastq13.fq.gz
zcat fastq1.fq.gz fastq3.fq.gz | gzip > fastq13.fq.gz
#zcat fastq2.fq.gz | zcat fastq4.fq.gz | gzip > fastq24.fq.gz
zcat fastq2.fq.gz fastq4.fq.gz | gzip > fastq24.fq.gz
bwa mem genome.fa -t 16 fastq13.fq.gz fastq24.fq.gz -o sam.sam
samtools view -@16 -bS sam.sam > sam.bam
samtools sort -@16 sam.bam -o sorted_sam.bam

mkdir ${OutDir}/qualimap
mkdir ${OutDir}/bwa-mem
qualimap bamqc -nt 16 -bam sorted_sam.bam -c -gff gff.gff --java-mem-size=30G -outformat PDF -outdir ${OutDir}/qualimap -outfile ${OutFile1}_qualimap_gff.pdf
mv ${OutDir}/qualimap/genome_results.txt ${OutDir}/qualimap/${OutFile1}_genome_results_gff.txt 
mv sorted_sam.bam ${OutDir}/bwa-mem/${OutFile1}_sorted.bam
cd ${OutDir}/bwa-mem
samtools index -@16 ${OutDir}/bwa-mem/${OutFile1}_sorted.bam

if [ -h "fastq2.fq.gz" ] && [ -f "fastq2.fq.gz" ]; then
echo Two input read files
mkdir ${OutDir}/fastqc
echo FastQC of $Fread
OutFile1=$(basename -a $Fread | cut -d '.' -f1)
OutFile2=$(basename -a $Rread | cut -d '.' -f1)
zcat fastq1.fq.gz | fastqc -t 16 stdin 
mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile1}_fastqc.html
zcat fastq2.fq.gz | fastqc -t 16 stdin 
mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile2}_fastqc.html

bwa index genome.fa
bwa mem genome.fa -t 16 fastq1.fq.gz fastq2.fq.gz -o sam.sam
samtools view -@16 -bS sam.sam > sam.bam
samtools sort -@16 sam.bam -o sorted_sam.bam

mkdir ${OutDir}/qualimap
mkdir ${OutDir}/bwa-mem
qualimap bamqc -nt 16 -bam sorted_sam.bam -c -gff gff.gff --java-mem-size=30G -outformat PDF -outdir ${OutDir}/qualimap -outfile ${OutFile1}_qualimap_gff.pdf
mv ${OutDir}/qualimap/genome_results.txt ${OutDir}/qualimap/${OutFile1}_genome_results_gff.txt 
mv sorted_sam.bam ${OutDir}/bwa-mem/${OutFile1}_sorted.bam
cd ${OutDir}/bwa-mem
samtools index -@16 ${OutDir}/bwa-mem/${OutFile1}_sorted.bam

else 
echo One input read file
mkdir ${OutDir}/fastqc
echo FastQC of $Fread
OutFile1=$(basename -a $Fread | cut -d '.' -f1)
zcat fastq1.fq.gz | fastqc -t 16 stdin 
mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile1}_fastqc.html

bwa index genome.fa
bwa mem genome.fa -t 16 fastq1.fq.gz -o sam.sam
samtools view -@16 -bS sam.sam > sam.bam
samtools sort -@16 sam.bam -o sorted_sam.bam

mkdir ${OutDir}/qualimap
mkdir ${OutDir}/bwa-mem
qualimap bamqc -nt 16 -bam sorted_sam.bam -c -gff gff.gff --java-mem-size=30G -outformat PDF -outdir ${OutDir}/qualimap -outfile ${OutFile1}_qualimap_gff.pdf 
mv ${OutDir}/qualimap/genome_results.txt ${OutDir}/qualimap/${OutFile1}_genome_results_gff.txt 
mv sorted_sam.bam ${OutDir}/bwa-mem/${OutFile1}_sorted.bam
cd ${OutDir}/bwa-mem
samtools index -@16 ${OutDir}/bwa-mem/${OutFile1}_sorted.bam
fi
else
if [ -h "fastq4.fq.gz" ] && [ -f "fastq4.fq.gz" ]; then
echo Four input read files
mkdir ${OutDir}/fastqc
echo FastQC of $Fread
OutFile1=$(basename -a $Fread | cut -d '.' -f1)
OutFile2=$(basename -a $Rread | cut -d '.' -f1)
OutFile3=$(basename -a $Fread2 | cut -d '.' -f1)
OutFile4=$(basename -a $Rread2 | cut -d '.' -f1)
zcat fastq1.fq.gz | fastqc -t 16 stdin 
mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile1}_fastqc.html
zcat fastq2.fq.gz | fastqc -t 16 stdin 
mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile2}_fastqc.html
zcat fastq3.fq.gz | fastqc -t 16 stdin 
mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile3}_fastqc.html
zcat fastq4.fq.gz | fastqc -t 16 stdin 
mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile4}_fastqc.html

bwa index genome.fa
#zcat fastq1.fq.gz | zcat fastq3.fq.gz | gzip > fastq13.fq.gz
zcat fastq1.fq.gz fastq3.fq.gz | gzip > fastq13.fq.gz
#zcat fastq2.fq.gz | zcat fastq4.fq.gz | gzip > fastq24.fq.gz
zcat fastq2.fq.gz fastq4.fq.gz | gzip > fastq24.fq.gz
bwa mem genome.fa -t 16 fastq13.fq.gz fastq24.fq.gz -o sam.sam
samtools view -@16 -bS sam.sam > sam.bam
samtools sort -@16 sam.bam -o sorted_sam.bam

mkdir ${OutDir}/qualimap
mkdir ${OutDir}/bwa-mem
qualimap bamqc -nt 16 -bam sorted_sam.bam -c --java-mem-size=30G -outformat PDF -outdir ${OutDir}/qualimap -outfile ${OutFile1}_qualimap.pdf
mv ${OutDir}/qualimap/genome_results.txt ${OutDir}/qualimap/${OutFile1}_genome_results.txt 
mv sorted_sam.bam ${OutDir}/bwa-mem/${OutFile1}_sorted.bam
cd ${OutDir}/bwa-mem
samtools index -@16 ${OutDir}/bwa-mem/${OutFile1}_sorted.bam

if [ -h "fastq2.fq.gz" ] && [ -f "fastq2.fq.gz" ]; then
echo Two input read files
mkdir ${OutDir}/fastqc
echo FastQC of $Fread
OutFile1=$(basename -a $Fread | cut -d '.' -f1)
OutFile2=$(basename -a $Rread | cut -d '.' -f1)
zcat fastq1.fq.gz | fastqc -t 16 stdin 
mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile1}_fastqc.html
zcat fastq2.fq.gz | fastqc -t 16 stdin 
mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile2}_fastqc.html

bwa index genome.fa
bwa mem genome.fa -t 16 fastq1.fq.gz fastq2.fq.gz -o sam.sam
samtools view -@16 -bS sam.sam > sam.bam
samtools sort -@16 sam.bam -o sorted_sam.bam

mkdir ${OutDir}/qualimap
mkdir ${OutDir}/bwa-mem
qualimap bamqc -nt 16 -bam sorted_sam.bam -c --java-mem-size=30G -outformat PDF -outdir ${OutDir}/qualimap -outfile ${OutFile1}_qualimap.pdf
mv ${OutDir}/qualimap/genome_results.txt ${OutDir}/qualimap/${OutFile1}_genome_results.txt 
mv sorted_sam.bam ${OutDir}/bwa-mem/${OutFile1}_sorted.bam
cd ${OutDir}/bwa-mem
samtools index -@16 ${OutDir}/bwa-mem/${OutFile1}_sorted.bam

else 
echo One input read file
mkdir ${OutDir}/fastqc
echo FastQC of $Fread
OutFile1=$(basename -a $Fread | cut -d '.' -f1)
zcat fastq1.fq.gz | fastqc -t 16 stdin 
mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile1}_fastqc.html

bwa index genome.fa
bwa mem genome.fa -t 16 fastq1.fq.gz -o sam.sam
samtools view -@16 -bS sam.sam > sam.bam
samtools sort -@16 sam.bam -o sorted_sam.bam

mkdir ${OutDir}/qualimap
mkdir ${OutDir}/bwa-mem
qualimap bamqc -nt 16 -bam sorted_sam.bam -c --java-mem-size=30G -outformat PDF -outdir ${OutDir}/qualimap -outfile ${OutFile1}_qualimap.pdf 
mv ${OutDir}/qualimap/genome_results.txt ${OutDir}/qualimap/${OutFile1}_genome_results.txt 
mv sorted_sam.bam ${OutDir}/bwa-mem/${OutFile1}_sorted.bam
cd ${OutDir}/bwa-mem
samtools index -@16 ${OutDir}/bwa-mem/${OutFile1}_sorted.bam
fi
fi

echo DONE
rm -r $WorkDir
