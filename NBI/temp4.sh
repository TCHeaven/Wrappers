#!/bin/bash
#SBATCH --job-name=trinity
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 150G
#SBATCH -c 1
#SBATCH -p jic-long
#SBATCH --time=30-00:00:00

#source package a684a2ed-d23f-4025-aa81-b21e27e458df
#cpgplot -sequence /jic/research-groups/Saskia-Hogenhout/TCHeaven/Genomes/Myzus/persicae/O_v2/Myzus_persicae_O_v2.0.scaffolds.fa -window 100 -minlen 200 -minoe 0.6 -minpc 50. -graph cps -cg -pc -obsexp -outfile /jic/research-groups/Saskia-Hogenhout/TCHeaven/Genomes/Myzus/persicae/O_v2/MYZPE13164_O_EIv2.1.cpgplot -outfeat /jic/research-groups/Saskia-Hogenhout/TCHeaven/Genomes/Myzus/persicae/O_v2/MYZPE13164_O_EIv2.1.cpg.gff

forward=$(ls /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/dna_qc/Myzus/persicae/RNA_Seq/Archana_Dec2020/*/*/trim_galore/**1.fq.gz /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/dna_qc/Myzus/persicae/RNA_Seq/Archana/*/*/trim_galore/*1.fq.gz /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/dna_qc/Myzus/persicae/RNA_Seq/Myzus_persicae_O_9_species_host_swap/*/*/*1.fq.gz /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/dna_qc/Myzus/persicae/RNA_Seq/Mpersicae_organ_RNAseq/trim_galore/*/*1.fq.gz | tr '\n' ',' | sed 's/,$//')
reverse=$(ls /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/dna_qc/Myzus/persicae/RNA_Seq/Archana_Dec2020/*/*/trim_galore/*2.fq.gz /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/dna_qc/Myzus/persicae/RNA_Seq/Archana/*/*/trim_galore/*2.fq.gz /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/dna_qc/Myzus/persicae/RNA_Seq/Myzus_persicae_O_9_species_host_swap/*/*/*2.fq.gz /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/dna_qc/Myzus/persicae/RNA_Seq/Mpersicae_organ_RNAseq/trim_galore/*/*2.fq.gz | tr '\n' ',' | sed 's/,$//') 

Trinity is using a huge amount of hard drive space + appears to be amking 3 trimmed files for every input?.
source package 09da5776-7777-44d1-9fac-4c372b38fd37
Trinity --single $1 --output ${1}.out --CPU 1 --max_memory 100G --run_as_paired --seqType fa --trinity_complete --full_cleanup --min_kmer_cov 2 --verbose --bflyHeapSpaceMax 100G

#Trinity --full_cleanup --seqType fq --CPU 64 --max_memory 4030G --min_kmer_cov 2 --normalize_by_read_set --verbose --FORCE \
#--left $forward \
#--right $reverse \
#--output /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/M_persicae_trinity_transcriptome

#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae
#echo test > temp_largememtest.txt

#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/break10x/purge_dups/pilon/scaff10x/yahs/juicer
#source jdk-1.7.0_25; source bwa-0.7.17;source samtools-1.6; source gnu_parallel-20180322
#singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/juicer.sif juicer.sh -D /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/break10x/purge_dups/pilon/scaff10x/yahs/juicer -d /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/break10x/purge_dups/pilon/scaff10x/yahs/juicer -g OutFile -z references/T_apicales_880m_29_3_3.0_0.75_break_TellSeqPurged_pilon_scaff10xscaffolds_scaffolds_final.fa -y restriction_sites/OutFile_DpnII.txt -s DpnII -t 64 -p restriction_sites/OutFile_DpnII.chrom.sizes

#awk: fatal: can't open source file `/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/break10x/purge_dups/pilon/scaff10x/yahs/juicer/scripts/common/chimeric_blacklist.awk' for reading (No such file or directory)

#source package 638df626-d658-40aa-80e5-14a275b7464b
#source package /tgac/software/testing/bin/preseq-3.1.2
#source package /tgac/software/testing/bin/pairtools-0.3.0
#source bwa-0.7.17

#WorkDir=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/temp_short_omni

#cpu=64

#Assembly=$1
#Enzyme=$2
#OutDir=$3
#OutFile=$4
#Read1=$5
#Read2=$6

#ln -s $Assembly $WorkDir/genome.fa
#ln -s $Read1 $WorkDir/Fread.fq.gz
#ln -s $Read2 $WorkDir/Rread.fq.gz
#cd $WorkDir

#echo "Creating BWA index..."
#bwa index genome.fa

#samtools import -@ $cpu -r ID:$(basename $Read1 | cut -d '_' -f1,2) -r CN:$(basename $Read1 | cut -d '_' -f1,2 | cut -d '-' -f2) -r PU:$(basename $Read1 | cut -d '_' -f1,2) -r SM:$(basename $Read1 | cut -d '_' -f1,2 | cut -d '-' -f1) Fread.fq.gz Rread.fq.gz -o cram.cram
#samtools index -@ $cpu cram.cram

##map reads
#count=1
#echo "Mapping Illumina HiC reads..."

#CRAM_FILTER="singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/cram_filter.sif cram_filter"
#for i in $(ls cram.cram); do
#    CRINDEX=$i.crai
#    CFROM=0
#    CTO=10000
#    NCONTAINERS=`zcat $CRINDEX |wc -l`

#    if [ "$NCONTAINERS" == "0" ]; then
#	echo "can't find HiC reads in $CRINDEX"
#	exit 1
#    fi

#    while [ "$CFROM" -le "$NCONTAINERS" ]; do
#        if [ "$CTO" -gt "$NCONTAINERS" ]; then
#          CTO=$NCONTAINERS
#        fi
#        $CRAM_FILTER -n $CFROM-$CTO $i - | samtools fastq -@ $cpu -F0xB00 -nt - | bwa mem -T 10 -t $cpu -5SPCp genome.fa - | samtools fixmate -mpu -@ $cpu - - | samtools sort -@ $cpu --write-index -l9 -o ${OutFile}.${count}.align.bam -
#        ((count++))
#        CFROM=$((CTO+1 ))
#        CTO=$((CFROM+9999))
#    done
#done

#myFilter=~/git_repos/Scripts/NBI/filter_five_end.pl
#if [[ -f "$myFilter" ]]; then
#	count=1
#	echo "Filtering BAM files..."
#	for i in `ls -1 *.align.bam`
#		do
#			samtools view -@ $cpu -h $i | $myFilter | samtools sort -@ $cpu - > ${OutFile}.${count}.filtered.bam
#		((count++))
#		done
#	if [[ ! -f ${OutFile}.1.filtered.bam ]]; then
#		echo "${OutFile}.1.filtered.bam doesn't exist." 
#	exit 1
#	fi
	#rm *.align.bam
#fi

#if [ `ls -1 *filtered.bam | wc -l` -gt 1 ]; then
#	echo "Merging BAM files..."
#	ls -1 *filtered.bam > bamlist
#	samtools merge -@ $cpu -cpu -b bamlist - |samtools markdup -@ $cpu --write-index - ${OutFile}_mapped.bam
#else
#	samtools markdup -@ $cpu --write-index ${OutFile}.1.*.bam ${OutFile}_mapped.bam
#fi

#source bwa-0.7.17
#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/canu/715m/purge_dups/
#source package 0567474a-7a7f-40c6-9f91-6272b934f8a4
#Assembly=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/canu/715m/purge_dups/T_urticae_715m.contigs_TellSeqPurged.fa
#AssemblyIndex=$(echo $Assembly).fai
#MappingFile=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/canu/715m/bwa/T_urticae_715m.contigs_Tellseq_trimmed_2.bam
#purge_haplotigs hist -b $MappingFile -g $Assembly -t 1

#Assembly=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/canu/715m/purge_dups/T_urticae_715m.contigssta_HiFiPurged.fa
#AssemblyIndex=$(echo $Assembly).fai
#MappingFile=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/canu/715m/minimap2/T_urticae_715m.contigs.bam
#purge_haplotigs hist -b $MappingFile -g $Assembly -t 32

#bwa index T_urticae_715m.contigs_TellSeqPurged.fa
#bwa index T_urticae_715m.contigssta_HiFiPurged.fa

#source package 638df626-d658-40aa-80e5-14a275b7464b
#samtools faidx T_urticae_715m.contigs_TellSeqPurged.fa
#samtools faidx T_urticae_715m.contigssta_HiFiPurged.fa
#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/canu/715m/minimap2/
#samtools sort -o T_urticae_715m.contigs.bam T_urticae_715m.contigs.bam
#samtools index T_urticae_715m.contigs.bam

#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/canu/715m/minimap2
#samtools index T_urticae_715m.contigs.bam
#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/canu/715m/bwa/
#samtools index T_urticae_715m.contigs_Tellseq_trimmed_2.bam

#source package 638df626-d658-40aa-80e5-14a275b7464b
#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/AT1_E2_1/bsmap
#samtools view -@32 -h -o sam.sam AT1_E2_1_bsmap.bam
#samtools view -@32 -bS sam.sam | samtools sort -@32 -o sam.bam 
#samtools index -@32 sam.bam sam.bam.bai

#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/tmp_57561455
#singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/bsmap2.9.sif sam2bam.sh NB9_E2_3_bsmap.sam

#source package 638df626-d658-40aa-80e5-14a275b7464b
#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/tmp_57561455
#samtools view -@32 -h -o NB9_E2_3_bsmap.sam NB9_E2_3_bsmap.bam

#source package 638df626-d658-40aa-80e5-14a275b7464b
#source /jic/software/staging/RCSUPPORT-2245/stagingloader
#PretextMap -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/break10x/purge_dups/pilon/scaff10x/yahs/T_apicales_880m_29_3_3.0_0.75_break_TellSeqPurged_pilon_scaff10xscaffolds_scaffolds_final_mapped.pairs.pretext --sortby length --sortorder descend --mapq 10 --highRes < /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/break10x/purge_dups/pilon/scaff10x/yahs/T_apicales_880m_29_3_3.0_0.75_break_TellSeqPurged_pilon_scaff10xscaffolds_scaffolds_final_mapped.pairs

#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/break10x/purge_dups/pilon/scaff10x/yahs/juicer/references
#source bwa-0.7.17
#bwa index T_apicales_880m_29_3_3.0_0.75_break_TellSeqPurged_pilon_scaff10xscaffolds_scaffolds_final.fa

#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/tmp_57554577
#source package 638df626-d658-40aa-80e5-14a275b7464b
#samtools index NB9_E2_3_bsmap.bam
#singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/bsmap2.9.sif methratio.py -d genome.fa -o NB9_E2_3_bsmap_ratios.txt -u -p -z NB9_E2_3_bsmap.bam
#python ~/git_repos/Scripts/NBI/methratio.py -d genome.fa -o NB9_E2_3_bsmap_ratios2.txt -u -p -z NB9_E2_3_bsmap.bam

#source package 3e7beb4d-f08b-4d6b-9b6a-f99cc91a38f9
#java17 -Xmx48000m -Djava.awt.headless=true -jar ~/git_repos/Scripts/NBI/juicer_tools_1.22.01.jar pre --threads 16 /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/purge_dups/yahs/scaff10x/T_apicales_880m_29_3_3.0_0.75_TellSeqPurged_scaffolds_final_scaff10xscaffolds_mapped.pairs /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/purge_dups/yahs/scaff10x/T_apicales_880m_29_3_3.0_0.75_TellSeqPurged_scaffolds_final_scaff10xscaffolds_contact_map.hic /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/purge_dups/yahs/scaff10x/T_apicales_880m_29_3_3.0_0.75_TellSeqPurged_scaffolds_final_scaff10xscaffolds.genome


#source switch-institute ei
#source pilon-1.22
#source package 3e7beb4d-f08b-4d6b-9b6a-f99cc91a38f9
#source package /tgac/software/testing/bin/picardtools-2.1.1

#touch /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/bwa/T_anthrisci_820m_48_1_10.0_0.25_sorted_markdups_HiC.bam
#java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar MarkDuplicates I=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/bwa/T_anthrisci_820m_48_1_10.0_0.25_sorted_HiC.bam O=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/bwa/T_anthrisci_820m_48_1_10.0_0.25_sorted_markdups_HiC.bam M=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/bwa/marked_dup_metrics.txt
#java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar MarkDuplicates I=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/bwa/T_anthrisci_820m_48_1_10.0_0.25_sorted_Tellseq.bam O=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/bwa/T_anthrisci_820m_48_1_10.0_0.25_sorted_markdups_Tellseq.bam M=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/bwa/marked_dup_metrics.txt
#java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar MarkDuplicates I=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/bwa/T_anthrisci_820m_48_1_10.0_0.25_sorted_Tellseq_trimmed.bam O=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/bwa/T_anthrisci_820m_48_1_10.0_0.25_sorted_markdups_Tellseq_trimmed.bam M=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/bwa/marked_dup_metrics.txt
#java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar MarkDuplicates I=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/890m/24/0/5.0/0.75/bwa/T_anthrisci_890m_24_0_5.0_0.75_sorted_HiC.bam O=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/890m/24/0/5.0/0.75/bwa/T_anthrisci_890m_24_0_5.0_0.75_sorted_markdups_HiC.bam M=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/890m/24/0/5.0/0.75/bwa/marked_dup_metrics.txt
#java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar MarkDuplicates I=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/890m/24/0/5.0/0.75/bwa/T_anthrisci_890m_24_0_5.0_0.75_sorted_Tellseq_trimmed.bam O=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/890m/24/0/5.0/0.75/bwa/T_anthrisci_890m_24_0_5.0_0.75_sorted_markdups_Tellseq_trimmed.bam M=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/890m/24/0/5.0/0.75/bwa/marked_dup_metrics.txt
#java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar MarkDuplicates I=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/bwa/T_apicales_880m_29_3_3.0_0.75_sorted_HiC.bam O=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/bwa/T_apicales_880m_29_3_3.0_0.75_sorted_markdups_HiC.bam M=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/bwa/marked_dup_metrics.txt
#java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar MarkDuplicates I=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/bwa/T_apicales_880m_29_3_3.0_0.75_sorted_Tellseq.bam O=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/bwa/T_apicales_880m_29_3_3.0_0.75_sorted_markdups_Tellseq.bam M=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/bwa/marked_dup_metrics.txt
#java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar MarkDuplicates I=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/bwa/T_apicales_880m_29_3_3.0_0.75_sorted_Tellseq_trimmed.bam O=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/bwa/T_apicales_880m_29_3_3.0_0.75_sorted_markdups_Tellseq_trimmed.bam M=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/bwa/marked_dup_metrics.txt
#java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar MarkDuplicates I=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/38/0/5.0/0.75/bwa/T_apicales_880m_38_0_5.0_0.75_sorted_HiC.bam O=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/38/0/5.0/0.75/bwa/T_apicales_880m_38_0_5.0_0.75_sorted_markdups_HiC.bam M=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/38/0/5.0/0.75/bwa/marked_dup_metrics.txt
#java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar MarkDuplicates I=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/38/0/5.0/0.75/bwa/T_apicales_880m_38_0_5.0_0.75_sorted_Tellseq_trimmed.bam O=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/38/0/5.0/0.75/bwa/T_apicales_880m_38_0_5.0_0.75_sorted_markdups_Tellseq_trimmed.bam M=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/38/0/5.0/0.75/bwa/marked_dup_metrics.txt
#java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar MarkDuplicates I=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/bwa/T_urticae_715m_12_2_3.0_0.5_sorted_HiC.bam O=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/bwa/T_urticae_715m_12_2_3.0_0.5_sorted_markdups_HiC.bam M=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/bwa/marked_dup_metrics.txt
#java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar MarkDuplicates I=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/bwa/T_urticae_715m_12_2_3.0_0.5_sorted_Tellseq.bam O=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/bwa/T_urticae_715m_12_2_3.0_0.5_sorted_markdups_Tellseq.bam M=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/bwa/marked_dup_metrics.txt
#java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar MarkDuplicates I=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/bwa/T_urticae_715m_12_2_3.0_0.5_sorted_Tellseq_trimmed.bam O=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/bwa/T_urticae_715m_12_2_3.0_0.5_sorted_markdups_Tellseq_trimmed.bam M=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/bwa/marked_dup_metrics.txt
#java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar MarkDuplicates I=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/32/2/3.0/0.75/bwa/T_urticae_715m_32_2_3.0_0.75_sorted_HiC.bam O=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/32/2/3.0/0.75/bwa/T_urticae_715m_32_2_3.0_0.75_sorted_markdups_HiC.bam M=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/32/2/3.0/0.75/bwa/marked_dup_metrics.txt
#java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar MarkDuplicates I=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/32/2/3.0/0.75/bwa/T_urticae_715m_32_2_3.0_0.75_sorted_Tellseq_trimmed.bam O=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/32/2/3.0/0.75/bwa/T_urticae_715m_32_2_3.0_0.75_sorted_markdups_Tellseq_trimmed.bam M=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/32/2/3.0/0.75/bwa/marked_dup_metrics.txt

#java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar MarkDuplicates I=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/minimap2/T_anthrisci_820m_48_1_10.0_0.25_sorted_HiFi.bam O=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/minimap2/T_anthrisci_820m_48_1_10.0_0.25_sorted_markdups_HiFi.bam M=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/minimap2/marked_dup_metrics.txt
#java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar MarkDuplicates I=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/890m/24/0/5.0/0.75/minimap2/T_anthrisci_890m_24_0_5.0_0.75_sorted_HiFi.bam O=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/890m/24/0/5.0/0.75/minimap2/T_anthrisci_890m_24_0_5.0_0.75_sorted_markdups_HiFi.bam M=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/890m/24/0/5.0/0.75/minimap2/marked_dup_metrics.txt
#java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar MarkDuplicates I=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/minimap2/T_apicales_880m_29_3_3.0_0.75_sorted_HiFi.bam O=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/minimap2/T_apicales_880m_29_3_3.0_0.75_sorted_markdups_HiFi.bam M=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/minimap2/marked_dup_metrics.txt
#java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar MarkDuplicates I=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/38/0/5.0/0.75/minimap2/T_apicales_880m_38_0_5.0_0.75_sorted_HiFi.bam O=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/38/0/5.0/0.75/minimap2/T_apicales_880m_38_0_5.0_0.75_sorted_markdups_HiFi.bam M=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/38/0/5.0/0.75/minimap2/marked_dup_metrics.txt
#java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar MarkDuplicates I=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/minimap2/T_urticae_715m_12_2_3.0_0.5_sorted_HiFi.bam O=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/minimap2/T_urticae_715m_12_2_3.0_0.5_sorted_markdups_HiFi.bam M=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/minimap2/marked_dup_metrics.txt
#java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar MarkDuplicates I=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/32/2/3.0/0.75/minimap2/T_urticae_715m_32_2_3.0_0.75_sorted_HiFi.bam O=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/32/2/3.0/0.75/minimap2/T_urticae_715m_32_2_3.0_0.75_sorted_markdups_HiFi.bam M=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/32/2/3.0/0.75/minimap2/marked_dup_metrics.txt

#java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar MarkDuplicates I=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/break10x/bwa/T_urticae_715m_12_2_3.0_0.5_break_sorted_Tellseq_trimmed.bam O=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/break10x/bwa/T_urticae_715m_12_2_3.0_0.5_break_sorted_markdups_Tellseq_trimmed.bam M=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/break10x/bwa/marked_dup_metrics.txt
#java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar MarkDuplicates I=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/break10x/bwa/T_apicales_880m_29_3_3.0_0.75_break_sorted_Tellseq_trimmed.bam O=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/break10x/bwa/T_apicales_880m_29_3_3.0_0.75_break_sorted_markdups_Tellseq_trimmed.bam M=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/break10x/bwa/marked_dup_metrics.txt
#java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar MarkDuplicates I=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/break10x/bwa/T_anthrisci_820m_48_1_10.0_0.25_break_sorted_Tellseq_trimmed.bam O=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/break10x/bwa/T_anthrisci_820m_48_1_10.0_0.25_break_sorted_markdups_Tellseq_trimmed.bam M=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/break10x/bwa/marked_dup_metrics.txt