#!/bin/bash
#SBATCH --job-name=orthofinder
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 250G
#SBATCH -c 32
#SBATCH -p jic-medium,jic-long
#SBATCH --time=02-00:00:00

source package fc91613f-1095-4f67-b5aa-b86d702b36da
source package dd43df1f-7eb2-4011-88fc-c457e801ddd0

cd $1
orthofinder -f formatted -t 26 -a 6
