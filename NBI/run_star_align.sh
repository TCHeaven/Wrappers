#!/bin/bash
#SBATCH --job-name=star
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=30G
#SBATCH -p jic-largemem,RG-Saskia-Hogenhout
#SBATCH --time=02-00:00:00

source package 266730e5-6b24-4438-aecb-ab95f1940339

# Align RNAseq data to transcripts using STAR

# ---------------
# Step 1
# Collect inputs
# ---------------
GffProvided="N"
InGenome=$1
InReadF=$2
InReadR=$3
OutDir=$4
# determine if optional file for genemodels has been provided
if [ $5 ]; then
  GffProvided="Y"
  InGff=$5
fi
echo "InGenome: $InGenome"
echo "Fread: $InReadF"
echo "Rread: $InReadR"
echo "OutDir: $OutDir"

# Set working directory
CurDir=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

GenomeDir=$WorkDir/index
mkdir -p $GenomeDir
# Copy over input files
cd $WorkDir
cp $InGenome ./genome.fa
cp $InReadF ./Fread.fq.gz
cp $InReadR ./Rread.fq.gz
if [ $GffProvided == "Y" ]; then
cp $5 ./gff.gff
fi
# ---------------
# Step 2
# Create the Index File
# ---------------
echo "Building index file"
ParentFeature="Parent"
if [ $GffProvided == "N" ]; then
STAR \
--runMode genomeGenerate \
--genomeDir $GenomeDir \
--genomeFastaFiles genome.fa \
--runThreadN 10
elif [ $GffProvided == "Y" ]; then
STAR \
--runMode genomeGenerate \
--genomeDir $GenomeDir \
--genomeFastaFiles genome.fa \
--sjdbGTFtagExonParentTranscript $ParentFeature \
--sjdbGTFfile gff.gff \
--runThreadN 10 \
--sjdbOverhang 149
fi
# ---------------
# Step 2=3
# Run STAR
# ---------------
echo "Aligning RNAseq reads"
STAR \
--genomeDir $GenomeDir \
--outFileNamePrefix star_aligment \
--readFilesCommand zcat \
--readFilesIn Fread.fq.gz Rread.fq.gz \
--outSAMtype BAM SortedByCoordinate \
--outSAMstrandField intronMotif \
--runThreadN 10 \
--outReadsUnmapped Fastx \
--outSAMunmapped Within

#--outReadsUnmapped Fastx \
#string: output of unmapped and partially mapped (i.e. mapped only one mate
#of a paired end read) reads in separate file(s). Fastx = output in separate fasta/fastq files, Unmapped.out.mate1/2

#--outSAMunmapped Within
#output unmapped reads within the main SAM file (i.e. Aligned.out.sam)

#--outSAMattributes NH HI AS nM uT
#The SAM attributes can be specified by the user using --outSAMattributes A1 A2 A3 ... option
#which accept a list of 2-character SAM attributes. The implemented attributes are: NH HI NM MD
#AS nM jM jI XS. By default, STAR outputs NH HI AS nM attributes. uT = for unmapped reads, reason for not mapping

rm -r $GenomeDir
rm $InGenome
rm $InGff
rm $InReadF
rm $InReadR
cp -r $WorkDir/* $OutDir/.
rm -r $WorkDir
exit

