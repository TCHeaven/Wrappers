#!/bin/bash
#SBATCH --job-name=qualimap
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 50G
#SBATCH -c 16
#SBATCH -p jic-medium, nbi-medium
#SBATCH --time=2-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

OutDir=$1
Reference_genome=$2
GFF=$3

Fread=$4
Rread=$5
Fread2=$6
Rread2=$7
Fread3=$8
Rread3=${9}
Fread4=${10}
Rread4=${11}
Fread5=${12}
Rread5=${13}

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo ReadFiles:
echo $Fread
echo $Rread
echo $Fread2
echo $Rread2
echo $Fread3
echo $Rread3
echo $Fread4
echo $Rread4
echo $Fread5
echo $Rread5
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
ln -s $Fread3 $WorkDir/fastq5.fq.gz
ln -s $Rread3 $WorkDir/fastq6.fq.gz
ln -s $Fread4 $WorkDir/fastq7.fq.gz
ln -s $Rread4 $WorkDir/fastq8.fq.gz
ln -s $Fread5 $WorkDir/fastq9.fq.gz
ln -s $Rread5 $WorkDir/fastq10.fq.gz
cd $WorkDir

source package aeee87c4-1923-4732-aca2-f2aff23580cc
source package fa33234e-dceb-4a58-9a78-7bcf9809edd7
source package a138abc4-ed60-4774-8db8-80b4770b1710
source package bc2bbbd1-c5bc-43ae-9c92-03124ded0d14
source package 3e7beb4d-f08b-4d6b-9b6a-f99cc91a38f9 #java
#java17 -Xmx20G
#java -Xmx16G -jar qualimap #max heap size = memory available

if [ "$gff" != "NA" ] && [ -h "gff.gff" ] && [ -f "gff.gff" ]; then
	if [ -h "fastq8.fq.gz" ] && [ -f "fastq8.fq.gz" ]; then
		echo Four input read files
		mkdir ${OutDir}/fastqc
		echo FastQC of $Fread
		OutFile1=$(basename -a $Fread | cut -d '.' -f1)
		OutFile2=$(basename -a $Rread | cut -d '.' -f1)
		OutFile3=$(basename -a $Fread2 | cut -d '.' -f1)
		OutFile4=$(basename -a $Rread2 | cut -d '.' -f1)
		OutFile5=$(basename -a $Fread3 | cut -d '.' -f1)
		OutFile6=$(basename -a $Rread3 | cut -d '.' -f1)		
		OutFile7=$(basename -a $Fread4 | cut -d '.' -f1)
		OutFile8=$(basename -a $Rread4 | cut -d '.' -f1)
		OutFile9=$(basename -a $Fread5 | cut -d '.' -f1)
		OutFile10=$(basename -a $Rread5 | cut -d '.' -f1)
		zcat fastq1.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile1}_fastqc.html
		zcat fastq2.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile2}_fastqc.html
		zcat fastq3.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile3}_fastqc.html
		zcat fastq4.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile4}_fastqc.html
		zcat fastq5.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile5}_fastqc.html
		zcat fastq6.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile6}_fastqc.html
		zcat fastq7.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile7}_fastqc.html
		zcat fastq8.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile8}_fastqc.html
		zcat fastq9.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile9}_fastqc.html
		zcat fastq10.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile10}_fastqc.html

		bwa index genome.fa
		#zcat fastq1.fq.gz | zcat fastq3.fq.gz | gzip > fastq13.fq.gz
		zcat fastq1.fq.gz fastq3.fq.gz fastq5.fq.gz fastq7.fq.gz fastq9.fq.gz | gzip > fastq13579.fq.gz
		#zcat fastq2.fq.gz | zcat fastq4.fq.gz | gzip > fastq24.fq.gz
		zcat fastq2.fq.gz fastq4.fq.gz fastq6.fq.gz fastq8.fq.gz fastq10.fq.gz | gzip > fastq246810.fq.gz
		singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/bsmap2.9.sif bsmap -a fastq1.fq.gz -b fastq2.fq.gz -d genome.fa -o sam.sam -p 16 -S 1234 -V 2
		samtools view -@16 -bS sam.sam > sam.bam
		samtools sort -@16 sam.bam -o sorted_sam.bam

		mkdir ${OutDir}/qualimap
		qualimap bamqc -nt 16 -bam sorted_sam.bam -c -gff gff.gff --java-mem-size=30G -outformat PDF -outdir ${OutDir}/qualimap -outfile ${OutFile1}_qualimap_gff.pdf
		mv ${OutDir}/qualimap/genome_results.txt ${OutDir}/qualimap/${OutFile1}_genome_results_gff.txt 

	elif [ -h "fastq8.fq.gz" ] && [ -f "fastq8.fq.gz" ]; then
		echo Four input read files
		mkdir ${OutDir}/fastqc
		echo FastQC of $Fread
		OutFile1=$(basename -a $Fread | cut -d '.' -f1)
		OutFile2=$(basename -a $Rread | cut -d '.' -f1)
		OutFile3=$(basename -a $Fread2 | cut -d '.' -f1)
		OutFile4=$(basename -a $Rread2 | cut -d '.' -f1)
		OutFile5=$(basename -a $Fread3 | cut -d '.' -f1)
		OutFile6=$(basename -a $Rread3 | cut -d '.' -f1)		
		OutFile7=$(basename -a $Fread4 | cut -d '.' -f1)
		OutFile8=$(basename -a $Rread4 | cut -d '.' -f1)
		zcat fastq1.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile1}_fastqc.html
		zcat fastq2.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile2}_fastqc.html
		zcat fastq3.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile3}_fastqc.html
		zcat fastq4.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile4}_fastqc.html
		zcat fastq5.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile5}_fastqc.html
		zcat fastq6.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile6}_fastqc.html
		zcat fastq7.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile7}_fastqc.html
		zcat fastq8.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile8}_fastqc.html

		bwa index genome.fa
		#zcat fastq1.fq.gz | zcat fastq3.fq.gz | gzip > fastq13.fq.gz
		zcat fastq1.fq.gz fastq3.fq.gz fastq5.fq.gz fastq7.fq.gz | gzip > fastq1357.fq.gz
		#zcat fastq2.fq.gz | zcat fastq4.fq.gz | gzip > fastq24.fq.gz
		zcat fastq2.fq.gz fastq4.fq.gz fastq6.fq.gz fastq8.fq.gz | gzip > fastq2468.fq.gz
		singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/bsmap2.9.sif bsmap -a fastq1.fq.gz -b fastq2.fq.gz -d genome.fa -o sam.sam -p 16 -S 1234 -V 2 
		samtools view -@16 -bS sam.sam > sam.bam
		samtools sort -@16 sam.bam -o sorted_sam.bam

		mkdir ${OutDir}/qualimap
		qualimap bamqc -nt 16 -bam sorted_sam.bam -c -gff gff.gff --java-mem-size=30G -outformat PDF -outdir ${OutDir}/qualimap -outfile ${OutFile1}_qualimap_gff.pdf
		mv ${OutDir}/qualimap/genome_results.txt ${OutDir}/qualimap/${OutFile1}_genome_results_gff.txt 

	elif [ -h "fastq6.fq.gz" ] && [ -f "fastq6.fq.gz" ]; then
		echo Four input read files
		mkdir ${OutDir}/fastqc
		echo FastQC of $Fread
		OutFile1=$(basename -a $Fread | cut -d '.' -f1)
		OutFile2=$(basename -a $Rread | cut -d '.' -f1)
		OutFile3=$(basename -a $Fread2 | cut -d '.' -f1)
		OutFile4=$(basename -a $Rread2 | cut -d '.' -f1)
		OutFile5=$(basename -a $Fread3 | cut -d '.' -f1)
		OutFile6=$(basename -a $Rread3 | cut -d '.' -f1)		
		zcat fastq1.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile1}_fastqc.html
		zcat fastq2.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile2}_fastqc.html
		zcat fastq3.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile3}_fastqc.html
		zcat fastq4.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile4}_fastqc.html
		zcat fastq5.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile5}_fastqc.html
		zcat fastq6.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile6}_fastqc.html

		bwa index genome.fa
		#zcat fastq1.fq.gz | zcat fastq3.fq.gz | gzip > fastq13.fq.gz
		zcat fastq1.fq.gz fastq3.fq.gz fastq5.fq.gz | gzip > fastq135.fq.gz
		#zcat fastq2.fq.gz | zcat fastq4.fq.gz | gzip > fastq24.fq.gz
		zcat fastq2.fq.gz fastq4.fq.gz fastq6.fq.gz | gzip > fastq246.fq.gz
		singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/bsmap2.9.sif bsmap -a fastq1.fq.gz -b fastq2.fq.gz -d genome.fa -o sam.sam -p 16 -S 1234 -V 2 
		samtools view -@16 -bS sam.sam > sam.bam
		samtools sort -@16 sam.bam -o sorted_sam.bam

		mkdir ${OutDir}/qualimap
		qualimap bamqc -nt 16 -bam sorted_sam.bam -c -gff gff.gff --java-mem-size=30G -outformat PDF -outdir ${OutDir}/qualimap -outfile ${OutFile1}_qualimap_gff.pdf
		mv ${OutDir}/qualimap/genome_results.txt ${OutDir}/qualimap/${OutFile1}_genome_results_gff.txt 

	elif [ -h "fastq4.fq.gz" ] && [ -f "fastq4.fq.gz" ]; then
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
		singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/bsmap2.9.sif bsmap -a fastq1.fq.gz -b fastq2.fq.gz -d genome.fa -o sam.sam -p 16 -S 1234 -V 2
		samtools view -@16 -bS sam.sam > sam.bam
		samtools sort -@16 sam.bam -o sorted_sam.bam

		mkdir ${OutDir}/qualimap
		qualimap bamqc -nt 16 -bam sorted_sam.bam -c -gff gff.gff --java-mem-size=30G -outformat PDF -outdir ${OutDir}/qualimap -outfile ${OutFile1}_qualimap_gff.pdf
		mv ${OutDir}/qualimap/genome_results.txt ${OutDir}/qualimap/${OutFile1}_genome_results_gff.txt 

	elif [ -h "fastq2.fq.gz" ] && [ -f "fastq2.fq.gz" ]; then
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
		singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/bsmap2.9.sif bsmap -a fastq1.fq.gz -b fastq2.fq.gz -d genome.fa -o sam.sam -p 16 -S 1234 -V 2
		samtools view -@16 -bS sam.sam > sam.bam
		samtools sort -@16 sam.bam -o sorted_sam.bam

		mkdir ${OutDir}/qualimap
		qualimap bamqc -nt 16 -bam sorted_sam.bam -c -gff gff.gff --java-mem-size=30G -outformat PDF -outdir ${OutDir}/qualimap -outfile ${OutFile1}_qualimap_gff.pdf
		mv ${OutDir}/qualimap/genome_results.txt ${OutDir}/qualimap/${OutFile1}_genome_results_gff.txt 

	else 
		echo One input read file
		mkdir ${OutDir}/fastqc
		echo FastQC of $Fread
		OutFile1=$(basename -a $Fread | cut -d '.' -f1)
		zcat fastq1.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile1}_fastqc.html

		bwa index genome.fa
		singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/bsmap2.9.sif bsmap -a fastq1.fq.gz -b fastq2.fq.gz -d genome.fa -o sam.sam -p 16 -S 1234 -V 2
		samtools view -@16 -bS sam.sam > sam.bam
		samtools sort -@16 sam.bam -o sorted_sam.bam

		mkdir ${OutDir}/qualimap
		qualimap bamqc -nt 16 -bam sorted_sam.bam -c -gff gff.gff --java-mem-size=30G -outformat PDF -outdir ${OutDir}/qualimap -outfile ${OutFile1}_qualimap_gff.pdf 
		mv ${OutDir}/qualimap/genome_results.txt ${OutDir}/qualimap/${OutFile1}_genome_results_gff.txt 

	fi
else
	if [ -h "fastq8.fq.gz" ] && [ -f "fastq8.fq.gz" ]; then
		echo Four input read files
		mkdir ${OutDir}/fastqc
		echo FastQC of $Fread
		OutFile1=$(basename -a $Fread | cut -d '.' -f1)
		OutFile2=$(basename -a $Rread | cut -d '.' -f1)
		OutFile3=$(basename -a $Fread2 | cut -d '.' -f1)
		OutFile4=$(basename -a $Rread2 | cut -d '.' -f1)
		OutFile5=$(basename -a $Fread3 | cut -d '.' -f1)
		OutFile6=$(basename -a $Rread3 | cut -d '.' -f1)		
		OutFile7=$(basename -a $Fread4 | cut -d '.' -f1)
		OutFile8=$(basename -a $Rread4 | cut -d '.' -f1)
		OutFile9=$(basename -a $Fread5 | cut -d '.' -f1)
		OutFile10=$(basename -a $Rread5 | cut -d '.' -f1)
		zcat fastq1.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile1}_fastqc.html
		zcat fastq2.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile2}_fastqc.html
		zcat fastq3.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile3}_fastqc.html
		zcat fastq4.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile4}_fastqc.html
		zcat fastq5.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile5}_fastqc.html
		zcat fastq6.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile6}_fastqc.html
		zcat fastq7.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile7}_fastqc.html
		zcat fastq8.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile8}_fastqc.html
		zcat fastq9.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile9}_fastqc.html
		zcat fastq10.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile10}_fastqc.html

		bwa index genome.fa
		#zcat fastq1.fq.gz | zcat fastq3.fq.gz | gzip > fastq13.fq.gz
		zcat fastq1.fq.gz fastq3.fq.gz fastq5.fq.gz fastq7.fq.gz fastq9.fq.gz | gzip > fastq13579.fq.gz
		#zcat fastq2.fq.gz | zcat fastq4.fq.gz | gzip > fastq24.fq.gz
		zcat fastq2.fq.gz fastq4.fq.gz fastq6.fq.gz fastq8.fq.gz fastq10.fq.gz | gzip > fastq246810.fq.gz
		singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/bsmap2.9.sif bsmap -a fastq1.fq.gz -b fastq2.fq.gz -d genome.fa -o sam.sam -p 16 -S 1234 -V 2 
		samtools view -@16 -bS sam.sam > sam.bam
		samtools sort -@16 sam.bam -o sorted_sam.bam

		mkdir ${OutDir}/qualimap
		qualimap bamqc -nt 16 -bam sorted_sam.bam -c --java-mem-size=30G -outformat PDF -outdir ${OutDir}/qualimap -outfile ${OutFile1}_qualimap_gff.pdf
		mv ${OutDir}/qualimap/genome_results.txt ${OutDir}/qualimap/${OutFile1}_genome_results_gff.txt 

	elif [ -h "fastq8.fq.gz" ] && [ -f "fastq8.fq.gz" ]; then
		echo Four input read files
		mkdir ${OutDir}/fastqc
		echo FastQC of $Fread
		OutFile1=$(basename -a $Fread | cut -d '.' -f1)
		OutFile2=$(basename -a $Rread | cut -d '.' -f1)
		OutFile3=$(basename -a $Fread2 | cut -d '.' -f1)
		OutFile4=$(basename -a $Rread2 | cut -d '.' -f1)
		OutFile5=$(basename -a $Fread3 | cut -d '.' -f1)
		OutFile6=$(basename -a $Rread3 | cut -d '.' -f1)		
		OutFile7=$(basename -a $Fread4 | cut -d '.' -f1)
		OutFile8=$(basename -a $Rread4 | cut -d '.' -f1)
		zcat fastq1.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile1}_fastqc.html
		zcat fastq2.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile2}_fastqc.html
		zcat fastq3.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile3}_fastqc.html
		zcat fastq4.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile4}_fastqc.html
		zcat fastq5.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile5}_fastqc.html
		zcat fastq6.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile6}_fastqc.html
		zcat fastq7.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile7}_fastqc.html
		zcat fastq8.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile8}_fastqc.html

		bwa index genome.fa
		#zcat fastq1.fq.gz | zcat fastq3.fq.gz | gzip > fastq13.fq.gz
		zcat fastq1.fq.gz fastq3.fq.gz fastq5.fq.gz fastq7.fq.gz | gzip > fastq1357.fq.gz
		#zcat fastq2.fq.gz | zcat fastq4.fq.gz | gzip > fastq24.fq.gz
		zcat fastq2.fq.gz fastq4.fq.gz fastq6.fq.gz fastq8.fq.gz | gzip > fastq2468.fq.gz
		singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/bsmap2.9.sif bsmap -a fastq1.fq.gz -b fastq2.fq.gz -d genome.fa -o sam.sam -p 16 -S 1234 -V 2 
		samtools view -@16 -bS sam.sam > sam.bam
		samtools sort -@16 sam.bam -o sorted_sam.bam

		mkdir ${OutDir}/qualimap
		qualimap bamqc -nt 16 -bam sorted_sam.bam -c --java-mem-size=30G -outformat PDF -outdir ${OutDir}/qualimap -outfile ${OutFile1}_qualimap_gff.pdf
		mv ${OutDir}/qualimap/genome_results.txt ${OutDir}/qualimap/${OutFile1}_genome_results_gff.txt 

	elif [ -h "fastq6.fq.gz" ] && [ -f "fastq6.fq.gz" ]; then
		echo Four input read files
		mkdir ${OutDir}/fastqc
		echo FastQC of $Fread
		OutFile1=$(basename -a $Fread | cut -d '.' -f1)
		OutFile2=$(basename -a $Rread | cut -d '.' -f1)
		OutFile3=$(basename -a $Fread2 | cut -d '.' -f1)
		OutFile4=$(basename -a $Rread2 | cut -d '.' -f1)
		OutFile5=$(basename -a $Fread3 | cut -d '.' -f1)
		OutFile6=$(basename -a $Rread3 | cut -d '.' -f1)		
		zcat fastq1.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile1}_fastqc.html
		zcat fastq2.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile2}_fastqc.html
		zcat fastq3.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile3}_fastqc.html
		zcat fastq4.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile4}_fastqc.html
		zcat fastq5.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile5}_fastqc.html
		zcat fastq6.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile6}_fastqc.html

		bwa index genome.fa
		#zcat fastq1.fq.gz | zcat fastq3.fq.gz | gzip > fastq13.fq.gz
		zcat fastq1.fq.gz fastq3.fq.gz fastq5.fq.gz | gzip > fastq135.fq.gz
		#zcat fastq2.fq.gz | zcat fastq4.fq.gz | gzip > fastq24.fq.gz
		zcat fastq2.fq.gz fastq4.fq.gz fastq6.fq.gz | gzip > fastq246.fq.gz
		singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/bsmap2.9.sif bsmap -a fastq1.fq.gz -b fastq2.fq.gz -d genome.fa -o sam.sam -p 16 -S 1234 -V 2 
		samtools view -@16 -bS sam.sam > sam.bam
		samtools sort -@16 sam.bam -o sorted_sam.bam

		mkdir ${OutDir}/qualimap
		qualimap bamqc -nt 16 -bam sorted_sam.bam -c --java-mem-size=30G -outformat PDF -outdir ${OutDir}/qualimap -outfile ${OutFile1}_qualimap_gff.pdf
		mv ${OutDir}/qualimap/genome_results.txt ${OutDir}/qualimap/${OutFile1}_genome_results_gff.txt 

	elif [ -h "fastq4.fq.gz" ] && [ -f "fastq4.fq.gz" ]; then
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
		singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/bsmap2.9.sif bsmap -a fastq1.fq.gz -b fastq2.fq.gz -d genome.fa -o sam.sam -p 16 -S 1234 -V 2
		samtools view -@16 -bS sam.sam > sam.bam
		samtools sort -@16 sam.bam -o sorted_sam.bam

		mkdir ${OutDir}/qualimap
		qualimap bamqc -nt 16 -bam sorted_sam.bam -c --java-mem-size=30G -outformat PDF -outdir ${OutDir}/qualimap -outfile ${OutFile1}_qualimap.pdf
		mv ${OutDir}/qualimap/genome_results.txt ${OutDir}/qualimap/${OutFile1}_genome_results.txt 

	elif [ -h "fastq2.fq.gz" ] && [ -f "fastq2.fq.gz" ]; then
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
		singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/bsmap2.9.sif bsmap -a fastq1.fq.gz -b fastq2.fq.gz -d genome.fa -o sam.sam -p 16 -S 1234 -V 2 
		samtools view -@16 -bS sam.sam > sam.bam
		samtools sort -@16 sam.bam -o sorted_sam.bam

		mkdir ${OutDir}/qualimap
		qualimap bamqc -nt 16 -bam sorted_sam.bam -c --java-mem-size=30G -outformat PDF -outdir ${OutDir}/qualimap -outfile ${OutFile1}_qualimap.pdf
		mv ${OutDir}/qualimap/genome_results.txt ${OutDir}/qualimap/${OutFile1}_genome_results.txt 

	else 
		echo One input read file
		mkdir ${OutDir}/fastqc
		echo FastQC of $Fread
		OutFile1=$(basename -a $Fread | cut -d '.' -f1)
		zcat fastq1.fq.gz | fastqc -t 16 stdin 
		mv stdin_fastqc.html ${OutDir}/fastqc/${OutFile1}_fastqc.html 
	fi
fi

ls -lh
echo DONE
rm -r $WorkDir
