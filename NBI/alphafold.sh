#!/bin/bash
#SBATCH --job-name=AF2
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --partition=jic-gpu
#SBATCH --gres=gpu:1
#SBATCH -N 1 
#SBATCH -n 1
#SBATCH --cpus-per-task=8
#SBATCH --mem 32G
#SBATCH --time=04-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=thomas.heaven@jic.ac.uk
#SBATCH --nodelist=j1024n2,j1024n3,j1024n4,j1024n5,j1024n6,j1024n7,j1024n8,j1024n9,j1024n10,j1024n11

#From test runs AF2 is so much faster on a gpu node that it is cheaper to run with a gpu even if this requires ocupying the entire node.

# #SBATCH --nodelist=j512n10,j512n11,j512n12,j512n14,j512n15,j512n16,j512n17

# #SBATCH --job-name=AF2
# #SBATCH -o slurm.%j.out
# #SBATCH -e slurm.%j.err
# #SBATCH --partition=jic-gpu
# #SBATCH --gres=gpu:1
# #SBATCH -N 1 
# #SBATCH -n 1
# #SBATCH --cpus-per-task=32
# #SBATCH --mem 128G
# #SBATCH --time=04-00:00:00
# #SBATCH --mail-type=ALL
# #SBATCH --mail-user=thomas.heaven@jic.ac.uk
# #SBATCH --nodelist=j1024n8

# #SBATCH --job-name=AF2
# #SBATCH --nodes=1
# #SBATCH --ntasks=1
# #SBATCH --cpus-per-task=64
# #SBATCH --partition=jic-medium,nbi-medium
# #SBATCH --mem 256G
# #SBATCH --time=4-00:00
# #SBATCH -o slurm.%j.out
# #SBATCH -e slurm.%j.err
# #SBATCH --mail-type=ALL
# #SBATCH --mail-user=thomas.heaven@jic.ac.uk

pwd
hostname
date

echo InFile: $1
echo OutDir: $2
echo __
echo __

filename=$1 
DATA_DIR="/jic/scratch/projects/AlphaFold" # DO NOT CHANGE
OUTPUT_DIR=$2

source package 9a272fce-308f-46c4-892d-c80a3797dc0f

srun run_alphafold.py --fasta_paths=${filename} \
 --data_dir=${DATA_DIR} \
 --output_dir=${OUTPUT_DIR} \
 --model_names=model_1,model_2,model_3,model_4,model_5 \
 --max_template_date=2021-10-06 \
 --preset=full_dbs \
 --bfd_database_path=${DATA_DIR}/bfd/bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt \
 --uniclust30_database_path=${DATA_DIR}/uniclust30/uniclust30_2018_08/uniclust30_2018_08 \
 --uniref90_database_path=${DATA_DIR}/uniref90/uniref90.fasta \
 --mgnify_database_path=${DATA_DIR}/mgnify/mgy_clusters_2018_12.fa \
 --pdb70_database_path=${DATA_DIR}/pdb70/pdb70 \
 --template_mmcif_dir=${DATA_DIR}/pdb_mmcif/mmcif_files \
 --obsolete_pdbs_path=${DATA_DIR}/pdb_mmcif/obsolete.dat


 date
