#!/bin/bash
#SBATCH --job-name=kat_comp
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 450G
#SBATCH --nodes=1
#SBATCH -c 32
#SBATCH -p nbi-medium,jic-medium,nbi-long,jic-long
#SBATCH --time=2-00:00:00

CurPath=$PWD
#WorkDir=${TMPDIR}/${SLURM_JOB_ID}
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
OutDir=$1
OutFile=$2
InFile=$3

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo Genome:
echo $InFile
echo ReadFiles:
echo 1:
echo $4
echo 2:
echo $5
echo _
echo _

mkdir -p $WorkDir

cp $InFile $WorkDir/genome.fa
cp $4 $WorkDir/fasta1.fq.gz
cp $5 $WorkDir/fasta2.fq.gz

cd $WorkDir

source package 7f4fb852-f5c2-4e4b-b9a6-e648176d5543
#kat comp -t 32 -o ${OutFile}_31 -m 31 -H 100000000 -I 100000000 'fasta1.fq.gz fasta2.fq.gz' 'genome.fa'
#kat comp -t 32 -o ${OutFile}_31 -m 31 -H 100000000 -I 100000000 'fasta1.fq.gz fasta2.fq.gz' genome.fa
#kat comp -t 32 -o ${OutFile}_31 -m 31 -H 100000000 -I 100000000 'fasta*.fq.gz' genome.fa
#kat comp -t 32 -o ${OutFile}_31 -m 31 -H 100000000 -I 100000000 fasta*.fq.gz genome.fa
#kat comp -t 32 -m 31 -H 100000000 -I 100000000 -o ${OutFile}_31 <(gunzip fasta*.fq.gz) genome.fa #divide by zero encountered in double_scalars
#zcat fasta1.fq.gz fasta2.fq.gz | gzip > fasta3.fq.gz
#kat comp -t 32 -m 31 -H 100000000 -I 100000000 -o ${OutFile}_31 <(gunzip fasta3.fq.gz) genome.fa #divide by zero encountered in double_scalars

zcat fasta1.fq.gz fasta2.fq.gz > fasta.fq
gzip fasta.fq
kat comp -t 32 -o ${OutFile}_31 -m 31 -H 100000000 -I 100000000 'fasta.fq.gz' genome.fa

kat plot spectra-cn -x 50 -o ${OutFile}_plot50_31 ${OutFile}_31-main.mx
kat plot spectra-cn -x 100 -o ${OutFile}_plot100_31 ${OutFile}_31-main.mx

cp ${OutFile}* $OutDir/.
echo DONE
rm -r $WorkDir
