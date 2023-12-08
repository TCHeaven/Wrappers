#!/bin/bash
#SBATCH --job-name=omniHiC
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 30G
#SBATCH -c 32
#SBATCH -p jic-medium,jic-long
#SBATCH --time=02-00:00:00

##https://omni-c.readthedocs.io/en/latest/fastq_to_bam.html

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

Assembly=$1
Enzyme=$2
OutDir=$3
OutFile=$4
Read1=$5
Read2=$6


echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo Assembly:
echo $Assembly
echo Enzyme:
echo $Enzyme
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
ln -s $Read1 $WorkDir/Fread.fq.gz
ln -s $Read2 $WorkDir/Rread.fq.gz
cd $WorkDir

source package 638df626-d658-40aa-80e5-14a275b7464b
source package /tgac/software/testing/bin/preseq-3.1.2
source package /tgac/software/testing/bin/pairtools-0.3.0
source bwa-0.7.17

samtools faidx genome.fa
cut -f1,2 genome.fa.fai > genome.genome

bwa index genome.fa
bwa mem -5SP -T0 -t 32 genome.fa Fread.fq.gz Rread.fq.gz -o ${OutFile}.sam

#this is the mark_dups step
pairtools parse --min-mapq 40 --walks-policy 5unique --max-inter-align-gap 30 --nproc-in 32 --nproc-out 32 --chroms-path genome.genome ${OutFile}.sam > parsed.pairsam
pairtools sort --nproc 32 --tmpdir=$WorkDir parsed.pairsam > sorted.pairsam
pairtools dedup --nproc-in 32 --nproc-out 32 --mark-dups --output-stats PCR_duplication_stats.txt --output dedup.pairsam sorted.pairsam
pairtools split --nproc-in 32 --nproc-out 32 --output-pairs mapped.pairs --output-sam unsorted.bam dedup.pairsam


samtools sort -@32 -T ${WorkDir}/temp.bam -o mapped.PT.bam unsorted.bam
samtools index mapped.PT.bam

singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 ~/git_repos/Scripts/NBI/get_qc.py -p PCR_duplication_stats.txt 2>&1 >> PCR_duplication_stats_report.txt
preseq lc_extrap -bam -pe -extrap 2.1e9 -step 1e8 -seg_len 1000000000 -output out.preseq mapped.PT.bam

ls -lh

cp genome.genome ${OutDir}/${OutFile}.genome
cp mapped.pairs ${OutDir}/${OutFile}_mapped.pairs
cp mapped.PT.bam ${OutDir}/${OutFile}_mapped.PT.bam
cp mapped.PT.bam.bai ${OutDir}/${OutFile}_mapped.PT.bam.bai
cp PCR_duplication_stats.txt ${OutDir}/${OutFile}_PCR_duplication_stats.txt
cp PCR_duplication_stats_report.txt ${OutDir}/${OutFile}_PCR_duplication_stats_report.txt
cp out.preseq ${OutDir}/${OutFile}_out.preseq

#cp unsorted.bam ../${OutFile}_unsorted.bam

echo DONE
rm -r $WorkDir
