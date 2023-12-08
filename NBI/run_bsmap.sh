#!/bin/bash
#SBATCH --job-name=bsmap
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 50G
#SBATCH --nodes=1
#SBATCH -c 16
#SBATCH -p jic-medium,nbi-medium,jic-long,nbi-long
#SBATCH --time=2-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
OutDir=$1
OutFile=$2
reference=$3
Fread=$4
Rread=$5

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo Reference:
echo $reference
echo Forward reads:
echo $Fread
echo Reverse reads:
echo $Rread
echo _
echo _

mkdir -p $WorkDir

ln -s $Fread ${WorkDir}/Fread.fa
ln -s $Rread ${WorkDir}/Rread.fa
ln -s $reference ${WorkDir}/genome.fa

cd $WorkDir

singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/bsmap2.9.sif bsmap -a Fread.fa -b Rread.fa -d genome.fa -o ${OutFile}.bsp -p 16 -S 1234 -V 2 
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/bsmap2.9.sif methratio.py -d genome.fa -o ${OutFile}_ratios.txt -u -p -z ${OutFile}.bsp #this does not work with .sam/bam files for some reason - neither does the bsp2sam.sh script
rm ${OutFile}.bsp
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/bsmap2.9.sif bsmap -a Fread.fa -b Rread.fa -d genome.fa -o sam.sam -p 16 -S 1234 -V 2 

source package 638df626-d658-40aa-80e5-14a275b7464b
samtools view -@16 -bS sam.sam > sam.bam
rm sam.sam
samtools sort -@16 -o sam_sorted.bam sam.bam
rm sam.bam
samtools index -@16 sam_sorted.bam sam_sorted.bam.bai

tree
echo _
echo _
ls -lh

mkdir -p $OutDir
mv sam_sorted.bam ${OutDir}/${OutFile}.bam
mv sam_sorted.bam.bai ${OutDir}/${OutFile}.bam.bai
mv ${OutFile}_ratios.txt ${OutDir}/${OutFile}_ratios.txt

echo DONE
rm -r $WorkDir
