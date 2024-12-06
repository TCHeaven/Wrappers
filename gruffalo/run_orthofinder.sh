#!/usr/bin/env bash
#SBATCH -J orthofinder
#SBATCH --partition=himem
#SBATCH --mem-per-cpu=12G
#SBATCH --cpus-per-task=32

# Find orthogroups and orthologs


IN_DIR=$1
prefix=$2
OutDir=$3

cd $IN_DIR

ulimit -n 52000
orthofinder -S blast -f ./ -t 32 -a 8 -n $prefix -o $OutDir 
