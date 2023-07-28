#!/bin/bash
#SBATCH --job-name=admixture
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 50G
#SBATCH -c 16
#SBATCH -p jic-long,nbi-long
#SBATCH --time=2-00:00:00

source package /tgac/software/testing/bin/admixture-1.3.0
admixture --cv /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/plink/193s.M_persicae.onlySNPs_sorted_pruned_set.bed 2
