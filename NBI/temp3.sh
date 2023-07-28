#!/bin/bash
#SBATCH --job-name=bash
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 50G
#SBATCH -c 16
#SBATCH -p jic-long,nbi-long
#SBATCH --time=2-00:00:00


source package 01ef5a53-c149-4c9e-b07d-0b9a46176cc0
source package /nbi/software/testing/bin/bcftools-1.8

#bcftools isec -p output_dir temp.vcf temp2.vcf
bcftools index /jic/research-groups/Saskia-Hogenhout/TCHeaven/PopGen/M_persicae_SNP_population/210s.M_persicae.onlySNPs-CDS_genic-regions.vcf.gz
bcftools index /jic/research-groups/Saskia-Hogenhout/TCHeaven/PopGen/M_persicae_SNP_population/210s.M_persicae.onlySNPs-CDS_genic-regions.vcf.gz_2
bcftools isec -p temp_dir /jic/research-groups/Saskia-Hogenhout/TCHeaven/PopGen/M_persicae_SNP_population/210s.M_persicae.onlySNPs-CDS_genic-regions.vcf.gz /jic/research-groups/Saskia-Hogenhout/TCHeaven/PopGen/M_persicae_SNP_population/210s.M_persicae.onlySNPs-CDS_genic-regions.vcf.gz_2
