#!/bin/bash
#SBATCH --job-name=omniHiC
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 30G
#SBATCH -c 32
#SBATCH -p jic-long
#SBATCH --time=30-00:00:00

##https://omni-c.readthedocs.io/en/latest/fastq_to_bam.html

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

Assembly=$1
Enzyme=$2
OutDir=$3
OutFile=$4
Read1=$5
Read2=$6
cpu=32

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
echo $Read2
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

echo "Creating BWA index..."
bwa index genome.fa

#bwa mem -t$cpu genome.fa Fread.fq.gz Rread.fq.gz > output.bam
#samtools sort -@$cpu -o sorted_output.bam output.bam
#samtools index -@$cpu sorted_output.bam
#samtools view -@$cpu -T genome.fa -C -o cram.cram sorted_output.bam
#samtools index -@$cpu cram.cram

samtools import -@$cpu -r ID:$(basename $Read1 | cut -d '_' -f1,2) -r CN:$(basename $Read1 | cut -d '_' -f1,2 | cut -d '-' -f2) -r PU:$(basename $Read1 | cut -d '_' -f1,2) -r SM:$(basename $Read1 | cut -d '_' -f1,2 | cut -d '-' -f1) Fread.fq.gz Rread.fq.gz -o cram.cram
samtools index -@$cpu cram.cram

echo "Mapping Illumina HiC reads..."
FROM=0
TO=$(cat cram.cram.crai | wc -l) #zcat
if [ "$TO" -gt 10000 ]; then
echo WARNING: very large HiC index file consider splitting
fi
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/cram_filter.sif cram_filter -n $FROM-$TO cram.cram cram2.cram
#samtools fastq -@$cpu -F0xA00 -nt cram.cram > bam1.bam
samtools fastq -@$cpu -F0xB00 -nt cram2.cram > bam1.bam
#samtools fastq -@$cpu -nt cram2.cram > bam1.bam
bwa mem -T 10 -t $cpu -5SPCp genome.fa bam1.bam -o bam2.bam
samtools fixmate -mpu -@$cpu bam2.bam bam3.bam 
samtools sort -@$cpu --write-index -l9 -o ${OutFile}.bam bam3.bam
ls ${OutFile}.bam

echo "Filtering BAM files..."
samtools view -@$cpu -h ${OutFile}.bam | ~/git_repos/Scripts/NBI/filter_five_end.pl | samtools sort -@$cpu - > ${OutFile}_filtered.bam
ls ${OutFile}_filtered.bam
samtools markdup --write-index ${OutFile}_filtered.bam ${OutFile}_mapped.bam
ls -lh

cp ${OutFile}_mapped.bam ${OutDir}/. 
cp ${OutFile}_mapped.bam.csi ${OutDir}/. 

echo DONE
rm -r $WorkDir

