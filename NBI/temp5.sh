#!/bin/bash
#SBATCH --job-name=bash
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 500G
#SBATCH -c 1
#SBATCH -p jic-long
#SBATCH --time=07-00:00:00

singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/bsseq1.38.0.sif R --save <<EOF 

#Convert from bsmap format to bsseq input format. 

library(bsseq)

read.bsmap <- function(file) {
    dat <- read.table(
        file,
        skip = 1,
        row.names = NULL,
        col.names = c("chr", "pos", "strand", "context", "ratio", "eff_CT_count", "C_count", "CT_count", "rev_G_count", "rev_GA_count", "CI_lower", "CI_upper"),
        colClasses = c("character", "integer", "character", "character", "numeric", "numeric", "integer", "integer", "integer", "integer", "numeric", "numeric"))
    #remove all non-CpG calls.  This includes SNPs
    dat <- dat[dat$context == "CG", ]
    dat$context <- NULL
    dat$chr <- paste("chr", dat$chr, sep = "")
    #join separate lines for each strand
    print(dim(dat))
	print(str(dat))
    tmp <- dat[dat$strand == "+", ]
    BS.forward <- BSseq(
        pos = tmp$pos,
        chr = tmp$chr,
        M = as.matrix(tmp$C_count, ncol = 1),
        Cov = as.matrix(tmp$CT_count, ncol = 1),
        sampleNames = "forward")
    tmp <- dat[dat$strand == "-", ]
    BS.reverse <- BSseq(
        pos = tmp$pos - 1L,
        chr = tmp$chr,
        M = as.matrix(tmp$C_count, ncol = 1),
        Cov = as.matrix(tmp$CT_count, ncol = 1),
        sampleNames = "reverse")
    BS <- combine(BS.forward, BS.reverse)
    BS <- collapseBSseq(BS, group = c("a", "a"), type = "integer")
    BS
}

# List all the files
file_paths <- list.files("/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/", pattern = "bsmap_ratios_filtered.txt", recursive = TRUE, full.names = TRUE)

# Loop through each file and combine
bs_objects <- list()

for (file_path in file_paths) {
  sample_name <- sub("_bsmap_ratios_filtered", "", tools::file_path_sans_ext(basename(file_path)))
  assign(paste0("BS.", sample_name), read.bsmap(file_path))
  bs_objects[[sample_name]] <- get(paste0("BS.", sample_name))
  sampleNames(bs_objects[[sample_name]]) <- sample_name
}

BS.hostswap <- do.call(combine, bs_objects)

#Add replicate information
pData(BS.hostswap)$Rep <- c("replicate1", "replicate2", "replicate1", "replicate2", "replicate3", "replicate1", "replicate2", "replicate3", "replicate1", "replicate2", "replicate3", "replicate1", "replicate2", "replicate3", "replicate1", "replicate1", "replicate2", "replicate3", "replicate1", "replicate2", "replicate3", "replicate1", "replicate2", "replicate3", "replicate1", "replicate2", "replicate3", "replicate1", "replicate2", "replicate3", "replicate1", "replicate2", "replicate3", "replicate1", "replicate2", "replicate3", "replicate1", "replicate2", "replicate3", "replicate1", "replicate2", "replicate3", "replicate1", "replicate2")
validObject(BS.hostswap)
pData(BS.hostswap)

#Save to file
save(BS.hostswap, file = "BS.hostswap.rda")
tools::resaveRdaFiles("BS.hostswap.rda")

EOF
#temp=$(dirname $1)/0_$(basename $1)
#awk '!/^chr/ && $5 == 0.000' $1 > $temp
#LC_COLLATE=C sort -k1,1 -k2,2n $temp > $(dirname $temp)/$(basename $temp | sed 's@.txt@_sorted.txt@g') 

#awk '!/^chr/ && $6 >= 2' $1 > $(dirname $1)/gooddepth2_$(basename $1)
#LC_COLLATE=C sort -k1,1 -k2,2n $1 > $(dirname $1)/$(basename $1 | sed 's@.txt@_sorted.txt@g')

#head -n 1 $1 > $(dirname $1)/$(basename $1 | sed 's@.txt@2.txt@g')
#grep -F -w -f common_ids_000.txt $1 >> $(dirname $1)/$(basename $1 | sed 's@.txt@_filtered.txt@g')
#grep -v -F -w -f common_ids0.txt $1 >> $(dirname $1)/$(basename $1 | sed 's@.txt@2.txt@g') 

#singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/genmap1.3.0.sif genmap index -F genome.fa -I index -v
#singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/genmap1.3.0.sif genmap map -T 16 -K 30 -E 2 -I index -O . -t -w -bg -v

#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae
#cat ~/git_repos/Scripts/NBI/filter_bsmap_4.py
#echo __
#echo __
#singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 ~/git_repos/Scripts/NBI/filter_bsmap_4.py temp_file_list.txt



#mkdir /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Myzus_persicae/O_v2/GenomeDir
#source package 266730e5-6b24-4438-aecb-ab95f1940339
#STAR --runMode genomeGenerate --runThreadN 32 \
#--genomeDir /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Myzus_persicae/O_v2/GenomeDir \
#--genomeFastaFiles /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Myzus_persicae/O_v2/Myzus_persicae_O_v2.0.scaffolds.fa \
#--sjdbGTFfile /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Myzus_persicae/O_v2/MYZPE13164_O_EIv2.1.annotation.gff3.gtf --sjdbOverhang 150

#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/raw_data/Myzus/persicae/WGBS
#zip -r Archana_Mar2021.zip Archana_Mar2021

#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/dna_qc/Myzus/persicae

#unzip singh.zip
#unzip wouters.zip

#  ProjDir=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae
#  cd $ProjDir
#  IsolateAbrv=30_aphid
#  WorkDir=analysis/orthology/orthofinder/$IsolateAbrv
#  mkdir -p $WorkDir
#  mkdir -p $WorkDir/formatted
#  mkdir -p $WorkDir/goodProteins
#  mkdir -p $WorkDir/badProteins  

#source package /nbi/software/production/bin/porthomcl-40f497e

#Taxon_code=ACYpis
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Acyrthosiphon_pisum/JIC1_v1/Acyrthosiphon_pisum_JIC1_v1.0.scaffolds.braker2.gff.filtered.aa.fa)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=APHfab
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Aphis_fabae/JIC1_v2/Aphis_fabae_JIC1_v2.scaffolds.braker.filtered.aa.fa)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=APHgly
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Aphis_glycines/biotype_4_v3/Aphis_glycines_4.v3.scaffolds.braker.aa.fa)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=APHgos
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Aphis_gossypii/JIC1_v1/Aphis_gossypii_JIC1_v1.scaffolds.braker.aa.fa)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=APHrum
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Aphis_rumicis/v1/Aphis_rumicis_v1.scaffolds.braker_gthr.aa.fa)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=APHtha
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Aphis_thalictri/v1/Aphis_thalictri_v1.scaffolds.braker.aa.fa)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=BRAcar
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Brachycaudus_cardui/v1.1/Brachycaudus_cardui_v1.1.scaffolds.braker.filtered.aa.fa)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=BRAhel
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Brachycaudus_helichrysi/v1.1/Brachycaudus_helichrysi_v1.1.scaffolds.braker.filtered.aa.fa)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=BRAklu
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Brachycaudus_klugkisti/v1.1/Brachycaudus_klugkisti_v1.1.scaffolds.braker.filtered.aa.fa)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=BREbra
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Brevicoryne_brassicae/v2/Brevicoryne_brassicae_v2.scaffolds.braker.filtered.aa.fa)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=CINced
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Cinara_cedri/v1/cinced3A.pep.fa)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=DAKvit
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Daktulosphaira_vitifoliae/INRAPcf7_v5/Daktulosphaira_vitifoliae_INRAPcf7_v5.scaffolds.braker.aa.fa)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=DIUnox
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Diuraphis_noxia/SAM_v1.1/Diuraphis_noxia_SAM.v1.1.scaffolds.braker.aa.fa)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=DREpla
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Drepanosiphum_platanoidis/)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=ERIlan
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Eriosoma_lanigerum/v1/Eriosoma_lanigerum_v1.0.scaffolds.braker.aa.fa)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=HORcor
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Hormaphis_cornu/v1/Augustus.updated_w_annots.21Aug20.gff3.aa.fa)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=MACalb
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Macrosiphum_albifrons/v1/Macrosiphum_albifrons_v1.scaffolds.braker.aa.fa)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=METdir
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Metopolophium_dirhodum/JIC1_v1.1/Metopolophium_dirhodum_UK035_v1.1.scaffolds.braker.aa.fa)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=MYZcer
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Myzus_cerasi/Thorpe_v1.2/Myzus_cerasi_v1.2.scaffolds.braker.filtered.aa.fa)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=MYZlig
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Myzus_ligustri/v1.1/Myzus_ligustri_v1.1.scaffolds.braker.filtered.aa.fa)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=MYZlyt
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Myzus_lythri/v1.1/Myzus_lythri_v1.1.scaffolds.braker.filtered.aa.fa)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=MYZper
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Myzus_persicae/O_v2/MYZPE13164_O_EIv2.1.annotation.gff3.aa.fa)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=MYZvar
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Myzus_varians/v1.1/Myzus_varians_v1.1.scaffolds.braker.filtered.aa.fa)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=PEMphi
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Pemphigus_spyrothecae/)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=PENnig
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Pentalonia_nigronervosa/v1/Pentalonia_nigronervosa.v1.scaffolds.braker.filtered.aa.fa)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=PHOcan
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Phorodon_cannabis/v1/Phorodon_cannabis_v1.scaffolds.braker.aa.fa)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=PHOhum
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Phorodon_humuli/v2/Phorodon_humuli_v2_scaffolds.braker.filtered.aa.fa)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=RHOmai
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Rhopalosiphum_maidis/v1/rmaidis_v2.gff3.prot.fa)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=RHOpad
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Rhopalosiphum_padi/JIC1_v1/Rhopalosiphum_padi_JIC1_v1.scaffolds.braker.aa.fa)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=SCHchi
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Schlechtendalia_chinensis/v1/proteins.fasta)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=SITave
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Sitobion_avenae/JIC1_v2.1/Sitobion_avenae_JIC1_v2.1.scaffolds.braker.aa.fa)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=SITfra
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Sitobion_fragariae/v1/Sitobion_fragariae_v1.scaffolds.braker.aa.fa)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta

#Taxon_code=SITmis
#Fasta_file=$(ls /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Sitobion_miscanthi/v2/Sitobion_miscanthi_v2.scaffolds.braker.aa.fa)
#Id_field=1
#orthomclAdjustFasta  $Taxon_code $Fasta_file $Id_field
#mv "$Taxon_code".fasta $WorkDir/formatted/"$Taxon_code".fasta


#for Dir in $(ls -d analysis/orthology/orthofinder/$IsolateAbrv); do
#Input_dir=$Dir/formatted
#Min_length=10
#Max_percent_stops=20
#Good_proteins_file=$Dir/goodProteins/goodProteins.fasta
#Poor_proteins_file=$Dir/badProteins/poorProteins.fasta
#orthomclFilterFasta $Input_dir $Min_length $Max_percent_stops $Good_proteins_file $Poor_proteins_file
#done

#sbatch ~/git_repos/Wrappers/NBI/run_orthofinder.sh $WorkDir 
#57518180

#OrthogroupsTxt=$WorkDir/formatted/OrthoFinder/*/Orthogroups/Orthogroups.txt
#GoodProts=$WorkDir/goodProteins/goodProteins.fasta
#OutDir=$WorkDir/orthogroups_fasta
#mkdir -p $OutDir
#source package /tgac/software/production/bin/python-2.7.10
#python ~/git_repos/Scripts/NBI/orthoMCLgroups2fasta.py --orthogroups $OrthogroupsTxt --fasta $GoodProts --out_dir $OutDir 2>&1 | tee -a $WorkDir/orthoreport.txt
#
#mkdir ${WorkDir}/orthogroups_fasta/paired
#for fasta in $(find ${WorkDir}/orthogroups_fasta -name "orthogroupOG*.fa" -exec readlink -f {} \;); do
#    codes=">SITmis,>SITfra,>SITave,>SCHchi,>RHOpad,>RHOmai,>PHOhum,>PHOcan,>PENnig,>MYZvar,>MYZlyt,>MYZlig,>MYZcer,>METdir,>MACalb,>HORcor,>ERIlan,>DIUnox,>DAKvit,>CINced,>BREbra,>BRAklu,>BRAhel,>BRAcar,>APHtha,>APHrum,>APHgos,>APHgly,>APHfab,>ACYpis"
#    count=$(grep -E "^($(echo $codes | tr ',' '|'))" "$fasta" | wc -l)
#    if grep -q '^>MYZ' "$fasta" && [ "$count" -ge 10 ]; then
#    OutFile=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/analysis/orthology/orthofinder/persicae_v_ligustri/orthogroups_fasta/paired/$(basename $fasta | sed 's@.fa@_paired.fa@g')
#    singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 ~/git_repos/Scripts/NBI/find_longest_myzlig.py $fasta $OutFile
#    fi
#done

#  ProjDir=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae
#  cd $ProjDir
#  IsolateAbrv=persicae_v_ligustri
#  WorkDir=analysis/orthology/orthofinder/$IsolateAbrv

#  OrthogroupsTxt=$WorkDir/formatted/OrthoFinder/*/Orthogroups/Orthogroups.txt
#GoodProts=$WorkDir/goodProteins/goodProteins.fasta
#OutDir=$WorkDir/orthogroups_fasta
#mkdir -p $OutDir
#source package /tgac/software/production/bin/python-2.7.10
#python ~/git_repos/Scripts/NBI/orthoMCLgroups2fasta.py --orthogroups $OrthogroupsTxt --fasta $GoodProts --out_dir $OutDir

#perl ~/git_repos/Scripts/NBI/bcf2bbgeno.pl -i /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/193s.M_persicae.onlySNPs-genic-regions.vcf.gz -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/193s.M_persicae.onlySNPs-genic-regions.bbgeno -p H-W -s -r
#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/
#gzip 193s.M_persicae.onlySNPs-genic-regions.bbgeno

#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae
#source package 638df626-d658-40aa-80e5-14a275b7464b
#ls /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/dna_qc/Myzus/persicae/WGS/Archana_Feb2021/*/trim_galore/bwa-mem/gatk/*realigned.bam > bamlist.txt
#mkdir -p /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/Archana_Feb2021/gatk/
#bcftools mpileup -b /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/bamlist.txt --annotate AD,DP --fasta-ref /jic/research-groups/Saskia-Hogenhout/TCHeaven/Genomes/Myzus/persicae/O_v2/Myzus_persicae_O_v2.0.scaffolds.fa -O z -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/Archana_Feb2021/gatk/BR_AT_NB_hostswaps.vcf.gz

#bcftools call -Oz -v -m -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/Archana_Feb2021/gatk/BR_AT_NB_hostswap.vcf.gz /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/Archana_Feb2021/gatk/BR_AT_NB_hostswaps.vcf.gz
#bcftools call --ploidy 2 -Oz -v -m -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/Archana_Feb2021/gatk/BR_AT_NB_hostswapexpt.vcf.gz /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/Archana_Feb2021/gatk/BR_AT_NB_hostswaps.vcf.gz

#source package 3e7beb4d-f08b-4d6b-9b6a-f99cc91a38f9
#source package 638df626-d658-40aa-80e5-14a275b7464b
#for file in $(ls /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/dna_qc/Myzus/persicae/WGS/Archana_Feb2021/NB39_E1/trim_galore/bwa-mem/NB39_E1_trimmed_1_sorted.bam /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/dna_qc/Myzus/persicae/WGS/Archana_Feb2021/NB25_E2/trim_galore/bwa-mem/NB25_E2_trimmed_1_sorted.bam /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/dna_qc/Myzus/persicae/WGS/Archana_Feb2021/BR39_E1/trim_galore/bwa-mem/BR39_E1_trimmed_1_sorted.bam); do
#	OutDir=$(dirname $file)
#	OutFile=$(basename $file | sed s'@_sorted.bam@_sorted_MarkDups.bam@g')
#	metrics=$(basename $file | sed s'@_trimmed_1_sorted.bam@@g')_marked_dup_metrics.txt
#	java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar SortSam I=${file} O=${OutDir}/temp.bam SORT_ORDER=coordinate
#	java17 -jar /tgac/software/testing/bin/core/../..//picardtools/2.1.1/x86_64/bin/picard.jar MarkDuplicates REMOVE_DUPLICATES=true I=${OutDir}/temp.bam O=${OutDir}/${OutFile} M=${OutDir}/${metrics}
#	cd ${OutDir}
#	rm temp.bam
#	samtools index ${OutFile}
#	cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae
#done

#source package 638df626-d658-40aa-80e5-14a275b7464b
#source package /tgac/software/testing/bin/preseq-3.1.2
#source package /tgac/software/testing/bin/pairtools-0.3.0
#source bwa-0.7.17

#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/tmp_57437956

#samtools sort -@$cpu --write-index -l9 -o bam5.bam bam2.bam

#echo "Filtering BAM files..."
#samtools view -@32 -h bam5.bam | ~/git_repos/Scripts/NBI/filter_five_end.pl | samtools sort -@32 - > bam5_filtered.bam
#ls ${OutFile}_filtered.bam
#samtools markdup --write-index bam5_filtered.bam bam5_mapped.bam
#ls -lh

#samtools markdup --write-index T_apicales_880m_29_3_3.0_0.75_break_TellSeqPurged_pilon_scaff10xscaffolds_scaffolds_final_4.bam bam6_mapped.bam


#cd /jic/research-groups/Saskia-Hogenhout/reads/genomic/CALIBER_popgen_Nov_2023/Batch1-231123

#tar -zcvf X204SC23101516-Z01-F001.tar.gz X204SC23101516-Z01-F001/

#source package /nbi/software/testing/bin/plink-1.9 
#plink --vcf /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/plink2/193s.M_persicae.onlySNPs-mac1.recode.mod.vcf.gz --make-bed --out /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/plink2/193s.M_persicae.onlySNPs-mac1.recode.mod
#plink --genome /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/plink2/193s.M_persicae.onlySNPs-mac1.recode.mod --out output_results

#source package 01ef5a53-c149-4c9e-b07d-0b9a46176cc0
#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/plink2/
#bgzip /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/plink2/193s.M_persicae.onlySNPs-mac1.recode.mod.vcf

#mkdir /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/plink2
#zcat /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/193s.M_persicae.onlySNPs-mac1.recode.mod.vcf.gz | head -n 5 > /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/plink2/193s.M_persicae.onlySNPs-mac1.recode.mod.vcf
#zcat /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/193s.M_persicae.onlySNPs-mac1.recode.mod.vcf.gz | grep -w '##ALT\|##INFO\|##FORMAT\|#CHROM\|##bcftools_callVersion\|##bcftools_callCommand\|##bcftools_concatVersion\|##bcftools_concatCommand\|##bcftools_filterVersion\|##bcftools_filterCommand\|##bcftools_viewVersion\|##bcftools_viewCommand\|scaffold_1\|scaffold_2\|scaffold_3\|scaffold_4\|scaffold_5\|scaffold_6' | sed 's@scaffold_@chr@g' >> /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/plink2/193s.M_persicae.onlySNPs-mac1.recode.mod.vcf

#bgzip -c /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/193s.M_persicae.onlySNPs-mac1.recode.vcf > /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/193s.M_persicae.onlySNPs-mac1.recode.vcf.gz

#zcat /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/193s.M_persicae.onlySNPs-mac1.recode.vcf.gz | awk 'BEGIN{OFS="\t"} {if ($3 == ".") $3 = $1"_"$2"_"$5; print}' | bgzip -c > /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/193s.M_persicae.onlySNPs-mac1.recode.mod.vcf.gz

#zcat /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/193s.M_persicae.onlySNPs-mac1.recode.mod.vcf.gz | sed 's/scaffold_//g' | bgzip -c > /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/193s.M_persicae.onlySNPs-mac1.recode.temp.mod.vcf.gz && mv /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/193s.M_persicae.onlySNPs-mac1.recode.temp.mod.vcf.gz /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/snp_calling/Myzus/persicae/biello/gatk/filtered/193s.M_persicae.onlySNPs-mac1.recode.mod.vcf.gz

#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/minimap2
#source package 638df626-d658-40aa-80e5-14a275b7464b
#source /nbi/software/staging/RCSUPPORT-2652/stagingloader
#source package 222eac79-310f-4d4b-8e1c-0cece4150333
#source package /tgac/software/production/bin/abyss-1.3.5

#minimap2 -t 4 -ax map-hifi /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/T_urticae_715m_12_2_3.0_0.5.bp.p_ctg.fa /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_urticae/HiFi/urticae_hifi-3rdSMRTcell.fastq.gz /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_urticae/HiFi/urticae_hifi-reads.fastq.gz --secondary=no \
#    | samtools sort -m 1G -o /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/minimap2/T_urticae_715m_12_2_3.0_0.5_aligned.bam -T tmp.ali

#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/minimap2/
#samtools faidx T_urticae_715m_12_2_3.0_0.5_aligned.bam

#cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/filtered/purge_dups/
#samtools faidx T_urticae_715m_12_2_3.0_0.5_filtered_HiFiPurged.fa

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

