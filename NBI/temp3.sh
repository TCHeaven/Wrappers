#!/bin/bash
#SBATCH --job-name=bash
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 100G
#SBATCH -c 64
#SBATCH -p jic-short
#SBATCH --time=0-02:00:00

source package 638df626-d658-40aa-80e5-14a275b7464b

#samtools sort -@64 -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/bwa/T_anthrisci_820m_48_1_10.0_0.25_sorted_HiC.bam /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/bwa/T_anthrisci_820m_48_1_10.0_0.25_HiC.bam
#rm /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/bwa/T_anthrisci_820m_48_1_10.0_0.25_HiC.bam
#samtools sort -@64 -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/bwa/T_anthrisci_820m_48_1_10.0_0.25_sorted_Tellseq.bam /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/bwa/T_anthrisci_820m_48_1_10.0_0.25_Tellseq.bam
#rm /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/bwa/T_anthrisci_820m_48_1_10.0_0.25_Tellseq.bam
#samtools sort -@64 -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/bwa/T_anthrisci_820m_48_1_10.0_0.25_sorted_Tellseq_trimmed.bam /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/bwa/T_anthrisci_820m_48_1_10.0_0.25_Tellseq_trimmed.bam
#rm /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/bwa/T_anthrisci_820m_48_1_10.0_0.25_Tellseq_trimmed.bam
#samtools sort -@64 -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/890m/24/0/5.0/0.75/bwa/T_anthrisci_890m_24_0_5.0_0.75_sorted_HiC.bam /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/890m/24/0/5.0/0.75/bwa/T_anthrisci_890m_24_0_5.0_0.75_HiC.bam
#rm /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/890m/24/0/5.0/0.75/bwa/T_anthrisci_890m_24_0_5.0_0.75_HiC.bam
#samtools sort -@64 -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/890m/24/0/5.0/0.75/bwa/T_anthrisci_890m_24_0_5.0_0.75_sorted_Tellseq_trimmed.bam /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/890m/24/0/5.0/0.75/bwa/T_anthrisci_890m_24_0_5.0_0.75_Tellseq_trimmed.bam
#rm /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/890m/24/0/5.0/0.75/bwa/T_anthrisci_890m_24_0_5.0_0.75_Tellseq_trimmed.bam
#samtools sort -@64 -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/bwa/T_apicales_880m_29_3_3.0_0.75_sorted_HiC.bam /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/bwa/T_apicales_880m_29_3_3.0_0.75_HiC.bam
#rm /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/bwa/T_apicales_880m_29_3_3.0_0.75_HiC.bam
#samtools sort -@64 -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/bwa/T_apicales_880m_29_3_3.0_0.75_sorted_Tellseq.bam /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/bwa/T_apicales_880m_29_3_3.0_0.75_Tellseq.bam
#rm /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/bwa/T_apicales_880m_29_3_3.0_0.75_Tellseq.bam
#samtools sort -@64 -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/bwa/T_apicales_880m_29_3_3.0_0.75_sorted_Tellseq_trimmed.bam /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/bwa/T_apicales_880m_29_3_3.0_0.75_Tellseq_trimmed.bam
#rm /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/bwa/T_apicales_880m_29_3_3.0_0.75_Tellseq_trimmed.bam
#samtools sort -@64 -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/38/0/5.0/0.75/bwa/T_apicales_880m_38_0_5.0_0.75_sorted_HiC.bam /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/38/0/5.0/0.75/bwa/T_apicales_880m_38_0_5.0_0.75_HiC.bam
#rm /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/38/0/5.0/0.75/bwa/T_apicales_880m_38_0_5.0_0.75_HiC.bam
#samtools sort -@64 -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/38/0/5.0/0.75/bwa/T_apicales_880m_38_0_5.0_0.75_sorted_Tellseq_trimmed.bam /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/38/0/5.0/0.75/bwa/T_apicales_880m_38_0_5.0_0.75_Tellseq_trimmed.bam
#rm /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/38/0/5.0/0.75/bwa/T_apicales_880m_38_0_5.0_0.75_Tellseq_trimmed.bam
#samtools sort -@64 -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/bwa/T_urticae_715m_12_2_3.0_0.5_sorted_HiC.bam /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/bwa/T_urticae_715m_12_2_3.0_0.5_HiC.bam
#rm /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/bwa/T_urticae_715m_12_2_3.0_0.5_HiC.bam
#samtools sort -@64 -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/bwa/T_urticae_715m_12_2_3.0_0.5_sorted_Tellseq.bam /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/bwa/T_urticae_715m_12_2_3.0_0.5_Tellseq.bam
#rm /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/bwa/T_urticae_715m_12_2_3.0_0.5_Tellseq.bam
#samtools sort -@64 -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/bwa/T_urticae_715m_12_2_3.0_0.5_sorted_Tellseq_trimmed.bam /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/bwa/T_urticae_715m_12_2_3.0_0.5_Tellseq_trimmed.bam
#rm /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/bwa/T_urticae_715m_12_2_3.0_0.5_Tellseq_trimmed.bam
#samtools sort -@64 -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/32/2/3.0/0.75/bwa/T_urticae_715m_32_2_3.0_0.75_sorted_HiC.bam /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/32/2/3.0/0.75/bwa/T_urticae_715m_32_2_3.0_0.75_HiC.bam
#rm /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/32/2/3.0/0.75/bwa/T_urticae_715m_32_2_3.0_0.75_HiC.bam
#samtools sort -@64 -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/32/2/3.0/0.75/bwa/T_urticae_715m_32_2_3.0_0.75_sorted_Tellseq_trimmed.bam /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/32/2/3.0/0.75/bwa/T_urticae_715m_32_2_3.0_0.75_Tellseq_trimmed.bam
#rm /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/32/2/3.0/0.75/bwa/T_urticae_715m_32_2_3.0_0.75_Tellseq_trimmed.bam

#samtools sort -@64 -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/minimap2/T_anthrisci_820m_48_1_10.0_0.25_sorted_HiFi.bam /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/minimap2/T_anthrisci_820m_48_1_10.0_0.25.bam
#rm /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/minimap2/T_anthrisci_820m_48_1_10.0_0.25.bam
#samtools sort -@64 -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/890m/24/0/5.0/0.75/minimap2/T_anthrisci_890m_24_0_5.0_0.75_sorted_HiFi.bam /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/890m/24/0/5.0/0.75/minimap2/T_anthrisci_890m_24_0_5.0_0.75.bam
#rm /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/890m/24/0/5.0/0.75/minimap2/T_anthrisci_890m_24_0_5.0_0.75.bam
#samtools sort -@64 -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/minimap2/T_apicales_880m_29_3_3.0_0.75_sorted_HiFi.bam /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/minimap2/T_apicales_880m_29_3_3.0_0.75.bam
#rm /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/minimap2/T_apicales_880m_29_3_3.0_0.75.bam
#samtools sort -@64 -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/38/0/5.0/0.75/minimap2/T_apicales_880m_38_0_5.0_0.75_sorted_HiFi.bam /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/38/0/5.0/0.75/minimap2/T_apicales_880m_38_0_5.0_0.75.bam
#rm /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/38/0/5.0/0.75/minimap2/T_apicales_880m_38_0_5.0_0.75.bam
#samtools sort -@64 -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/minimap2/T_urticae_715m_12_2_3.0_0.5_sorted_HiFi.bam /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/minimap2/T_urticae_715m_12_2_3.0_0.5.bam
#rm /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/minimap2/T_urticae_715m_12_2_3.0_0.5.bam
#samtools sort -@64 -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/32/2/3.0/0.75/minimap2/T_urticae_715m_32_2_3.0_0.75_sorted_HiFi.bam /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/32/2/3.0/0.75/minimap2/T_urticae_715m_32_2_3.0_0.75.bam
#rm /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/32/2/3.0/0.75/minimap2/T_urticae_715m_32_2_3.0_0.75.bam

#samtools sort -@64 -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/break10x/bwa/T_urticae_715m_12_2_3.0_0.5_break_sorted_Tellseq_trimmed.bam /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/break10x/bwa/T_urticae_715m_12_2_3.0_0.5_break.fa_Tellseq_trimmed.bam
samtools sort -@64 -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/break10x/bwa/T_apicales_880m_29_3_3.0_0.75_break_sorted_Tellseq_trimmed.bam /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/break10x/bwa/T_apicales_880m_29_3_3.0_0.75_break_Tellseq_trimmed.bam
samtools sort -@64 -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/break10x/bwa/T_anthrisci_820m_48_1_10.0_0.25_break_sorted_Tellseq_trimmed.bam /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/break10x/bwa/T_anthrisci_820m_48_1_10.0_0.25_break_Tellseq_trimmed.bam