#!/bin/bash
#SBATCH --job-name=bismark
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 100G
#SBATCH --nodes=1
#SBATCH -c 4
#SBATCH -p jic-medium,nbi-medium,jic-long,nbi-long
#SBATCH --time=2-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
OutDir=$1
OutFile=$2
reference_dir=$3
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
echo Reference Directory:
echo $reference_dir
echo Forward reads:
echo $Fread
echo Reverse reads:
echo $Rread
echo _
echo _

mkdir -p $WorkDir

ln -s $Fread ${WorkDir}/Fread_1.fq.gz
ln -s $Rread ${WorkDir}/Rread_2.fq.gz

cd $WorkDir
source package 33c48798-0827-4add-8153-909c1bd83e89
source package 29a74b59-88fc-4453-a30b-1310b34910b9
source package 638df626-d658-40aa-80e5-14a275b7464b

bismark --fastq -o . --basename $OutFile --bowtie2 -p 4 $reference_dir -1 Fread_1.fq.gz -2 Rread_2.fq.gz
deduplicate_bismark --paired --outfile $OutFile *_pe.bam
bismark_methylation_extractor --paired-end -o . --bedGraph --cytosine_report --genome_folder $reference_dir *deduplicated.bam
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/bismark0.24.2.sif bam2nuc --genome_folder $reference_dir *deduplicated.bam
bismark2report --output ${OutFile}_report.html --dir .
bismark2summary --basename $OutFile *deduplicated.bam

source package 638df626-d658-40aa-80e5-14a275b7464b
samtools view -@4 -bS *deduplicated.bam > sam.bam
rm sam.sam
samtools sort -@4 -o sam_sorted.bam sam.bam
rm sam.bam
samtools index -@4 sam_sorted.bam sam_sorted.bam.bai

tree
echo _
echo _
ls -lh

mkdir -p $OutDir
#mv sam_sorted.bam ${OutDir}/${OutFile}_deduplicated.bam
#mv sam_sorted.bam.bai ${OutDir}/${OutFile}_deduplicated.bam.bai
mv *report* ${OutDir}/.
mv *_stats.txt ${OutDir}/.

echo DONE
rm -r $WorkDir
