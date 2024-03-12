#!/bin/bash
#SBATCH --job-name=deeptmhmm
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --partition=jic-gpu,jic-a100
#SBATCH --gres=gpu:1
#SBATCH -N 1 
#SBATCH -n 1
#SBATCH --cpus-per-task=32
#SBATCH --mem-per-cpu=6G
#SBATCH --time=03-00:00:00

source package a3c840b0-e6d4-462c-8bf8-6da37d15ddf4

fasta=$1
outdir=$2

echo Proteome:
echo $fasta
echo OutDir:
echo $outdir

cd $outdir

predict.py --fasta $fasta
