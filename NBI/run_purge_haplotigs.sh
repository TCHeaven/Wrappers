#!/bin/bash
#SBATCH --job-name=purge_haplotigs
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 50G
#SBATCH -c 4
#SBATCH -p jic-medium
#SBATCH --time=2-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

Assembly=$1
MappingFile=$2
MappingIndex=$3
low=$4
mid=$5
high=$6
diploid_cuttoff=$7
junk_cuttoff=$8
hap_percent_cuttoff=$9
rep_percent_cuttoff=${10}
OutDir=${11}
OutFile=${12}

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo Assembly:
echo $Assembly
echo Mapping File:
echo $MappingFile
echo Mapping index File:
echo $MappingIndex
echo Lower cuttoff for read coverage:
echo $low
echo Mid point coverage between Het and Homozygous peaks:
echo $mid
echo Upper cuttoff for read coverage:
echo $high
echo "Auto-assign contig as s (suspected haplotig) if contig is diploid level of coverage:"
echo $diploid_cuttoff
echo "Auto-assign contig as j (junk) if this percentage or greater of the contig is low/high coverage:"
echo $junk_cuttoff
echo Percent cutoff for identifying a contig as a haplotig:
echo $hap_percent_cuttoff 
echo Percent cutoff for identifying repetitive contigs:
echo $rep_percent_cuttoff 
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo _
echo _

mkdir -p $WorkDir

ln -s $Assembly $WorkDir/genome.fa
ln -s $MappingFile $WorkDir/bam.bam
ln -s $MappingIndex $WorkDir/bam.bam.bai
cd $WorkDir

source /nbi/software/staging/RCSUPPORT-2652/stagingloader
source package 222eac79-310f-4d4b-8e1c-0cece4150333
source package /tgac/software/production/bin/abyss-1.3.5

purge_haplotigs hist -b bam.bam -g genome.fa -t 4

purge_haplotigs cov -i bam.bam.genecov -l $low -m $mid -h $high -o ${OutFile}_coverage_stats.csv -j $junk_cuttoff -s $diploid_cuttoff

purge_haplotigs purge -g genome.fas -c ${OutFile}_coverage_stats.csv -t 4 -o ${OutFile}_curated -d -b bam.bam -a $hap_percent_cuttoff -m $rep_percent_cuttoff 

purge_haplotigs  clip  -p ${OutFile}_curated.fasta  -h ${OutFile}_curated.haplotigs.fasta -o ${OutFile}_clip -t 4

purge_haplotigs  place  -p ${OutFile}_curated.fasta  -h ${OutFile}_curated.haplotigs.fasta -o ${OutFile}_out.tsv -t 4 -c -falconNaming

echo DONE
#rm -r $WorkDir
