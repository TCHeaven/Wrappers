#!/bin/bash
#SBATCH --job-name="replace"
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --partition=jic-long
#SBATCH --mem 80G
#SBATCH --time=4-00:00
#SBATCH -o alphafold_replace.out
#SBATCH -e alphafold_replace.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sam.mugford@jic.ac.uk

pwd
hostname
date


filename=replace # INPUT FILENAME CAN BE GIVEN ON COMMAND LINE OR INSTEAD REPLACE "$1" HERE
DATA_DIR="/jic/scratch/projects/AlphaFold" # DO NOT CHANGE
INPUT_DIR= # ADD DIRECTORY WHERE PROTEIN SEQUENCE IS STORED
OUTPUT_DIR= # ADD DIRECTORY WHERE YOU WANT ALPHAFOLD OUTPUT TO BE MADE

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
