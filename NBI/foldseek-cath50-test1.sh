#!/bin/bash
#SBATCH -p jic-long
#SBATCH -t 3-0:00
#SBATCH -c 1
#SBATCH --mem=4G
#SBATCH -J cath50-foldseek
#SBATCH --mail-type=end
#SBATCH --mail-user=sam.mugford@jic.ac.uk
 

source package cda29b6a-320e-4d73-83c6-240ed7a6201e

foldseek easy-search -e inf   /jic/scratch/groups/Saskia-Hogenhout/sam_mugford/alphafold/models_to_use/MYZPE13164_O_EIv2.1_0002220.2_relaxed_model_3.pdb /nbi/Reference-Data/Foldseek/cath50 ./cath50-output/MYZPE13164_O_EIv2.1_0002220.2.cath50-foldseek-output-test1.txt tmp
