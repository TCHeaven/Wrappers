#!/bin/bash
#SBATCH -p jic-medium
#SBATCH -t 0-2:00
#SBATCH -c 1
#SBATCH --mem=4G
#SBATCH -J foldseek
#SBATCH --mail-type=end
#SBATCH --mail-user=sam.mugford@jic.ac.uk
 
#search a single aphids protein against /nbi/Reference-Data/Foldseek/afdb_swissprot
#takes about a minute to run for 1 protein against swissprot, 4g was ok.  when i searched against all databases, set at 8g , ran for 45mins before running out of memory

source package cda29b6a-320e-4d73-83c6-240ed7a6201e

foldseek easy-search -e inf --format-output "query,target,fident,alnlen,mismatch,gapopen,qstart,qend,tstart,tend,evalue,bits,alntmscore,qtmscore,ttmscore,lddt,lddtfull,prob"  MYZPE13164_O_EIv2.1_0002220.2_relaxed_model_3.pdb /nbi/Reference-Data/Foldseek/afdb_swissprot MYZPE13164_O_EIv2.1_0002220.2-FS-swissprot-database-output.txt tmp
