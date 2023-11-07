#!/bin/bash
#SBATCH --job-name=bash
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 50G
#SBATCH -c 4
#SBATCH -p jic-long
#SBATCH --time=30-00:00:00

source package 638df626-d658-40aa-80e5-14a275b7464b
source /nbi/software/staging/RCSUPPORT-2652/stagingloader
source package 222eac79-310f-4d4b-8e1c-0cece4150333
source package /tgac/software/production/bin/abyss-1.3.5

minimap2 -t 4 -ax map-hifi /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/T_urticae_715m_12_2_3.0_0.5.bp.p_ctg.fa /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_urticae/HiFi/urticae_hifi-3rdSMRTcell.fastq.gz /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_urticae/HiFi/urticae_hifi-reads.fastq.gz --secondary=no \
    | samtools sort -m 1G -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/minimap2/T_urticae_715m_12_2_3.0_0.5_aligned.bam -T tmp.ali

cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/minimap2/
samtools faidx T_urticae_715m_12_2_3.0_0.5_aligned.bam

#source package fcb78328-af4f-424b-9916-c46bf8fab592
#source package 81c2d095-ba51-4eee-b471-19b7f3b1b117
#source samtools-1.9
#source bwa-0.7.17

#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/tmp_57291096/juicer/aligned
#run-asm-pipeline.sh --build-gapped-map -m diploid --rounds 1 --editor-repeat-coverage 5 --editor-saturation-centile 10 ../../genome_wrapped.fa merged_nodups.txt #57336476

#source package bebaaf29-d3b7-48d5-ae7b-e5d9018ab359
#meryl union-sum output /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/purge_dups/tellseq/meryl/HiFi/T_anthrisci_820m_48_1_10.0_0.25_TellSeqPurged.meryl /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_anthrisci/HiFi/meryl/*.meryl
#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/purge_dups/tellseq/merqury/HiFi
#ln -sL /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/purge_dups/tellseq/meryl/HiFi/T_anthrisci_820m_48_1_10.0_0.25_TellSeqPurged.meryl
#cp -L /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/purge_dups/tellseq/T_anthrisci_820m_48_1_10.0_0.25_TellSeqPurged.fa T_anthrisci_820m_48_1_10.0_0.25_break_TellSeqPurged_pilon.fasta
#meryl histogram T_anthrisci_820m_48_1_10.0_0.25_TellSeqPurged.meryl > T_anthrisci_820m_48_1_10.0_0.25_TellSeqPurged.meryl.hist
#merqury.sh T_anthrisci_820m_48_1_10.0_0.25_TellSeqPurged.meryl/ T_anthrisci_820m_48_1_10.0_0.25_break_TellSeqPurged_pilon.fasta out

#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/purge_dups/tellseq/merqury/HiFi
#spectra_cn=$(ls *.spectra-cn.hist)
#cn_only_hist=$(ls *.only.hist)
#Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_cn -o $(echo $spectra_cn | sed 's@.hist@@g')_1000 -z $cn_only_hist -m 1000 -n 12500000 
#Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_cn -o $(echo $spectra_cn | sed 's@.hist@@g')_300 -z $cn_only_hist -m 300 -n 12500000 
#Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_cn -o $(echo $spectra_cn | sed 's@.hist@@g')_100 -z $cn_only_hist -m 100 -n 12500000 
#spectra_asm=$(ls *.spectra-asm.hist)
#asm_only_host=$(ls *.dist_only.hist)
#Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_asm -o $(echo $spectra_asm | sed 's@.hist@@g')_1000 -z $asm_only_host -m 1000 -n 16000000 
#Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_asm -o $(echo $spectra_asm | sed 's@.hist@@g')_300 -z $asm_only_host -m 300 -n 16000000 
#Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_asm -o $(echo $spectra_asm | sed 's@.hist@@g')_100 -z $asm_only_host -m 100 -n 16000000 

#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/
#source package 638df626-d658-40aa-80e5-14a275b7464b

#samtools sort -@64 -T ${WorkDir}/tempq.bam -o T_anthrisci_820m_48_1_10.0_0.25_mapped.PT.bam T_anthrisci_820m_48_1_10.0_0.25_unsorted.bam
#samtools sort -@64 -T ${WorkDir}/tempw.bam -o T_anthrisci_820m_48_1_10.0_0.25_TellSeqPurged_mapped.PT.bam T_anthrisci_820m_48_1_10.0_0.25_TellSeqPurged_unsorted.bam
#samtools sort -@64 -T ${WorkDir}/tempe.bam -o T_anthrisci_820m_48_1_10.0_0.25_TellSeqPurged_pilon_mapped.PT.bam T_anthrisci_820m_48_1_10.0_0.25_TellSeqPurged_pilon_unsorted.bam


#samtools sort -@64 -T ${WorkDir}/tempr.bam -o T_apicales_880m_29_3_3.0_0.75_mapped.PT.bam T_apicales_880m_29_3_3.0_0.75_unsorted.bam
#samtools sort -@64 -T ${WorkDir}/tempt.bam -o T_apicales_880m_29_3_3.0_0.75_TellSeqPurged_mapped.PT.bam T_apicales_880m_29_3_3.0_0.75_TellSeqPurged_unsorted.bam
#samtools sort -@64 -T ${WorkDir}/tempy.bam -o T_apicales_880m_29_3_3.0_0.75_pilon_mapped.PT.bam T_apicales_880m_29_3_3.0_0.75_pilon_unsorted.bam


#samtools sort -@64 -T ${WorkDir}/tempu.bam -o T_urticae_715m_12_2_3.0_0.5_TellSeqPurged_mapped.PT.bam T_urticae_715m_12_2_3.0_0.5_TellSeqPurged_unsorted.bam
#samtools sort -@64 -T ${WorkDir}/tempi.bam -o T_urticae_715m_12_2_3.0_0.5_TellSeqPurged_pilon_mapped.PT.bam T_urticae_715m_12_2_3.0_0.5_pilon_unsorted.bam


#samtools index T_anthrisci_820m_48_1_10.0_0.25_mapped.PT.bam
#samtools index T_anthrisci_820m_48_1_10.0_0.25_TellSeqPurged_mapped.PT.bam
#samtools index T_anthrisci_820m_48_1_10.0_0.25_TellSeqPurged_pilon_mapped.PT.bam

#samtools index T_apicales_880m_29_3_3.0_0.75_mapped.PT.bam
#samtools index T_apicales_880m_29_3_3.0_0.75_TellSeqPurged_mapped.PT.bam
#samtools index T_apicales_880m_29_3_3.0_0.75_pilon_mapped.PT.bam

#samtools index T_urticae_715m_12_2_3.0_0.5_TellSeqPurged_mapped.PT.bam
#samtools index T_urticae_715m_12_2_3.0_0.5_TellSeqPurged_pilon_mapped.PT.bam

#preseq lc_extrap -bam -pe -extrap 2.1e9 -step 1e8 -seg_len 1000000000 -output T_anthrisci_820m_48_1_10.0_0.25_out.preseq T_anthrisci_820m_48_1_10.0_0.25_mapped.PT.bam
#preseq lc_extrap -bam -pe -extrap 2.1e9 -step 1e8 -seg_len 1000000000 -output T_anthrisci_820m_48_1_10.0_0.25_TellSeqPurged_out.preseq T_anthrisci_820m_48_1_10.0_0.25_TellSeqPurged_mapped.PT.bam
#preseq lc_extrap -bam -pe -extrap 2.1e9 -step 1e8 -seg_len 1000000000 -output T_anthrisci_820m_48_1_10.0_0.25_TellSeqPurged_pilon_out.preseq T_anthrisci_820m_48_1_10.0_0.25_TellSeqPurged_pilon_mapped.PT.bam

#preseq lc_extrap -bam -pe -extrap 2.1e9 -step 1e8 -seg_len 1000000000 -output T_apicales_880m_29_3_3.0_0.75_out.preseq T_apicales_880m_29_3_3.0_0.75_mapped.PT.bam
#preseq lc_extrap -bam -pe -extrap 2.1e9 -step 1e8 -seg_len 1000000000 -output T_apicales_880m_29_3_3.0_0.75_TellSeqPurged_out.preseq T_apicales_880m_29_3_3.0_0.75_TellSeqPurged_mapped.PT.bam
#preseq lc_extrap -bam -pe -extrap 2.1e9 -step 1e8 -seg_len 1000000000 -output T_apicales_880m_29_3_3.0_0.75_pilon_out.preseq T_apicales_880m_29_3_3.0_0.75_pilon_mapped.PT.bam

#preseq lc_extrap -bam -pe -extrap 2.1e9 -step 1e8 -seg_len 1000000000 -output T_urticae_715m_12_2_3.0_0.5_TellSeqPurged_out.preseq T_urticae_715m_12_2_3.0_0.5_TellSeqPurged_mapped.PT.bam
#preseq lc_extrap -bam -pe -extrap 2.1e9 -step 1e8 -seg_len 1000000000 -output T_urticae_715m_12_2_3.0_0.5_TellSeqPurged_pilon_out.preseq T_urticae_715m_12_2_3.0_0.5_TellSeqPurged_pilon_mapped.PT.bam

#samtools sort -@64 -T ${WorkDir}/tempq.bam -o T_anthrisci_820m_48_1_10.0_0.25_break_mapped.PT.bam T_anthrisci_820m_48_1_10.0_0.25_break_unsorted.bam
#samtools sort -@64 -T ${WorkDir}/tempw.bam -o T_apicales_880m_29_3_3.0_0.75_break_mapped.PT.bam T_apicales_880m_29_3_3.0_0.75_break_unsorted.bam
#samtools sort -@64 -T ${WorkDir}/tempe.bam -o T_urticae_715m_12_2_3.0_0.5_break_mapped.PT.bam T_urticae_715m_12_2_3.0_0.5_break_unsorted.bam

#samtools index T_anthrisci_820m_48_1_10.0_0.25_break_mapped.PT.bam
#samtools index T_apicales_880m_29_3_3.0_0.75_break_mapped.PT.bam
#samtools index T_urticae_715m_12_2_3.0_0.5_break_mapped.PT.bam

#source package /tgac/software/testing/bin/preseq-3.1.2
#source package /tgac/software/testing/bin/pairtools-0.3.0
#preseq lc_extrap -bam -pe -extrap 2.1e9 -step 1e8 -seg_len 1000000000 -output T_anthrisci_820m_48_1_10.0_0.25_break_out.preseq T_anthrisci_820m_48_1_10.0_0.25_break_mapped.PT.bam
#preseq lc_extrap -bam -pe -extrap 2.1e9 -step 1e8 -seg_len 1000000000 -output T_apicales_880m_29_3_3.0_0.75_break_out.preseq T_apicales_880m_29_3_3.0_0.75_break_mapped.PT.bam
#preseq lc_extrap -bam -pe -extrap 2.1e9 -step 1e8 -seg_len 1000000000 -output T_urticae_715m_12_2_3.0_0.5_break_out.preseq T_urticae_715m_12_2_3.0_0.5_break_mapped.PT.bam

#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/break10x/bwa/
#samtools index T_urticae_715m_12_2_3.0_0.5_break_sorted_markdups_Tellseq_trimmed.bam
#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/break10x/bwa/
#samtools index T_apicales_880m_29_3_3.0_0.75_break_sorted_markdups_Tellseq_trimmed.bam
#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/break10x/bwa/
#samtools index T_anthrisci_820m_48_1_10.0_0.25_break_sorted_markdups_Tellseq_trimmed.bam

#samtools sort -@32 -T ./tempq.bam -o T_urticae_715m_12_2_3.0_0.5_pilon_break_TellSeqPurged_mapped.PT.bam T_urticae_715m_12_2_3.0_0.5_pilon_break_TellSeqPurged_unsorted.bam
#samtools index T_urticae_715m_12_2_3.0_0.5_pilon_break_TellSeqPurged_mapped.PT.bam
#preseq lc_extrap -bam -pe -extrap 2.1e9 -step 1e8 -seg_len 1000000000 -output T_urticae_715m_12_2_3.0_0.5_pilon_break_TellSeqPurged_out.preseq T_urticae_715m_12_2_3.0_0.5_pilon_break_TellSeqPurged_mapped.PT.bam

#samtools sort -@32 -T ./tempq.bam -o T_urticae_715m_12_2_3.0_0.5_break_TellSeqPurged_mapped.PT.bam T_urticae_715m_12_2_3.0_0.5_break_TellSeqPurged_unsorted.bam
#samtools index T_urticae_715m_12_2_3.0_0.5_break_TellSeqPurged_mapped.PT.bam
#preseq lc_extrap -bam -pe -extrap 2.1e9 -step 1e8 -seg_len 1000000000 -output T_urticae_715m_12_2_3.0_0.5_break_TellSeqPurged_out.preseq T_urticae_715m_12_2_3.0_0.5_break_TellSeqPurged_mapped.PT.bam

#samtools sort -@32 -T ${WorkDir}/tempq.bam -o T_apicales_880m_29_3_3.0_0.75_pilon_break_TellSeqPurged_mapped.PT.bam T_apicales_880m_29_3_3.0_0.75_pilon_break_TellSeqPurged_unsorted.bam
#samtools index T_apicales_880m_29_3_3.0_0.75_pilon_break_TellSeqPurged_mapped.PT.bam
#preseq lc_extrap -bam -pe -extrap 2.1e9 -step 1e8 -seg_len 1000000000 -output T_apicales_880m_29_3_3.0_0.75_pilon_break_TellSeqPurged_out.preseq T_apicales_880m_29_3_3.0_0.75_pilon_break_TellSeqPurged_mapped.PT.bam

#samtools sort -@32 -T ${WorkDir}/tempq.bam -o T_apicales_880m_29_3_3.0_0.75_break_TellSeqPurged_mapped.PT.bam T_apicales_880m_29_3_3.0_0.75_break_TellSeqPurged_unsorted.bam
#samtools index T_apicales_880m_29_3_3.0_0.75_break_TellSeqPurged_mapped.PT.bam
#preseq lc_extrap -bam -pe -extrap 2.1e9 -step 1e8 -seg_len 1000000000 -output T_apicales_880m_29_3_3.0_0.75_break_TellSeqPurged_out.preseq T_apicales_880m_29_3_3.0_0.75_break_TellSeqPurged_mapped.PT.bam

#samtools sort -@32 -T ${WorkDir}/tempq.bam -o T_anthrisci_820m_48_1_10.0_0.25_pilon_break_TellSeqPurged_mapped.PT.bam T_anthrisci_820m_48_1_10.0_0.25_pilon_break_TellSeqPurged_unsorted.bam
#samtools index T_anthrisci_820m_48_1_10.0_0.25_pilon_break_TellSeqPurged_mapped.PT.bam
#preseq lc_extrap -bam -pe -extrap 2.1e9 -step 1e8 -seg_len 1000000000 -output T_anthrisci_820m_48_1_10.0_0.25_pilon_break_TellSeqPurged_out.preseq T_anthrisci_820m_48_1_10.0_0.25_pilon_break_TellSeqPurged_mapped.PT.bam

#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/tmp_12312312312
#bwa mem -5SP -T0 -t 32 genome.fa Fread.fq.gz Rread.fq.gz -o T_anthrisci_820m_48_1_10.0_0.25_break_TellSeqPurged.sam
#57279809

