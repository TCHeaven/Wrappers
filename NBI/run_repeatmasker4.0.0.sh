#!/bin/bash
#SBATCH --job-name=repeatmasker
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 25G
#SBATCH --nodes=1
#SBATCH -c 32
#SBATCH -p jic-medium,jic-long,nbi-medium,nbi-long
#SBATCH --time=30-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

Genome=$1
Species=$2
OutFile=$3
OutDir=$4

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo Genome:
echo $Genome
echo Species:
echo $Species

echo __
echo __

source package 14fbfadb-9fe7-419a-9f20-cd5f458c0fff
source package 85eb6fb0-3eb7-43b2-9659-49e0142481fc

mkdir $OutDir/softmask
mkdir $OutDir/hardmask
mkdir $OutDir/teonly

if [ -n "$Custom_library" ]; then
RepeatMasker $Genome -pa 8 -dir $OutDir/softmask -xsmall -html -gff -xm --species $Species -lib $Custom_library
RepeatMasker $Genome -pa 8 -dir $OutDir/hardmask -html -gff -xm --species $Species -lib $Custom_library
RepeatMasker $Genome -pa 8 -dir $OutDir/teonly -nolow -html -gff -xm --species $Species -lib $Custom_library
else
RepeatMasker $Genome -pa 8 -dir $OutDir/softmask -xsmall -html -gff -xm --species $Species
RepeatMasker $Genome -pa 8 -dir $OutDir/hardmask -html -gff -xm --species $Species
RepeatMasker $Genome -pa 8 -dir $OutDir/teonly -nolow -html -gff -xm --species $Species
fi



Genome=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/break10x/purge_dups/sanger/MitoHifi/filtered/inspector/T_anthrisci_820m_48_1_10.0_0.25_break_TellSeqPurged_curated_nomito_filtered_corrected.fa
OutFile=$(basename $Genome | sed 's@.fa@@g')
OutDir=$(dirname $Genome)/repeatmodeler
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/repeatmasker_4.1.5--pl5321hdfd78af_0 RepeatMasker $Genome -pa 1 -qq -dir temp_out -xsmall -html -gff -xm --species hemiptera -lib 