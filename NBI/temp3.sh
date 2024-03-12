#!/bin/bash
#SBATCH --job-name=bash
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 200G
#SBATCH -c 32
#SBATCH -p jic-long,nbi-long
#SBATCH --time=14-00:00:00


#mkdir /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/break10x/purge_dups/sanger/MitoHifi/filtered/inspector/juicer
cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/break10x/purge_dups/sanger/MitoHifi/filtered/inspector/juicer
#mkdir restriction_sites;mkdir references;mkdir fastq
cd fastq
#ln -s /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_anthrisci/HiC/anthrisci_286154-S3HiC_R1.fastq.gz .
#ln -s /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_anthrisci/HiC/anthrisci_286154-S3HiC_R2.fastq.gz .
cd ../references
#ln -s /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/break10x/purge_dups/sanger/MitoHifi/filtered/inspector/T_anthrisci_820m_48_1_10.0_0.25_break_TellSeqPurged_curated_nomito_filtered_corrected.fa .
source bwa-0.7.17
bwa index T_anthrisci_820m_48_1_10.0_0.25_break_TellSeqPurged_curated_nomito_filtered_corrected.fa
cd ../restriction_sites
Enzyme=DpnII
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 ~/git_repos/Scripts/NBI/generate_site_positions.py $Enzyme OutFile ../references/T_anthrisci_820m_48_1_10.0_0.25_break_TellSeqPurged_curated_nomito_filtered_corrected.fa
awk 'BEGIN{OFS="\t"}{print $1, $NF}' OutFile_DpnII.txt > OutFile_DpnII.chrom.sizes
cd ..
mkdir -p scripts/common
cp ~/git_repos/Scripts/NBI/chimeric_blacklist.awk scripts/common/.
source jdk-1.7.0_25; source bwa-0.7.17;source samtools-1.6;source gnu_parallel-20180322
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/juicer.sif juicer.sh -D /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/break10x/purge_dups/sanger/MitoHifi/filtered/inspector/juicer -d /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/break10x/purge_dups/sanger/MitoHifi/filtered/inspector/juicer -g OutFile -z references/T_anthrisci_820m_48_1_10.0_0.25_break_TellSeqPurged_curated_nomito_filtered_corrected.fa -y restriction_sites/OutFile_DpnII.txt -s DpnII -t 32 -p restriction_sites/OutFile_DpnII.chrom.sizes 

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