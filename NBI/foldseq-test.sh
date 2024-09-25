#!/bin/bash
#SBATCH -p nbi-medium
#SBATCH -t 0-12:00
#SBATCH -c 1
#SBATCH --mem=4G
#SBATCH -J foldseq
#SBATCH --mail-type=end
#SBATCH --mail-user=sam.mugford@jic.ac.uk
 

source package cda29b6a-320e-4d73-83c6-240ed7a6201e

foldseek easy-search -e inf --format-output "query,target,fident,alnlen,mismatch,gapopen,qstart,qend,tstart,tend,evalue,bits,alntmscore,qtmscore,ttmscore,lddt,lddtfull,prob" ./MYZPE13164_O_EIv2.1_0002220.2_relaxed_model_3.pdb ./ MYZPE13164_O_EIv2.1_0002220.2_relaxed_model_3-foldseek-all.output.txt tmp
