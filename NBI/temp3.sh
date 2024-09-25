#!/bin/bash
#SBATCH --job-name=iqtree
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 32G
#SBATCH -c 4
#SBATCH -p jic-long,nbi-long
#SBATCH --time=28-00:00:00

cat ~/git_repos/Wrappers/NBI/temp3.sh
echo __
echo __
echo __

cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Symbionts/analysis/phylogeny/orthofinder/iqtree2
Align=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Symbionts/analysis/orthology/orthofinder/All_carsonella_1/formatted/orthofinder52000/Results_All_carsonella_1/WorkingDirectory/Alignments_ids/SpeciesTreeAlignment.fa
cpu=4
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/iqtree_2.3.0.sif iqtree2 -s $Align -m mtInv+F+I+R4 -B 1000 -T AUTO --threads-max $cpu -redo 
#
#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Symbionts/analysis/phylogeny/orthofinder/iqtree2
#Align=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Symbionts/analysis/orthology/orthofinder/All_carsonella_1/formatted/orthofinder52000/Results_All_carsonella_1/WorkingDirectory/Alignments_ids/SpeciesTreeAlignment.fa
#cpu=32
#singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/iqtree_2.3.0.sif iqtree2 -s $Align -m MFA -T AUTO --threads-max $cpu

#source package 638df626-d658-40aa-80e5-14a275b7464b
#ls /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/dna_qc/Dyspera/*/*/trim_galore/carsonella_map/bwa-mem/gatk/*realigned.bam > /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/bamlist.txt
#mkdir -p /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/snp_calling/Carsonella/ruddii/
#bcftools mpileup --threads 16 -b /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/bamlist.txt --annotate AD,DP --fasta-ref /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Symbionts/Candidatus/Carsonella/ruddii/GCA_002009355.1/GCA_002009355.1_ASM200935v1_genomic.fna -O z -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/snp_calling/Carsonella/ruddii/variants_1.vcf.gz

#bcftools call --threads 16 --ploidy 2 -Oz -v -m -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/snp_calling/Carsonella/ruddii/variants.vcf.gz /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/snp_calling/Carsonella/ruddii/variants_1.vcf.gz

#ls /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/dna_qc/Dyspera/apicales/*/trim_galore/bwa-mem/gatk/*realigned.bam /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/dna_qc/Dyspera/*/*/trim_galore/api_map/bwa-mem/gatk/*realigned.bam > bamlist3.txt
#mkdir -p /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/snp_calling/Dyspera/apicales+/
#bcftools mpileup --threads 16 -b /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/bamlist3.txt --annotate AD,DP --fasta-ref /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/break10x/purge_dups/sanger/MitoHifi/filtered/inspector/T_apicales_880m_29_3_3.0_0.75_break_TellSeqPurged_curated_nomito_filtered_corrected.fa -O z -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/snp_calling/Dyspera/apicales+/variants_1.vcf.gz

#bcftools call --threads 16 --ploidy 2 -Oz -v -m -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/snp_calling/Dyspera/apicales+/variants.vcf.gz  /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/snp_calling/Dyspera/apicales+/variants_1.vcf.gz

#ls /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/dna_qc/Dyspera/pallida/*/trim_galore/bwa-mem/gatk/*realigned.bam /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/dna_qc/Dyspera/*/*/trim_galore/ant_map/bwa-mem/gatk/*realigned.bam > bamlist4.txt
#mkdir -p /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/snp_calling/Dyspera/pallida+/
#bcftools mpileup --threads 16 -b /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/bamlist4.txt --annotate AD,DP --fasta-ref /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/break10x/purge_dups/sanger/MitoHifi/filtered/inspector/T_anthrisci_820m_48_1_10.0_0.25_break_TellSeqPurged_curated_nomito_filtered_corrected.fa -O z -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/snp_calling/Dyspera/pallida+/variants_1.vcf.gz

#bcftools call --threads 16 --ploidy 2 -Oz -v -m -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/snp_calling/Dyspera/pallida+/variants.vcf.gz  /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/snp_calling/Dyspera/pallida+/variants_1.vcf.gz

#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/analysis/phylogeny/Dyspera/pallida/iqtree2
#Alignment=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/snp_calling/Dyspera/pallida/genmap/variants_callable_filtered.recode.min4.fasta
#cpu=12
#singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/iqtree_2.3.0.sif iqtree2 -s $Alignment -m PMB+F+R3 -B 1000 -T AUTO --threads-max $cpu
#

#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/analysis/phylogeny/Dyspera/apicales/iqtree2
#Alignment=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/snp_calling/Dyspera/apicales/genmap/variants_callable_filtered.recode.thin1000.min4.fasta
#cpu=12
#singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/iqtree_2.3.0.sif iqtree2 -s $Alignment -m PMB+F+R5 -B 1000 -T AUTO --threads-max $cpu
#

#mkdir -p /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/analysis/phylogeny/Dyspera/apicales/iqtree2
#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/analysis/phylogeny/Dyspera/apicales/iqtree2
#Alignment=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/snp_calling/Dyspera/apicales/genmap/variants_callable_filtered.recode.min4.fasta
#cpu=8
#singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/iqtree_2.3.0.sif iqtree2 -s $Alignment -m MF -T AUTO --threads-max $cpu



#singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/iqtree_2.3.0.sif iqtree2 -t /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/phylogeny/hemiptera_phylogeny.bootstrapped.consensus2.astral.tre --gcf /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/phylogeny/tree-files.txt --prefix concord3 -T 8
#singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/iqtree_2.3.0.sif iqtree2 -te /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/phylogeny/hemiptera_phylogeny.bootstrapped.consensus2.astral.tre -p /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/phylogeny/busco_nt/AlignDir3/ --scfl 100 --prefix concord4 -T 8


#source package 638df626-d658-40aa-80e5-14a275b7464b
#ls /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/dna_qc/Dyspera/apicales/*/trim_galore/bwa-mem/gatk/*realigned.bam > bamlist3.txt
#mkdir -p /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/snp_calling/Dyspera/apicales/
#bcftools mpileup --threads 64 -b /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/bamlist3.txt --annotate AD,DP --fasta-ref /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/break10x/purge_dups/sanger/MitoHifi/filtered/inspector/T_apicales_880m_29_3_3.0_0.75_break_TellSeqPurged_curated_nomito_filtered_corrected.fa -O z -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/snp_calling/Dyspera/apicales/variants_1.vcf.gz

#bcftools call --threads 64 --ploidy 2 -Oz -v -m -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/snp_calling/Dyspera/apicales/variants.vcf.gz  /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/snp_calling/Dyspera/apicales/variants_1.vcf.gz

#for file in $(ls /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/dna_qc/Dyspera/*/*/trim_galore/bwa-mem/*_trimmed_1_sorted.bam); do
#    OutDir=$(dirname $file)
#    OutFile=$(basename $file | sed s'@_sorted.bam@_sorted_MarkDups.bam@g')
#    metrics=$(basename $file | sed s'@_trimmed_1_sorted.bam@@g')_marked_dup_metrics.txt
#    java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar SortSam I=${file} O=${OutDir}/temp.bam SORT_ORDER=coordinate
#    java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar MarkDuplicates REMOVE_DUPLICATES=true I=${OutDir}/temp.bam O=${OutDir}/${OutFile} M=${OutDir}/${metrics}
#    cd ${OutDir}
#    rm temp.bam
#    samtools index ${OutFile}
#    cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae
#done

#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/nano_diagnostics/analysis/phylogeny/busco_nt/iqtree2
#singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/iqtree_2.3.0.sif iqtree2 -te /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/nano_diagnostics/analysis/phylogeny/busco_nt/iqtree2/AlignDir.contree -p /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/nano_diagnostics/analysis/phylogeny/busco_nt/AlignDir/ --scfl 100 --prefix concord2 -T 8

#mkdir /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/nano_diagnostics/analysis/phylogeny/busco_nt/iqtree2
#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/nano_diagnostics/analysis/phylogeny/busco_nt/iqtree2
#AlignDir=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/nano_diagnostics/analysis/phylogeny/busco_nt/AlignDir
#cpu=32
#singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/iqtree_2.3.0.sif iqtree2 -s $AlignDir -m SYM+I+R9 -B 1000 -T AUTO --threads-max $cpu

#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/phylogeny/busco_nt/iqtree2
#singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/iqtree_2.3.0.sif iqtree2 -te /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/phylogeny/busco_nt/AlignDir3.contree -p /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/phylogeny/busco_nt/AlignDir3/ --scfl 100 --prefix concord2 -T 8
#mkdir /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/nano_diagnostics/analysis/phylogeny/busco_nt/AlignDir
#for gene in $(ls /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/nano_diagnostics/analysis/phylogeny/busco_nt/*/*_edit.fasta); do
#ln -s $gene /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/nano_diagnostics/analysis/phylogeny/busco_nt/AlignDir/.
#done

#Randomly select 100 BUSCO genes and use these for model selection, also select the GTR model as almost certainly best base model
#mkdir /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/nano_diagnostics/analysis/phylogeny/busco_nt/AlignDir-100
#ls /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/nano_diagnostics/analysis/phylogeny/busco_nt/AlignDir/ | shuf -n 100 | xargs -I {} ln -s /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/nano_diagnostics/analysis/phylogeny/busco_nt/AlignDir/{} /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/nano_diagnostics/analysis/phylogeny/busco_nt/AlignDir-100/{}
#mkdir /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/nano_diagnostics/analysis/phylogeny/busco_nt/iqtree2
#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/nano_diagnostics/analysis/phylogeny/busco_nt/iqtree2
#AlignDir=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/nano_diagnostics/analysis/phylogeny/busco_nt/AlignDir
#cpu=32
#singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/iqtree_2.3.0.sif iqtree2 -s $AlignDir -m MFA -T AUTO --threads-max $cpu
#
#Best-fit model: 

#mkdir /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/phylogeny/busco_nt/iqtree2
#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/phylogeny/busco_nt/iqtree2
#AlignDir=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/phylogeny/busco_nt/AlignDir3/
#cpu=32
#singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/iqtree_2.3.0.sif iqtree2 -s $AlignDir -m GTR+F+I+R10 -B 1000 -T AUTO --threads-max $cpu

#mkdir /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/phylogeny/busco_nt/iqtree2-test
#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/phylogeny/busco_nt/iqtree2-test
#AlignDir=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/phylogeny/busco_nt/AlignDir-100/
#cpu=40
#singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/iqtree_2.3.0.sif iqtree2 -s $AlignDir -m MF -T AUTO -mset GTR --threads-max $cpu

#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/phylogeny/busco_nt/iqtree2
#AlignDir=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/phylogeny/busco_nt/AlignDir3/
#cpu=4
#singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/iqtree_2.3.0.sif iqtree2 -s $AlignDir -m MFP -mtree -T AUTO --threads-max $cpu -b 1000 --verbose

#mkdir /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/phylogeny/busco_nt/iqtree2-test2
#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/phylogeny/busco_nt/iqtree2-test2
#AlignDir=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/phylogeny/busco_nt/AlignDir3/
#cpu=38
#singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/iqtree_2.3.0.sif iqtree2 -s $AlignDir -m MF -T AUTO --threads-max $cpu

#source package 0351788b-6639-43fb-8e80-f28600f83cb1
#astral5 -t 32 -i /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/phylogeny/tree-files.txt -b /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/phylogeny/bs-files.txt -r 100 -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/phylogeny/hemiptera_phylogeny.bootstrapped2.astral.tre
#tail -n 1 /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/phylogeny/hemiptera_phylogeny.bootstrapped2.astral.tre > /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/phylogeny/hemiptera_phylogeny.bootstrapped.consensus2.astral.tre
#astral5 -t 32 -q /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/phylogeny/hemiptera_phylogeny.bootstrapped.consensus2.astral.tre -i /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/phylogeny/hemiptera_phylogeny.bootstrapped2.astral.tre -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/phylogeny/hemiptera_phylogeny.bootstrapped.scored2.astral.tre 

#blastp -db /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/synteny/mcscanx/ncbiDB/T_urticae -query /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/filtered/purge_dups/purge_haplotigs/break10x/yahs/filtered/inspector/repeatmasker/softmask/helixer/T_urticae.faa -num_threads 32 -evalue 1e-10 -num_alignments 6 -outfmt 6 -out /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/synteny/mcscanx/intermediateData/T_urticae_v_T_urticae.blast
#blastp -db /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/synteny/mcscanx/ncbiDB/T_anthrisci -query /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/break10x/purge_dups/sanger/MitoHifi/filtered/inspector/repeatmasker/softmask/helixer/T_anthrisci.faa -num_threads 32 -evalue 1e-10 -num_alignments 6 -outfmt 6 -out /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/synteny/mcscanx/intermediateData/T_anthrisci_v_T_anthrisci.blast
#blastp -db /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/synteny/mcscanx/ncbiDB/T_apicales -query /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/break10x/purge_dups/sanger/MitoHifi/filtered/inspector/repeatmasker/softmask/helixer/T_apicales.faa -num_threads 32 -evalue 1e-10 -num_alignments 6 -outfmt 6 -out /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/synteny/mcscanx/intermediateData/T_apicales_v_T_apicales.blast
#blastp -db /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/synteny/mcscanx/ncbiDB/P_venusta -query /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/synteny/helixer/P_venusta/P_venusta.faa -num_threads 32 -evalue 1e-10 -num_alignments 6 -outfmt 6 -out /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/synteny/mcscanx/intermediateData/P_venusta_v_P_venusta.blast
#blastp -db /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/synteny/mcscanx/ncbiDB/B_cockerelli -query /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/synteny/helixer/B_cockerelli/B_cockerelli.faa -num_threads 32 -evalue 1e-10 -num_alignments 6 -outfmt 6 -out /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/synteny/mcscanx/intermediateData/B_cockerelli_v_B_cockerelli.blast 
#blastp -db /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/synteny/mcscanx/ncbiDB/D_citri -query /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/synteny/helixer/D_citri/D_citri.faa -num_threads 32 -evalue 1e-10 -num_alignments 6 -outfmt 6 -out /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/synteny/helixer/D_citri/D_citri.faa -num_threads 32 -evalue 1e-10 -num_alignments 5 -outfmt 6 -out /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/synteny/mcscanx/intermediateData/D_citri_v_D_citri.blast

#source package 37f0ffda-9f66-4391-87e2-38ccd398861d

#for ID in CLsoB_ZC1 CLeu_ASUK1 CLeu_ASNZ1 CLct_Oxford CLcr_BT-1 CLcr_BT-0 CLbr_Asol15 CLas_psy62 CLas_JXGC CLas_Ishi-1 CLas_gxpsy CLam_SaoPaulo CLam_PW_SP CLaf_PTSAPSY CLaf_Ang37 CLsoC_JIC; do
#  Assembly=$(ls /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/Liberibacter/genomes/${ID}/*/data/*/prokka/*.faa)
#  DB=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/Liberibacter/analysis/synteny/mcscanx/ncbiDB/${ID}
#  makeblastdb -in ${Assembly} -out ${DB} -dbtype prot
#  for ID2 in CLsoB_ZC1 CLeu_ASUK1 CLeu_ASNZ1 CLct_Oxford CLcr_BT-1 CLcr_BT-0 CLbr_Asol15 CLas_psy62 CLas_JXGC CLas_Ishi-1 CLas_gxpsy CLam_SaoPaulo CLam_PW_SP CLaf_PTSAPSY CLaf_Ang37 CLsoC_JIC; do
#    Query=$(ls /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/Liberibacter/genomes/${ID2}/*/data/*/prokka/*.faa)
#    Out=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/Liberibacter/analysis/synteny/mcscanx/interspecies/intermediateData/${ID2}_v_${ID}.blast
#    blastp -db ${DB} -query ${Query} -num_threads 32 -evalue 1e-10 -num_alignments 20 -outfmt 6 -out ${Out}
#  done
#done

#blastp -db /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/synteny/mcscanx/ncbiDB/T_urticae -query /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/synteny/helixer/B_cockerelli/B_cockerelli.faa -num_threads 32 -evalue 1e-10 -num_alignments 5 -outfmt 6 -out /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/synteny/mcscanx/intermediateData/B_cockerelli_v_T_urticae.blast
#blastp -db /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/synteny/mcscanx/ncbiDB/T_urticae -query /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/synteny/helixer/P_venusta/P_venusta.faa -num_threads 32 -evalue 1e-10 -num_alignments 5 -outfmt 6 -out /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/synteny/mcscanx/intermediateData/P_venusta_v_T_urticae.blast
#blastp -db /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/synteny/mcscanx/ncbiDB/T_urticae -query /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/break10x/purge_dups/sanger/MitoHifi/filtered/inspector/repeatmasker/softmask/helixer/T_apicales.faa -num_threads 32 -evalue 1e-10 -num_alignments 5 -outfmt 6 -out /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/synteny/mcscanx/intermediateData/T_apicales_v_T_urticae.blast
#blastp -db /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/synteny/mcscanx/ncbiDB/T_urticae -query /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/break10x/purge_dups/sanger/MitoHifi/filtered/inspector/repeatmasker/softmask/helixer/T_anthrisci.faa -num_threads 32 -evalue 1e-10 -num_alignments 5 -outfmt 6 -out /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/synteny/mcscanx/intermediateData/T_anthrisci_v_T_urticae.blast
#blastp -db /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/synteny/mcscanx/ncbiDB/T_urticae -query /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/synteny/helixer/D_citri/D_citri.faa -num_threads 32 -evalue 1e-10 -num_alignments 5 -outfmt 6 -out /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/analysis/synteny/mcscanx/intermediateData/D_citri_v_T_urticae.blast

#source package 638df626-d658-40aa-80e5-14a275b7464b
#ls /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/dna_qc/Dyspera/apicales/*/trim_galore/bwa-mem/gatk/*realigned.bam > bamlist3.txt
#mkdir -p /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/snp_calling/Dyspera/apicales/
#bcftools mpileup --threads 16 -b /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/bamlist3.txt --annotate AD,DP --fasta-ref /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/break10x/purge_dups/sanger/MitoHifi/filtered/inspector/T_apicales_880m_29_3_3.0_0.75_break_TellSeqPurged_curated_nomito_filtered_corrected.fa -O z -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/snp_calling/Dyspera/apicales/variants_1.vcf.gz

#bcftools call --threads 16 --ploidy 2 -Oz -v -m -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/snp_calling/Dyspera/apicales/variants.vcf.gz  /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/snp_calling/Dyspera/apicales/variants_1.vcf.gz

#ls /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/dna_qc/Dyspera/pallida/*/trim_galore/bwa-mem/gatk/*realigned.bam > bamlist4.txt
#mkdir -p /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/snp_calling/Dyspera/pallida/
#bcftools mpileup --threads 16 -b /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/bamlist4.txt --annotate AD,DP --fasta-ref /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/break10x/purge_dups/sanger/MitoHifi/filtered/inspector/T_anthrisci_820m_48_1_10.0_0.25_break_TellSeqPurged_curated_nomito_filtered_corrected.fa -O z -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/snp_calling/Dyspera/pallida/variants_1.vcf.gz

#bcftools call --threads 16 --ploidy 2 -Oz -v -m -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/snp_calling/Dyspera/pallida/variants.vcf.gz  /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/snp_calling/Dyspera/pallida/variants_1.vcf.gz

#source package 3e7beb4d-f08b-4d6b-9b6a-f99cc91a38f9
#source package 638df626-d658-40aa-80e5-14a275b7464b
#for file in $(ls /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/resequencing_psyllids/dna_qc/Dyspera/*/*/trim_galore/bwa-mem/*_trimmed_1_sorted.bam); do
#    OutDir=$(dirname $file)
#    OutFile=$(basename $file | sed s'@_sorted.bam@_sorted_MarkDups.bam@g')
#    metrics=$(basename $file | sed s'@_trimmed_1_sorted.bam@@g')_marked_dup_metrics.txt
#    java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar SortSam I=${file} O=${OutDir}/temp.bam SORT_ORDER=coordinate
#    java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar MarkDuplicates REMOVE_DUPLICATES=true I=${OutDir}/temp.bam O=${OutDir}/${OutFile} M=${OutDir}/${metrics}
#    cd ${OutDir}
#    rm temp.bam
#    samtools index ${OutFile}
#    cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae
#done

#mkdir /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/break10x/purge_dups/sanger/MitoHifi/filtered/inspector/juicer
#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/break10x/purge_dups/sanger/MitoHifi/filtered/inspector/juicer
#mkdir restriction_sites;mkdir references;mkdir fastq
#cd fastq
#ln -s /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_anthrisci/HiC/anthrisci_286154-S3HiC_R1.fastq.gz .
#ln -s /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_anthrisci/HiC/anthrisci_286154-S3HiC_R2.fastq.gz .
#cd ../references
#ln -s /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/break10x/purge_dups/sanger/MitoHifi/filtered/inspector/T_anthrisci_820m_48_1_10.0_0.25_break_TellSeqPurged_curated_nomito_filtered_corrected.fa .
#source bwa-0.7.17
#bwa index T_anthrisci_820m_48_1_10.0_0.25_break_TellSeqPurged_curated_nomito_filtered_corrected.fa
#cd ../restriction_sites
#Enzyme=DpnII
#singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 ~/git_repos/Scripts/NBI/generate_site_positions.py $Enzyme OutFile ../references/T_anthrisci_820m_48_1_10.0_0.25_break_TellSeqPurged_curated_nomito_filtered_corrected.fa
#awk 'BEGIN{OFS="\t"}{print $1, $NF}' OutFile_DpnII.txt > OutFile_DpnII.chrom.sizes
#cd ..
#mkdir -p scripts/common
#cp ~/git_repos/Scripts/NBI/chimeric_blacklist.awk scripts/common/.
#source jdk-1.7.0_25; source bwa-0.7.17;source samtools-1.6;source gnu_parallel-20180322
#singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/juicer.sif juicer.sh -D /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/break10x/purge_dups/sanger/MitoHifi/filtered/inspector/juicer -d /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/break10x/purge_dups/sanger/MitoHifi/filtered/inspector/juicer -g OutFile -z references/T_anthrisci_820m_48_1_10.0_0.25_break_TellSeqPurged_curated_nomito_filtered_corrected.fa -y restriction_sites/OutFile_DpnII.txt -s DpnII -t 32 -p restriction_sites/OutFile_DpnII.chrom.sizes 

#for file in $(ls /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/nano_diagnostics/Genomes/*/*/*/BUSCO/fungi_odb10/run_fungi_odb10/busco_sequences/single_copy_busco_sequences.tar.gz); do
#cd $(dirname $file)
#tar -xzvf single_copy_busco_sequences.tar.gz
#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Genomes
#done

#for dir in $(ls -d /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/nano_diagnostics/Genomes/*/*/*/BUSCO/fungi_odb10/run_fungi_odb10/busco_sequences/single_copy_busco_sequences); do
#  sppname=$(echo $dir |cut -f9,10,11 -d "/" | sed 's@/@_@g');
#  abbrv=$(echo $dir | cut -d '/' -f9 | cut -c 1-3)_$(echo $dir | cut -d '/' -f10 | cut -c 1-3)_$(echo $dir | cut -d '/' -f11)
#  echo $sppname
#  echo $abbrv
#  for file in ${dir}/*.fna; do
#    out=$(echo $file |rev |cut -f 1 -d "/"|rev)
 #   cp $file /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/nano_diagnostics/analysis/phylogeny/busco_nt/${sppname}_${out}
 #   sed -i 's/^>/>'${abbrv}'|/g' /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/nano_diagnostics/analysis/phylogeny/busco_nt/${sppname}_${out}
 # cut -f 1 -d ":" /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/nano_diagnostics/analysis/phylogeny/busco_nt/${sppname}_${out} | tr '[:lower:]' '[:upper:]' > /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/nano_diagnostics/analysis/phylogeny/busco_nt/${sppname}_${out}.1 && mv /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/nano_diagnostics/analysis/phylogeny/busco_nt/${sppname}_${out}.1 /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/nano_diagnostics/analysis/phylogeny/busco_nt/${sppname}_${out}  
 # done
#done

#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/nano_diagnostics/analysis/phylogeny/busco_nt
#buscos=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/nano_diagnostics/analysis/phylogeny/complete_busco_ids_3.txt
#lines=$(cat $buscos)
#for line in $lines; do
#  for fna in $(ls *_$line.fna); do
#  output=$(echo $line)_nt.fasta
#  cat $fna >> $output
#  done
#done

#source package c92263ec-95e5-43eb-a527-8f1496d56f1a
#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/Liberibacter
#samtools fastq -@32 minimap2/assembly_v1.fa.sam > reads.fastq

#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/break10x/purge_dups/sanger/MitoHifi/carsonella/minimap2
#samtools fastq -@32 carsonella_contigs.sam > reads.fastq

#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/break10x/purge_dups/sanger/MitoHifi/carsonella/minimap2
#samtools fastq -@32 carsonella_contigs.sam > reads.fastq

#sleep 300s
#source package 3e7beb4d-f08b-4d6b-9b6a-f99cc91a38f9
#java17 -Xmx200000m -Djava.awt.headless=true -jar ~/git_repos/Scripts/NBI/juicer_tools_1.22.01.jar pre --threads 16 /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/purge_dups/yahs/scaff10x/T_apicales_880m_29_3_3.0_0.75_TellSeqPurged_scaffolds_final_scaff10xscaffolds_mapped.pairs /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/purge_dups/yahs/scaff10x/T_apicales_880m_29_3_3.0_0.75_TellSeqPurged_scaffolds_final_scaff10xscaffolds_contact_map.hic /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/purge_dups/yahs/scaff10x/T_apicales_880m_29_3_3.0_0.75_TellSeqPurged_scaffolds_final_scaff10xscaffolds.genome

#WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
#mkdir $WorkDir  
#cd $WorkDir 
#singularity exec --overlay /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/overlays/genomation1.34.0-overlay.sif:ro /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/genomation1.34.0.sif R --save - <<EOF 

#library("genomation")
#library("methylKit")
#Read in the methylation ratio files
#NB.file.list <- list("/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/BR25_E2_1/bsmap/CpG_BR25_E2_1_bsmap_ratios_filtered.txt",
#"/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/BR25_E2_2/bsmap/CpG_BR25_E2_2_bsmap_ratios_filtered.txt",
#"/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/BR25_E2_3/bsmap/CpG_BR25_E2_3_bsmap_ratios_filtered.txt",
#"/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/NB25_E2_1/bsmap/CpG_NB25_E2_1_bsmap_ratios_filtered.txt",
#"/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/NB25_E2_2/bsmap/CpG_NB25_E2_2_bsmap_ratios_filtered.txt",
#"/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/NB25_E2_3/bsmap/CpG_NB25_E2_3_bsmap_ratios_filtered.txt")
#NB.week1=methRead(NB.file.list, 
#    sample.id=list("BR25_E2_1","BR25_E2_2","BR25_E2_3","NB25_E2_1","NB25_E2_2","NB25_E2_3"),
#    assembly="O_v2",
#    header=TRUE,
#    treatment=c(0,0,0,1,1,1),
#    mincov = 4,
#    context="CpG",
#    resolution="base",
#    pipeline=list(fraction=TRUE,chr.col=1,start.col=2,end.col=2,coverage.col=6,strand.col=3,freqC.col=5 ))
#NB.week1
#AT.file.list <- list("/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/BR25_E2_1/bsmap/CpG_BR25_E2_1_bsmap_ratios_filtered.txt",
#"/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/BR25_E2_2/bsmap/CpG_BR25_E2_2_bsmap_ratios_filtered.txt",
#"/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/BR25_E2_3/bsmap/CpG_BR25_E2_3_bsmap_ratios_filtered.txt",
##"/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/AT25_E2_1/bsmap/CpG_AT25_E2_1_bsmap_ratios_filtered.txt",
#"/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/AT25_E2_2/bsmap/CpG_AT25_E2_2_bsmap_ratios_filtered.txt",
#"/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/AT25_E2_3/bsmap/CpG_AT25_E2_3_bsmap_ratios_filtered.txt")
#AT.week1=methRead(AT.file.list, 
#    sample.id=list("BR25_E2_1","BR25_E2_2","BR25_E2_3","AT25_E2_1","AT25_E2_2","AT25_E2_3"),
#    assembly="O_v2",
#    header=TRUE,
#    treatment=c(0,0,0,1,1,1),
#    mincov = 4,
#    context="CpG",
#    resolution="base",
#    pipeline=list(fraction=TRUE,chr.col=1,start.col=2,end.col=2,coverage.col=6,strand.col=3,freqC.col=5 ))
#AT.week1

#Read in annotation info
#refseq_anot <- readTranscriptFeatures("/jic/research-groups/Saskia-Hogenhout/TCHeaven/Genomes/Myzus/persicae/O_v2/MYZPE13164_O_EIv2.1.annotation.bed12",remove.unusual=FALSE)
#cpg_anot <- readFeatureFlank("/jic/research-groups/Saskia-Hogenhout/TCHeaven/Genomes/Myzus/persicae/O_v2/MYZPE13164_O_EIv2.1.cpg.bed", feature.flank.name = c("CpGi", "shores"), flank=2000)

##################################################################################################################

#Group methylation count by sliding window region:
#NB.tiles <- tileMethylCounts(NB.week1,win.size=1000,step.size=1000,cov.bases = 10)

#Filter and normalise
#NB.tiles.filt <- filterByCoverage(NB.tiles,
#                      lo.count=4,
#                      lo.perc=NULL,
#                      hi.count=NULL,
#                      hi.perc=99.9)
#NB.tiles.filt.norm <- normalizeCoverage(NB.tiles.filt, method = "median")
#NB.meth.tiles <- unite(NB.tiles.filt.norm, destrand=FALSE)
#NB.meth.tiles
#NB.diff.tiles <- calculateDiffMeth(NB.meth.tiles,
#                            treatment=c(0,0,0,1,1,1),
#                            overdispersion = "MN",
#                            adjust="BH")
#NB.diff.tiles
#save(NB.diff.tiles, file = "/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/analysis/Myzus/persicae/WGBS/Archana_Mar2021/methylkit/NB25_diffmeth_windowed.RData")

#################################################################################################################

#Group methylation count by sliding window region:
#AT.tiles <- tileMethylCounts(AT.week1,win.size=1000,step.size=1000,cov.bases = 10)

#Filter and normalise
#AT.tiles.filt <- filterByCoverage(AT.tiles,
#                      lo.count=4,
#                      lo.perc=NULL,
#                      hi.count=NULL,
#                      hi.perc=99.9)
#AT.tiles.filt.norm <- normalizeCoverage(AT.tiles.filt, method = "median")
#AT.meth.tiles <- unite(AT.tiles.filt.norm, destrand=FALSE)
#AT.meth.tiles
#AT.diff.tiles <- calculateDiffMeth(AT.meth.tiles,
#                            treatment=c(0,0,0,1,1,1),
#                            overdispersion = "MN",
#                            adjust="BH")
#AT.diff.tiles
#save(AT.diff.tiles, file = "/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/analysis/Myzus/persicae/WGBS/Archana_Mar2021/methylkit/AT25_diffmeth_windowed.RData")

#################################################################################################################
#EOF

#echo Done
#rm -r $WorkDir