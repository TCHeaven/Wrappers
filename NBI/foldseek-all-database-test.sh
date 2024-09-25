#!/bin/bash
#SBATCH -p jic-medium
#SBATCH -t 0-2:00
#SBATCH -c 1
#SBATCH --mem=8G
#SBATCH -J foldseek
#SBATCH --mail-type=end
#SBATCH --mail-user=sam.mugford@jic.ac.uk
 
#search a single aphids protein against /nbi/Reference-Data/Foldseek/afdb_swissprot
#this will probably benefit from running createdb comand to reduce the database to representatives first
#bumbed up memory from 4g (for one databse) to 8g
source package cda29b6a-320e-4d73-83c6-240ed7a6201e

foldseek easy-search -e 0.01 --format-output "query,target,fident,alnlen,mismatch,gapopen,qstart,qend,tstart,tend,evalue,bits,alntmscore,qtmscore,ttmscore,lddt,lddtfull,prob"  MYZPE13164_O_EIv2.1_0002220.2_relaxed_model_3.pdb /nbi/Reference-Data/Foldseek/ MYZPE13164_O_EIv2.1_0002220.2-FS-swissprot-database-output.txt tmp
