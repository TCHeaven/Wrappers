#!/bin/bash
#SBATCH --job-name=bash
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 1G
#SBATCH -c 1
#SBATCH -p jic-long,nbi-long
#SBATCH --time=30-00:00:00

Assembly=$(echo $1 | sed 's@##@@g')
Species=$(echo $Assembly | cut -d '/' -f10)
Genus=Trioza
species=$(echo $Species | cut -d '_' -f2)
if [ "$species" = "apicales" ]; then
    TaxID=872318
elif [ "$species" = "anthrisci" ]; then
    TaxID=2023874
elif [ "$species" = "urticae" ]; then
    TaxID=121826
else
    echo "Unknown species"
fi
alias=$(basename $Assembly | cut -d '_' -f1,2 | sed 's@_@@g' | cut -c1-4)$(basename $Assembly |  sed 's@.bp.p_ctg.fa@@g' | cut -d '_' -f3,4,5,6,7 | sed 's@.@@g' | sed 's@_@@g')
if [ "$species" = "apicales" ]; then
Read1=/jic/research-groups/Saskia-Hogenhout/reads/genomic/CALIBER_PB_HIFI_July_2022/TrAp2_hifi_reads.fastq.gz
Read2=/jic/research-groups/Saskia-Hogenhout/reads/genomic/CALIBER_PB_HIFI_July_2022/third_flow_cell/TrAp2_hifi_3rdSMRTcell.fastq.gz
F1=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_apicales/TellSeq/apicales_T505_R1.fastq.gz
R1=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_apicales/TellSeq/apicales_T505_R2.fastq.gz
F2=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_apicales/TellSeq/apicales_T507_R1.fastq.gz
R2=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_apicales/TellSeq/apicales_T507_R2.fastq.gz
CRead1=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_apicales/HiC/apicales_286172-S3HiC_R1.fastq.gz
CRead2=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_apicales/HiC/apicales_286172-S3HiC_R2.fastq.gz
T1=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/dna_qc/T_apicales/TellSeq/longranger/Trapi_T505_barcoded.fastq.gz
T2=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/dna_qc/T_apicales/TellSeq/longranger/Trapi_T507_barcoded.fastq.gz
elif [ "$species" = "anthrisci" ]; then
Read1=/jic/research-groups/Saskia-Hogenhout/reads/genomic/CALIBER_PB_HIFI_July_2022/TrAn22_hifi_reads.fastq.gz
Read2=/jic/research-groups/Saskia-Hogenhout/reads/genomic/CALIBER_PB_HIFI_July_2022/third_flow_cell/TrAn22_hifi_3rdSMRTcell.fastq.gz
F1=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_anthrisci/TellSeq/anthrisci_T508_R1.fastq.gz
R1=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_anthrisci/TellSeq/anthrisci_T508_R2.fastq.gz
CRead1=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_anthrisci/HiC/anthrisci_286154-S3HiC_R1.fastq.gz
CRead2=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_anthrisci/HiC/anthrisci_286154-S3HiC_R2.fastq.gz
T1=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/dna_qc/T_anthrisci/TellSeq/longranger/Tant_T508_barcoded.fastq.gz
elif [ "$species" = "urticae" ]; then
Read1=/jic/research-groups/Saskia-Hogenhout/reads/genomic/CALIBER_PB_HIFI_July_2022/TUF20_hifi_reads.fastq.gz
Read2=/jic/research-groups/Saskia-Hogenhout/reads/genomic/CALIBER_PB_HIFI_July_2022/third_flow_cell/TUF20_hifi_3rdSMRTcell.fastq.gz
F1=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_urticae/TellSeq/urticae_T502_R1.fastq.gz
R1=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_urticae/TellSeq/urticae_T502_R2.fastq.gz
F2=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_urticae/TellSeq/urticae_T504_R1.fastq.gz
R2=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_urticae/TellSeq/urticae_T504_R2.fastq.gz
CRead1=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_urticae/HiC/urticae_286170-S3HiC_R1.fastq.gz
CRead2=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_urticae/HiC/urticae_286170-S3HiC_R2.fastq.gz
T1=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/dna_qc/T_urticae/TellSeq/longranger/Turt_T502_barcoded.fastq.gz
T2=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/dna_qc/T_urticae/TellSeq/longranger/Turt_T504_barcoded.fastq.gz
else
    echo "Unknown species"
fi

source /nbi/software/staging/RCSUPPORT-2452/stagingloader

#alignment of reads to unfiltered assembly
if [ ! -e $(dirname $Assembly)/minimap2/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').bam ]; then
ProgDir=~/git_repos/Wrappers/NBI
OutDir=$(dirname $Assembly)/minimap2
Outfile=$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g')
mkdir $OutDir
sbatch $ProgDir/run_minimap2-hifi.sh $OutDir $Outfile $Assembly $Read1 $Read2 #56939444
else 
echo HiFi alignment already run
fi

if [ ! -e $(dirname $Assembly)/bwa/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g')_HiC.bam ]; then
ProgDir=~/git_repos/Wrappers/NBI
OutDir=$(dirname $Assembly)/bwa
Outfile=$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g')_HiC
mkdir $OutDir
sbatch $ProgDir/bwa-mem.sh $OutDir $Outfile $Assembly $CRead1 $CRead2 
else 
echo HiC alignment already run
fi

if [ ! -e $(dirname $Assembly)/bwa/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g')_Tellseq_trimmed.bam ]; then
ProgDir=~/git_repos/Wrappers/NBI
OutDir=$(dirname $Assembly)/bwa
Outfile=$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g')_Tellseq_trimmed
mkdir $OutDir
sbatch $ProgDir/bwa-mem_unpaired.sh $OutDir $Outfile $Assembly $T1 $T2 $T3 $T4
else 
echo TellSeq alignment already run
fi

#### Blobtools
#Blobtools with Hifi reads

#Blobtoolkit
Record_type=contig
MappingFile=$(dirname $Assembly)/minimap2/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').bam
BlastFile=$(dirname $Assembly)/blast2.12.0/3/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').vs.nt.mts1.hsp1.1e25.megablast.out
BUSCOFile=$(dirname $Assembly)/BUSCO/hemiptera_odb10/run_hemiptera_odb10/full_table.tsv
BUSCODiamond=$(ls $(dirname $Assembly)/diamond0.9.29_blastx/BUSCO_regions/*.diamondblastx.out)
ElseDiamond=$(ls $(dirname $Assembly)/diamond0.9.29_blastx/nonBUSCO_regions/*.diamondblastx.out)
Tiara=$(ls $(dirname $Assembly)/tiara/${Species}*.tiara)
OutDir=$(dirname $Assembly)/blobtoolkit4.2.1
OutPrefix=$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g')
ProgDir=~/git_repos/Wrappers/NBI
mkdir $OutDir
echo "Waiting for btk inputs"
while [ ! -e "$BUSCODiamond" ] || [ ! -e "$ElseDiamond" ] || [ ! -e "$MappingFile" ] || [ ! -e "$BlastFile" ] || [ ! -e "$BUSCOFile" ] || [ ! -e "$Tiara" ]; do
    echo .
    sleep 900
done
echo "Running BTK for $Assembly"
sbatch $ProgDir/run_blobtoolkit4.2.1.sh $Assembly $Record_type $MappingFile $BlastFile $BUSCOFile $BUSCODiamond $ElseDiamond $Tiara $OutDir $OutPrefix $Genus $species $TaxID $alias
while [ ! -e "${OutDir}/check.txt" ]; do
    echo .
    sleep 900
done
echo "BTK complete for $Assembly"
cp -r $OutDir/${alias}_blobdir /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/databases/blobtools/BlobDirs/.
rm ${OutDir}/check.txt

#Blobtools with HiC reads
#alignment of reads to unfiltered assembly

#Blobtoolkit
Record_type=contig
MappingFile=$(dirname $Assembly)/bwa/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g')_HiC.bam
BlastFile=$(dirname $Assembly)/blast2.12.0/3/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').vs.nt.mts1.hsp1.1e25.megablast.out
BUSCOFile=$(dirname $Assembly)/BUSCO/hemiptera_odb10/run_hemiptera_odb10/full_table.tsv
BUSCODiamond=$(ls $(dirname $Assembly)/diamond0.9.29_blastx/BUSCO_regions/*.diamondblastx.out)
ElseDiamond=$(ls $(dirname $Assembly)/diamond0.9.29_blastx/nonBUSCO_regions/*.diamondblastx.out)
Tiara=$(ls $(dirname $Assembly)/tiara/${Species}*.tiara)
OutDir=$(dirname $Assembly)/blobtoolkit4.2.1
OutPrefix=$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g')
Alias=${echo $alias}_HiC
ProgDir=~/git_repos/Wrappers/NBI
mkdir $OutDir
echo "Waiting for btk inputs"
while [ ! -e "$BUSCODiamond" ] || [ ! -e "$ElseDiamond" ] || [ ! -e "$MappingFile" ] || [ ! -e "$BlastFile" ] || [ ! -e "$BUSCOFile" ] || [ ! -e "$Tiara" ]; do
    echo .
    sleep 900
done
echo "Running BTK for $Assembly"
sbatch $ProgDir/run_blobtoolkit4.2.1.sh $Assembly $Record_type $MappingFile $BlastFile $BUSCOFile $BUSCODiamond $ElseDiamond $Tiara $OutDir $OutPrefix $Genus $species $TaxID $Alias
while [ ! -e "${OutDir}/check.txt" ]; do
    echo .
    sleep 900
done
echo "BTK complete for $Assembly"
rm ${OutDir}/check.txt
#Blobtools with TellSeq reads

#Blobtoolkit
Record_type=contig
MappingFile=$(dirname $Assembly)/bwa/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g')_Tellseq_trimmed.bam
BlastFile=$(dirname $Assembly)/blast2.12.0/3/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').vs.nt.mts1.hsp1.1e25.megablast.out
BUSCOFile=$(dirname $Assembly)/BUSCO/hemiptera_odb10/run_hemiptera_odb10/full_table.tsv
BUSCODiamond=$(ls $(dirname $Assembly)/diamond0.9.29_blastx/BUSCO_regions/*.diamondblastx.out)
ElseDiamond=$(ls $(dirname $Assembly)/diamond0.9.29_blastx/nonBUSCO_regions/*.diamondblastx.out)
Tiara=$(ls $(dirname $Assembly)/tiara/${Species}*.tiara)
OutDir=$(dirname $Assembly)/blobtoolkit4.2.1
OutPrefix=$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g')
Alias=${echo $alias}_Tellseq_trimmed
ProgDir=~/git_repos/Wrappers/NBI
mkdir $OutDir
echo "Waiting for btk inputs"
while [ ! -e "$BUSCODiamond" ] || [ ! -e "$ElseDiamond" ] || [ ! -e "$MappingFile" ] || [ ! -e "$BlastFile" ] || [ ! -e "$BUSCOFile" ] || [ ! -e "$Tiara" ]; do
    echo .
    sleep 900
done
echo "Running BTK for $Assembly"
sbatch $ProgDir/run_blobtoolkit4.2.1.sh $Assembly $Record_type $MappingFile $BlastFile $BUSCOFile $BUSCODiamond $ElseDiamond $Tiara $OutDir $OutPrefix $Genus $species $TaxID $Alias
while [ ! -e "${OutDir}/check.txt" ]; do
    echo .
    sleep 900
done
echo "BTK complete for $Assembly"
rm ${OutDir}/check.txt

Assembly=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/32/2/3.0/0.75/T_urticae_715m_32_2_3.0_0.75.bp.p_ctg.fa #57358226,57052208,57103222 - 57222610
Assembly=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/38/0/5.0/0.75/T_apicales_880m_38_0_5.0_0.75.bp.p_ctg.fa #57358227,57052209,57103226 - 57222619
Assembly=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/890m/24/0/5.0/0.75/T_anthrisci_890m_24_0_5.0_0.75.bp.p_ctg.fa #57358233,57052212,57103231 - 57222633

OutPrefix=$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g')
OutDir=$(dirname $Assembly)/blast2.12.0/3
Database=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/databases/blast/nt_premade_02102023/nt
ProgDir=~/git_repos/Wrappers/NBI
mkdir $OutDir
sbatch $ProgDir/run_blastn.sh $Assembly $Database $OutDir $OutPrefix 