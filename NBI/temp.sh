#!/bin/bash
#SBATCH --job-name=bash
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 50G
#SBATCH -c 1
#SBATCH -p jic-long
#SBATCH --time=7-00:00

#source package 638df626-d658-40aa-80e5-14a275b7464b
#bcftools mpileup -b /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/bamlist.txt --annotate AD,DP --fasta-ref /jic/research-groups/Saskia-Hogenhout/TCHeaven/Genomes/Myzus/persicae/mito/Wang2016_NC_029727.fasta -O z -o /jic/research-groups/Saskia-Hogenhout/TCHeaven/PopGen/M_persicae_SNP_population/255s.M_persicae.mito.vcf.gz
#bcftools mpileup -b /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/bamlist2.txt --annotate AD,DP --fasta-ref /jic/research-groups/Saskia-Hogenhout/TCHeaven/Genomes/Myzus/persicae/mito/Wang2016_NC_029727.fasta -O z -o /jic/research-groups/Saskia-Hogenhout/TCHeaven/PopGen/M_persicae_SNP_population/192s.M_persicae.mito.vcf.gz
#bcftools call --ploidy 1 -Oz -v -m -o /jic/research-groups/Saskia-Hogenhout/TCHeaven/PopGen/M_persicae_SNP_population/255.M_persicae.mito.vcf.gz /jic/research-groups/Saskia-Hogenhout/TCHeaven/PopGen/M_persicae_SNP_population/255s.M_persicae.mito_hap.vcf.gz
#bcftools call --ploidy 1 -Oz -v -m -o /jic/research-groups/Saskia-Hogenhout/TCHeaven/PopGen/M_persicae_SNP_population/192.M_persicae.mito.vcf.gz /jic/research-groups/Saskia-Hogenhout/TCHeaven/PopGen/M_persicae_SNP_population/192s.M_persicae.mito_hap.vcf.gz

#singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/pybed.simg bedtools intersect \
#-a /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/MYZPE13164_O_EIv2.1.CDS_annotation.gff3 \
#-b /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/ligustri+193s.M_persicae.onlySNPs-CDS_genic_mac1-regions.recode.vcf.gz \
#-header > /jic/research-groups/Saskia-Hogenhout/TCHeaven/PopGen/M_persicae_SNP_population/MYZPE13164_O_EIv2.1.CDS_annotation_withsnpsonly.gff3

#source package 3e7beb4d-f08b-4d6b-9b6a-f99cc91a38f9
#cd ~/snpEff
#java17 -jar snpEff.jar build -gff3 -v m_persicae_O_2_0
#java17 -jar snpEff.jar build -gtf22 -v m_persicae_O_2_0

#java17 -Xmx8g -jar snpEff.jar m_persicae_O_2_0 /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/193s.M_persicae.onlySNPs-CDS_genic_mac1-regions.recode.vcf.gz > /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/193s.M_persicae.onlySNPs-CDS_genic_mac1-regions.recode.ann.vcf

#source package d6092385-3a81-49d9-b044-8ffb85d0c446
#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/databases/blast/nt_14092023
#makeblastdb -blastdb_version 5 -in nt -dbtype nucl -title nt -parse_seqids -out nt

#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/databases/blast/nt_23092023
#gunzip nt.gz
#singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/blast2.9.0.sif makeblastdb -blastdb_version 5 -in nt -dbtype nucl -title nt -out 5/nt
#singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/blast2.7.1.sif makeblastdb -in nt -dbtype nucl -title nt -out 4/nt

#57172097
#57182787
#57184167

source /nbi/software/staging/RCSUPPORT-2452/stagingloader
meryl union-sum output /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/570m/32/3/10.0/0.25/meryl/T_urticae_570m_32_3_10.0_0.25.meryl /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_urticae/*/meryl/*.meryl
