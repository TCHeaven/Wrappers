#!/bin/bash
#SBATCH --job-name=3ddna
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 80G
#SBATCH -c 16
#SBATCH -p jic-long
#SBATCH --time=30-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

Assembly=$1
OutDir=$2
OutFile=$3
Read1=$4
Read2=$5

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo Assembly:
echo $Assembly
echo Reads:
echo $Read1
echo Read2
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo _
echo _

mkdir -p $WorkDir

ln -s $Assembly $WorkDir/genome.fa
cd $WorkDir

source package fcb78328-af4f-424b-9916-c46bf8fab592
source package 81c2d095-ba51-4eee-b471-19b7f3b1b117
source samtools-1.9
source bwa-0.7.17

awk -f ~/git_repos/Scripts/NBI/wrap-fasta-sequence.awk genome.fa > genome_wrapped.fa

singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 ~/git_repos/Scripts/NBI/generate_site_positions.py Phase $OutFile genome_wrapped.fa

bwa index genome_wrapped.fa
samtools faidx genome_wrapped.fa

mkdir -p juicer/fastq
ln -s $Read1 $WorkDir/juicer/fastq/read_R1.fastq.gz
ln -s $Read2 $WorkDir/juicer/fastq/read_R2.fastq.gz
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/juicer.sif juicer.sh -t 16 -d $WorkDir/juicer -g saundersiae -z genome_wrapped.fa -y ${OutFile}_Phase.txt -p genome_wrapped.fa.fai -D /opt/juicer-1.6.2/CPU
cd aligned
run-asm-pipeline.sh --build-gapped-map -m diploid --rounds 1 --editor-repeat-coverage 5 --editor-saturation-centile 10 genome_wrapped.fa merged_nodups.txt
