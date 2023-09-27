#!/bin/bash
#SBATCH --job-name=trinity
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 500G
#SBATCH -c 64
#SBATCH --ntasks-per-node=1
#SBATCH -p jic-long,nbi-long
#SBATCH --time=7-0:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
OutDir=$1
OutFile=$2
Freads_list=$3
Rreads_list=$4
SSFreads_list=$5
SSRreads_list=$6
Max_intron=$7
Genome=$8

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile

echo Forwards RNA reads:
echo $Freads_list
echo Reverse RNA reads:
echo $Rreads_list
echo Strand specific Forwards RNA reads:
echo $SSFreads_list
echo Strand specific Reverse RNA reads:
echo $SSRreads_list
echo Maximum intron length:
echo $Max_intron
echo Genome:
echo $Genome

echo _
echo _

mkdir -p $WorkDir
ln -s $Genome $WorkDir/genome.fa

cd $WorkDir

source package 09da5776-7777-44d1-9fac-4c372b38fd37
source package 638df626-d658-40aa-80e5-14a275b7464b
source package fa33234e-dceb-4a58-9a78-7bcf9809edd7
source package f9c1e0c5-d0e8-4ba0-9edd-88235400fa13
mkdir trinity_de_novo
mkdir trinity_guided
#Trinity --seqType fq --max_memory 475G --left $Freads_list  --right $Rreads_list --CPU 64 --verbose --output trinity_de_novo

#bwa index genome.fa
#zcat $(echo $Freads_list | tr ',' ' ') > fastq1.fq
#zcat $(echo $Rreads_list | tr ',' ' ') > fastq2.fq
#zcat $(echo $SSFreads_list | tr ',' ' ') > fastq3.fq
#zcat $(echo $SSRreads_list | tr ',' ' ') > fastq4.fq
#bwa mem genome.fa -t 64 fastq1.fq.gz fastq2.fq.gz -o sam.sam

hisat2-build -p 64 genome.fa genome
#hisat2 -p 64 --max-intronlen 25000 --dta-cufflinks -x genome -1 fastq1.fq -2 fastq2.fq -S unstranded_sam.sam
#hisat2 -p 64 --max-intronlen 25000 --dta-cufflinks --rna-strandness RF -x genome -1 fastq3.fq -2 fastq4.fq  -S stranded_sam.sam
hisat2 -p 64 --max-intronlen 25000 --dta-cufflinks -x genome -1 $Freads_list -2 $Rreads_list -S unstranded_sam.sam
hisat2 -p 64 --max-intronlen 25000 --dta-cufflinks --rna-strandness RF -x genome -1 $SSFreads_list -2 $SSRreads_list -S stranded_sam.sam
samtools merge -o sam.sam unstranded_sam.sam stranded_sam.sam

samtools view -bS sam.sam > sam.bam
samtools sort sam.bam -o sorted_sam.bam
samtools index sorted_sam.bam

Trinity --genome_guided_bam sorted_sam.bam --max_memory 475G --genome_guided_max_intron $Max_intron --CPU 64 --verbose --output trinity_guided

cp trinity_de_novo/Trinity.fasta ${OutDir}/${OutFile}_trinity_de_novo.fa
cp trinity_guided/Trinity.fasta ${OutDir}/${OutFile}_trinity_guided.fa
echo DONE
#rm -r $WorkDir
