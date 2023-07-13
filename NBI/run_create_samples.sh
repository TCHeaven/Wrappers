#!/bin/bash
#SBATCH --job-name=create_sample_sequence_files
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 500G
#SBATCH -c 1
#SBATCH -p jic-long,nbi-long
#SBATCH --time=30-00:00:00

CurPath=$PWD
#WorkDir=${TMPDIR}/${SLURM_JOB_ID}
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
InFile=$1
OutDir=$2
OutFile=$3
fasta=$4

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo vcfFile:
echo $InFile
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo fastaFile:
echo $fasta
echo _
echo _

mkdir -p $WorkDir
mkdir ${OutDir}/hom
mkdir ${OutDir}/het

cp $InFile $WorkDir/vcf.vcf.gz
cp $fasta $WorkDir/fasta.fa
cd $WorkDir

(zgrep "^#" vcf.vcf.gz; zgrep -v "^#" vcf.vcf.gz | sort -k1,1 -k2,2n) | gzip > sorted.vcf.gz
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 /hpc-home/did23faz/git_repos/Scripts/NBI/create_sample_sequences.py sorted.vcf.gz fasta.fa $OutDir/hom
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 /hpc-home/did23faz/git_repos/Scripts/NBI/create_sample_sequences_het.py sorted.vcf.gz fasta.fa $OutDir/het 

echo DONE
rm -r $WorkDir

