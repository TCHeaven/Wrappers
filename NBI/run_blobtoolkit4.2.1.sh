#!/bin/bash
#SBATCH --job-name=blobtoolkit
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 20G
#SBATCH --nodes=1
#SBATCH -c 8
#SBATCH -p nbi-medium,jic-medium,nbi-long,jic-long
#SBATCH --time=02-00:00:00

CurPath=$PWD
Assembly=$1
record_type=$2
MappingFile=$3
BlastFile=$4
BUSCOFile=$5
OutDir=$6
OutFile=$7
Genus=$8
Species=$9
taxid=${10}
alias=${11}

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
source /nbi/software/staging/RCSUPPORT-2444/stagingloader

samtools sort -@ 8 -o Input-sorted.bam $MappingFile
samtools index -@ 8 Input-sorted.bam
samtools index -c -@ 8 Input-sorted.bam

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
    --threads 8 \
    ./${alias}_blobdir

#Add blast hits
blobtools add \
    --hits $BlastFile \
    --threads 8 \
    --taxrule bestsumorder \
    --taxdump /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/databases/blobtools/26092023/taxdump \
    ./${alias}_blobdir

#Add BUSCO hits
blobtools add \
    --busco $BUSCOFile \
    --threads 8 \
    ./${alias}_blobdir

echo Collecting outputs:
ls -lh

rm Input-sorted*