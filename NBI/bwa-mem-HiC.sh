#!/bin/bash
#SBATCH --job-name=bwa
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 50G
#SBATCH --nodes=1
#SBATCH -c 4
#SBATCH -p jic-medium,nbi-medium
#SBATCH --time=2-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
OutDir=$1
OutFile=$2
Reference=$3

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo Reference:
echo $Reference
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo ReadFiles:
echo 1:
echo ${4}
echo 2:
echo ${5}

mkdir $WorkDir
ln -s ${4} $WorkDir/Fread.fq.gz
ln -s ${5} $WorkDir/Rread.fq.gz
ln -s $Reference $WorkDir/reference.fasta

cd $WorkDir
source package /nbi/software/testing/bin/bwa-0.7.15
source package 638df626-d658-40aa-80e5-14a275b7464b
bwa index -a bwtsw reference.fasta
bwa mem -5SP -t 4 reference.fasta Fread.fq.gz Rread.fq.gz > $OutFile.sam
samtools view -bS ${OutFile}.sam > ${OutFile}.bam

cp ${OutFile}.bam $OutDir/.
echo DONE
rm -r $WorkDir
