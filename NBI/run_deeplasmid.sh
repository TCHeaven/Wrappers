#!/bin/bash
#SBATCH --job-name=deeplasmid
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --partition=jic-gpu,jic-a100
#SBATCH --gres=gpu:1
#SBATCH -N 1 
#SBATCH -n 1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=60G
#SBATCH --time=03-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
fasta=$1
outfile=$3
outdir=$2

echo Contigs:
echo $fasta
echo OutFile:
echo $outfile
echo OutDir:
echo $outdir

echo __
echo __

mkdir -p $WorkDir
ln -s $fasta ${WorkDir}/fasta.fna

cd $WorkDir
source package 3ba6f93f-b5d3-4e76-a4f4-c7966bff9771
deeplasmid.sh fasta.fna .
