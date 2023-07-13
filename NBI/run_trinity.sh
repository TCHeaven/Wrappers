#!/bin/bash
#SBATCH --job-name=trinity
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 150G
#SBATCH -c 16
#SBATCH --ntasks-per-node=1
#SBATCH -p jic-long,nbi-long
#SBATCH --time=7-0:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
OutDir=$1
OutFile=$2
Freads_list=$3
Rreads_list=$4
Max_intron=$5
Genome=$6

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
mkdir trinity_de_novo
mkdir trinity_guided
Trinity --seqType fq --max_memory 150G --left $Freads_list  --right $Rreads_list --CPU 16 --verbose --output trinity_de_novo

#Unstranded RNA-seq data were aligned to the genome with HISAT2 with the parameters “–max-intronlen 25000 –dtacufflinks” followed by sorting and indexing with SAMtools v1.3 (Li et al. 2009).
#Strand-specific RNA-seq was mapped as for the unstranded data, with the addition of the HISAT2 parameter “–rna-strandness RF.”

bwa index genome.fa
zcat $(echo $Freads_list | tr ',' ' ') | gzip > fastq1.fq.gz
zcat $(echo $Rreads_list | tr ',' ' ') | gzip > fastq2.fq.gz
bwa mem genome.fa -t 16 fastq1.fq.gz fastq2.fq.gz -o sam.sam
samtools view -bS sam.sam > sam.bam
samtools sort sam.bam -o sorted_sam.bam

Trinity --genome_guided_bam sam.bam --max_memory 150G --genome_guided_max_intron $Max_intron --CPU 16 --verbose --output trinity_guided

#cp *${OutFile} $OutDir/.
echo DONE
#rm -r $WorkDir