#!/bin/bash
#SBATCH --job-name=repeatmasker
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 100G
#SBATCH --nodes=1
#SBATCH -c 32
#SBATCH -p jic-medium,jic-long,nbi-medium,nbi-long,RG-Saskia-Hogenhout
#SBATCH --time=02-00:00:00

# This script uses repeatmodeler and repeatmasker to mask Interspersed repeats
# and low complexity regions within the genome. Firstly, repeatmodeler identifies
# repeat element boundaries and relationships within repeat families. The repeats
# identified within the genome are provided to repeatmasker, which uses this data
# along with it's own repeat libraries to identify these repetitive regions and
# perform masking. Masking is done at 3 levels:
# Hardmasking = repetitive sequence is replaced with N's.
# Softmasking = repetitive sequence is converted to lower case.
# Ignoring low-complexity regions = only interspersed repetitive elements are masked.

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

Genome=$1
OutFile=$2
OutDir=$3

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

echo __
echo __

mkdir -p $WorkDir

ln -s $Genome ${WorkDir}/${OutFile}_contigs_unmasked.fa

cd $WorkDir

source package 14fbfadb-9fe7-419a-9f20-cd5f458c0fff
source package 85eb6fb0-3eb7-43b2-9659-49e0142481fc

BuildDatabase -name ${OutFile}_RepMod ${OutFile}_contigs_unmasked.fa
RepeatModeler -pa 8 -database ${OutFile}_RepMod

# hardmask
RepeatMasker -gff -pa 8 -lib RM_*.*/consensi.fa.classified ${OutFile}_contigs_unmasked.fa
mv ${OutFile}_contigs_unmasked.fa.cat.gz ${OutFile}_contigs_hardmasked.fa.cat.gz
mv ${OutFile}_contigs_unmasked.fa.masked ${OutFile}_contigs_hardmasked.fa
mv ${OutFile}_contigs_unmasked.fa.out ${OutFile}_contigs_hardmasked.out
mv ${OutFile}_contigs_unmasked.fa.out.gff ${OutFile}_contigs_hardmasked.fa.out.gff
mv ${OutFile}_contigs_unmasked.fa.tbl ${OutFile}_contigs_hardmasked.tbl
grep -v '#' ${OutFile}_contigs_hardmasked.fa.out.gff > ${OutFile}_contigs_hardmasked.gff

# softmask
RepeatMasker -xsmall -gff -pa 8 -lib RM_*.*/consensi.fa.classified ${OutFile}_contigs_unmasked.fa
mv ${OutFile}_contigs_unmasked.fa.cat.gz ${OutFile}_contigs_softmasked.fa.cat.gz
mv ${OutFile}_contigs_unmasked.fa.masked ${OutFile}_contigs_softmasked.fa
mv ${OutFile}_contigs_unmasked.fa.out ${OutFile}_contigs_softmasked.out
mv ${OutFile}_contigs_unmasked.fa.out.gff ${OutFile}_contigs_softmasked.fa.out.gff
mv ${OutFile}_contigs_unmasked.fa.tbl ${OutFile}_contigs_softmasked.tbl
grep -v '#' ${OutFile}_contigs_softmasked.fa.out.gff > ${OutFile}_contigs_softmasked.gff

# don't mask low-complexity or simple-repeat sequences, just transposons
RepeatMasker -nolow -gff -pa 8 -lib RM_*.*/consensi.fa.classified ${OutFile}_contigs_unmasked.fa
mv ${OutFile}_contigs_unmasked.fa.cat.gz ${OutFile}_contigs_transposonmasked.fa.cat.gz
mv ${OutFile}_contigs_unmasked.fa.masked ${OutFile}_contigs_transposonmasked.fa
mv ${OutFile}_contigs_unmasked.fa.out ${OutFile}_contigs_transposonmasked.out
mv ${OutFile}_contigs_unmasked.fa.out.gff ${OutFile}_contigs_transposonmasked.fa.out.gff
mv ${OutFile}_contigs_unmasked.fa.tbl ${OutFile}_contigs_transposonmasked.tbl
grep -v '#' ${OutFile}_contigs_transposonmasked.fa.out.gff > ${OutFile}_contigs_transposonmasked.gff

mkdir -p $OutDir
rm -r $WorkDir/RM*
cp -r $WorkDir/* $OutDir/.

rm -r $WorkDir

