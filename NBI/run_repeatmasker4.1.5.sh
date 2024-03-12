#!/bin/bash
#SBATCH --job-name=repeatmasker
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 30G
#SBATCH --nodes=1
#SBATCH -c 32
#SBATCH -p jic-long,nbi-long,RG-Saskia-Hogenhout
#SBATCH --time=30-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

Genome=$1
OutFile=$2
OutDir=$3
Species=$4
Custom_library=$5

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
echo Repeat library:
echo $Custom_library

echo __
echo __


mkdir $OutDir/softmask
mkdir $OutDir/hardmask
mkdir $OutDir/teonly

if [ -z "$Custom_library" ] || [ "$Custom_library" = "NA" ]; then
echo running with DFAM3.7
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/repeatmasker4.1.5.sif RepeatMasker $Genome -pa 8 -s -dir $OutDir/softmask -xsmall -html -gff -xm --species $Species
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/repeatmasker4.1.5.sif RepeatMasker $Genome -pa 8 -s -dir $OutDir/hardmask -html -gff -xm --species $Species
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/repeatmasker4.1.5.sif RepeatMasker $Genome -pa 8 -s -dir $OutDir/teonly -nolow -html -gff -xm --species $Species
else
echo running with custom repeat library
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/repeatmasker4.1.5.sif RepeatMasker $Genome -pa 8 -s -dir $OutDir/softmask -xsmall -html -gff -xm -lib $Custom_library
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/repeatmasker4.1.5.sif RepeatMasker $Genome -pa 8 -s -dir $OutDir/hardmask -html -gff -xm -lib $Custom_library
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/repeatmasker4.1.5.sif RepeatMasker $Genome -pa 8 -s -dir $OutDir/teonly -nolow -html -gff -xm -lib $Custom_library
fi

echo DONE