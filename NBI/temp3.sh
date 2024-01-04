#!/bin/bash
#SBATCH --job-name=bash
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 200G
#SBATCH -c 1
#SBATCH -p jic-medium
#SBATCH --time=02-00:00:00

singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/methylkit1.28.0.sif R --save - <<EOF 

library(methylKit)

week1_file.list <- list("/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/BR1_E2_1/bsmap/CpG_BR1_E2_1_bsmap_ratios_filtered.txt",
"/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/BR1_E2_2/bsmap/CpG_BR1_E2_2_bsmap_ratios_filtered.txt",
"/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/BR1_E2_3/bsmap/CpG_BR1_E2_3_bsmap_ratios_filtered.txt",
"/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/NB1_E2_1/bsmap/CpG_NB1_E2_1_bsmap_ratios_filtered.txt",
"/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/NB1_E2_2/bsmap/CpG_NB1_E2_2_bsmap_ratios_filtered.txt",
"/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/NB1_E2_3/bsmap/CpG_NB1_E2_3_bsmap_ratios_filtered.txt",
"/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/AT1_E2_1/bsmap/CpG_AT1_E2_1_bsmap_ratios_filtered.txt",
"/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/AT1_E2_2/bsmap/CpG_AT1_E2_2_bsmap_ratios_filtered.txt")
week1=methRead(week1_file.list, 
    sample.id=list("BR1_E2_1","BR1_E2_2","BR1_E2_3","NB1_E2_1","NB1_E2_2","NB1_E2_3","AT1_E2_1","AT1_E2_2"),
    assembly="O_v2",
    header=TRUE,
    treatment=c(0,0,0,1,1,1,2,2),
    mincov = 4,
    context="CpG",
    resolution="base",
    pipeline=list(fraction=TRUE,chr.col=1,start.col=2,end.col=2,coverage.col=6,strand.col=3,freqC.col=5 ))
week1
head(week1[[1]])
getMethylationStats(week1[[1]], plot=TRUE, both.strands=FALSE)

#Normalisation and filtering
week1.filt <- filterByCoverage(week1,
                      lo.count=4,
                      lo.perc=NULL,
                      hi.count=NULL,
                      hi.perc=99.9)

week1.filt.norm <- normalizeCoverage(week1.filt, method = "median")
week1.meth <- unite(week1.filt.norm, destrand=FALSE)
week1.meth
# get percent methylation matrix
pm=percMethylation(week1.meth)
# calculate standard deviation of CpGs
sds=matrixStats::rowSds(pm)
# Visualize the distribution of the per-CpG standard deviation
# to determine a suitable cutoff
png("histogram1.png", width = 800, height = 600, units = "px", res = 300)
hist(sds, breaks = 100)
dev.off()
# keep only CpG with standard deviations larger than 2%
week1.meth <- week1.meth[sds > 2]
# This leaves us with this number of CpG sites
nrow(week1.meth)

#Plot data structure
png("correlation1.png")
getCorrelation(week1.meth,plot=TRUE)
dev.off()
cat("bump")
png("dendogram1.png")
clusterSamples(week1.meth, dist="correlation", method="ward", plot=TRUE)
dev.off()
png("PCA1.png", width = 800, height = 600, units = "px", res = 300)
PCASamples(week1.meth)
dev.off()

EOF
#source package 638df626-d658-40aa-80e5-14a275b7464b

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
#samtools sort -@64 -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/break10x/bwa/T_apicales_880m_29_3_3.0_0.75_break_sorted_Tellseq_trimmed.bam /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/break10x/bwa/T_apicales_880m_29_3_3.0_0.75_break_Tellseq_trimmed.bam
#samtools sort -@64 -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/break10x/bwa/T_anthrisci_820m_48_1_10.0_0.25_break_sorted_Tellseq_trimmed.bam /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/break10x/bwa/T_anthrisci_820m_48_1_10.0_0.25_break_Tellseq_trimmed.bam