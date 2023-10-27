#!/bin/bash
#SBATCH --job-name=blobtoolkit
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 35G
#SBATCH --nodes=1
#SBATCH -c 16
#SBATCH -p jic-medium,nbi-medium
#SBATCH --time=02-00:00:00

CurPath=$PWD
Assembly=$1
record_type=$2
MappingFile=$3
BlastFile=$4
BUSCOFile=$5
BUSCOdiamond=$6
Elsediamond=$7
Tiara=$8
OutDir=$9
OutFile=${10}
Genus=${11}
Species=${12}
taxid=${13}
alias=${14}

WorkDir=$OutDir

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo Assembly:
echo $Assembly
echo Mapping File:
echo $MappingFile
echo Blast File:
echo $BlastFile
echo BUSCO File:
echo $BUSCOFile
echo BUSCOdiamond:
echo $BUSCOdiamond
echo Elsediamond:
echo $Elsediamond
echo Tiara:
echo $Tiara
echo Genus:
echo $Genus
echo Species:
echo $Species
echo Alias:
echo $alias
echo TaxID:
echo $taxid
echo Record Type:
echo $record_type
echo _
echo _

mkdir -p $WorkDir

cd $WorkDir
source package 638df626-d658-40aa-80e5-14a275b7464b
source package 87d39a72-88e7-42d5-a925-bfe8c86e7b20

samtools sort -@ 16 -o Input-sorted.bam $MappingFile
samtools index -@ 16 Input-sorted.bam
samtools index -c -@ 16 Input-sorted.bam

echo assembly: > ${alias}.yaml
echo ' ' alias: $alias >> ${alias}.yaml
echo ' ' record_type: $record_type >> ${alias}.yaml
echo taxon: >> ${alias}.yaml
echo ' ' name: $Genus $Species >> ${alias}.yaml
echo ' ' taxis: $taxid >> ${alias}.yaml

blobtools create \
    --fasta $Assembly \
    --meta ${alias}.yaml \
    ./${alias}_blobdir

#Add coverage
blobtools add \
    --cov Input-sorted.bam \
    --threads 16 \
    ./${alias}_blobdir

#Add blast hits
blobtools add \
    --hits $BlastFile \
    --threads 16 \
    --taxrule bestsumorder \
    --taxdump /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/databases/blobtools/26092023/taxdump \
    ./${alias}_blobdir

#Add diamond hits
#With --taxrule bestsumorder, which assigns taxonomy based on the sum of bitscores for the hits to a given taxon based on the first file, only using subsequent results files for contigs with no hits a previous file.
blobtools add \
    --hits $BUSCOdiamond \
    --hits $Elsediamond \
    --threads 16 \
    --taxrule bestsumorder_blastx \
    --taxdump /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/databases/blobtools/26092023/taxdump2 \
    ./${alias}_blobdir

#Add BUSCO scores
blobtools add \
    --busco $BUSCOFile \
    --threads 16 \
    ./${alias}_blobdir

#Add tiara
blobtools add \
    --text ${Tiara}=tiara \
    --text-delimiter "\t" \
    --text-cols "sequence_id=identifiers,class_fst_stage=tiara" \
    --text-header \
    --key plot.cat=tiara \
    ./${alias}_blobdir


echo Collecting outputs:
ls -lh

rm Input-sorted*
nano "BTK complete" > check.txt
