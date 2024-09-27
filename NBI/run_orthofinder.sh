#!/bin/bash
#SBATCH --job-name=orthofinder
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 128G
#SBATCH -c 32
#SBATCH -p jic-medium,jic-long,nbi-medium,nbi-long
#SBATCH --time=02-00:00:00

IN_DIR=$1
prefix=$2
OutDir=$3

echo InDir: $IN_DIR
echo Prefix: $prefix
echo OutDir: $OutDir

source package fc91613f-1095-4f67-b5aa-b86d702b36da
source package dd43df1f-7eb2-4011-88fc-c457e801ddd0

ulimit -n 52000

cd $IN_DIR
orthofinder -f ./ -t 32 -a 8 -M msa -n $prefix -o $OutDir
