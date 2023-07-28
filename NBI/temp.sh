#!/bin/bash
#SBATCH --job-name=bash
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 250G
#SBATCH --nodes=1
#SBATCH -c 1
#SBATCH -p nbi-long
#SBATCH --time=2-00:00:00

for file in $(ls /jic/research-groups/Saskia-Hogenhout/TCHeaven/PopGen/M_persicae_SNP_population/210s.M_persicae.onlySNPs-genic-regions.vcf.gz); do 
    source package 01ef5a53-c149-4c9e-b07d-0b9a46176cc0
    bgzip -cd $file > temp.vcf
    singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 /hpc-home/did23faz/git_repos/Scripts/NBI/remove_duplicate_snps.py temp.vcf 
    bgzip -c dedup_temp.vcf > ${file}_2
    rm temp.vcf
done

for file in $(ls /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/193s.M_persicae.onlySNPs-genic-regions.vcf.gz); do 
    source package 01ef5a53-c149-4c9e-b07d-0b9a46176cc0
    bgzip -cd $file > temp.vcf
    singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 /hpc-home/did23faz/git_repos/Scripts/NBI/remove_duplicate_snps.py temp.vcf 
    bgzip -c dedup_temp.vcf > ${file}_2
    rm temp.vcf
done

for file in $(ls /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/193s.M_persicae.onlySNPs-CDS_exon_UTR_genic-regions.vcf.gz); do 
    source package 01ef5a53-c149-4c9e-b07d-0b9a46176cc0
    bgzip -cd $file > temp.vcf
    singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 /hpc-home/did23faz/git_repos/Scripts/NBI/remove_duplicate_snps.py temp.vcf 
    bgzip -c dedup_temp.vcf > ${file}_2
    rm temp.vcf
done

for file in $(ls /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/ligustri+193s.M_persicae.onlySNPs-CDS_exon_UTR_genic-regions.vcf.gz); do 
    source package 01ef5a53-c149-4c9e-b07d-0b9a46176cc0
    bgzip -cd $file > temp.vcf
    singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 /hpc-home/did23faz/git_repos/Scripts/NBI/remove_duplicate_snps.py temp.vcf 
    bgzip -c dedup_temp.vcf > ${file}_2
    rm temp.vcf
done

for file in $(ls /jic/research-groups/Saskia-Hogenhout/TCHeaven/PopGen/M_persicae_SNP_population/210s.M_persicae.onlySNPs-CDS_exon_UTR_genic-regions.vcf.gz); do 
    source package 01ef5a53-c149-4c9e-b07d-0b9a46176cc0
    bgzip -cd $file > temp.vcf
    singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 /hpc-home/did23faz/git_repos/Scripts/NBI/remove_duplicate_snps.py temp.vcf 
    bgzip -c dedup_temp.vcf > ${file}_2
    rm temp.vcf
done

for file in $(ls /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/193s.M_persicae.onlySNPs-CDS_genic-regions.vcf.gz); do 
    source package 01ef5a53-c149-4c9e-b07d-0b9a46176cc0
    bgzip -cd $file > temp.vcf
    singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 /hpc-home/did23faz/git_repos/Scripts/NBI/remove_duplicate_snps.py temp.vcf 
    bgzip -c dedup_temp.vcf > ${file}_2
    rm temp.vcf
done

for file in $(ls /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/ligustri+193s.M_persicae.onlySNPs-CDS_genic-regions.vcf.gz); do 
    source package 01ef5a53-c149-4c9e-b07d-0b9a46176cc0
    bgzip -cd $file > temp.vcf
    singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 /hpc-home/did23faz/git_repos/Scripts/NBI/remove_duplicate_snps.py temp.vcf 
    bgzip -c dedup_temp.vcf > ${file}_2
    rm temp.vcf
done

for file in $(ls /jic/research-groups/Saskia-Hogenhout/TCHeaven/PopGen/M_persicae_SNP_population/210s.M_persicae.onlySNPs-CDS_genic-regions.vcf.gz); do 
    source package 01ef5a53-c149-4c9e-b07d-0b9a46176cc0
    bgzip -cd $file > temp.vcf
    singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 /hpc-home/did23faz/git_repos/Scripts/NBI/remove_duplicate_snps.py temp.vcf 
    bgzip -c dedup_temp.vcf > ${file}_2
    rm temp.vcf
done


