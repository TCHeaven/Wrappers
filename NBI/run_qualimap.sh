#!/bin/bash
#SBATCH --job-name=qualimap
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 32G
#SBATCH -c 16
#SBATCH -p jic-short,nbi-short
#SBATCH --time=0-02:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

BamFile=$1
Reference_genome=$2
OutDir=$3
Gff=$4
Prefix=$(basename $BamFile | sed 's@.bam@@g')

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo OutFile:
echo $Prefix
echo BamFile:
echo $BamFile
echo Reference_genome:
echo $Reference_genome
echo Gff:
echo $Gff
echo _
echo _

mkdir -p $WorkDir

ln -s $BamFile $WorkDir/bam.bam
ln -s $Reference_genome $WorkDir/genome.fa
cd $WorkDir

source package aeee87c4-1923-4732-aca2-f2aff23580cc
source package fa33234e-dceb-4a58-9a78-7bcf9809edd7
source package a138abc4-ed60-4774-8db8-80b4770b1710
source package bc2bbbd1-c5bc-43ae-9c92-03124ded0d14
source package 3e7beb4d-f08b-4d6b-9b6a-f99cc91a38f9 #java
java17 -Xmx20G
#java -Xmx16G -jar qualimap #max heap size = memory available

samtools sort -@16 bam.bam -o sorted_bam.bam
mkdir ${OutDir}/qualimap
if [ "$Gff" != "0" ] && [ "$Gff" != "NA" ]; then
qualimap bamqc -nt 16 -bam sorted_bam.bam -c -gff $Gff --java-mem-size=30G -outformat PDF -outdir ${OutDir}/qualimap -outfile ${Prefix}_qualimap.pdf
else
qualimap bamqc -nt 16 -bam sorted_bam.bam -c --java-mem-size=30G -outformat PDF -outdir ${OutDir}/qualimap -outfile ${Prefix}_qualimap.pdf
fi

mv ${OutDir}/qualimap/genome_results.txt ${OutDir}/qualimap/${Prefix}_genome_results.txt
 
echo DONE
rm -r $WorkDir
