#!/bin/bash
#SBATCH --job-name=admixture
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 50G
#SBATCH -c 16
#SBATCH -p jic-long,nbi-long
#SBATCH --time=2-00:00:00

#source package /tgac/software/testing/bin/admixture-1.3.0
#admixture --cv /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/plink/193s.M_persicae.onlySNPs_sorted_pruned_set.bed 2


source package 638df626-d658-40aa-80e5-14a275b7464b
cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_urticae/HiC/
samtools import -@16 -r ID:urticae_286170-S3HiC -r CN:S3HiC -r PU:urticae_286170-S3HiC -r SM:urticae_286170 urticae_286170-S3HiC_R1.fastq.gz urticae_286170-S3HiC_R2.fastq.gz -o urticae_286170-S3HiC.cram
samtools index -@16 urticae_286170-S3HiC.cram