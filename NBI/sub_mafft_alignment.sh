#!/usr/bin/env bash
#SBATCH -J mafft
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH -p jic-short,nbi-short
#SBATCH --mem-per-cpu=10G
#SBATCH -c 4

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
InFile=$1
OutDir=$2
OutFile=$3

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo Gene:
echo $InFile

#### MAFFT alignment with the highest accuracy method L-INS-i (less than <200 sequences)
#### The scripts separately aligns all the FASTA sequences contained within each file in the directory.
#### OUTPUT: aligned FASTA file, with "aligned" suffix

mkdir -p $WorkDir
cd $WorkDir

source package 05bafab5-380c-4fe6-b5b6-3df70db09722

mafft --thread 4 --localpair --maxiterate 1000 $InFile > $OutFile

#Convert to single line FASTA for easy parsing
awk '!/^>/ { printf "%s", $0; n = "\n" } /^>/ { print n $0; n = "" } END { printf "%s", n }' $OutFile > temp && mv temp $OutFile

mv $OutFile  ${OutDir}/.

echo DONE

rm -r $WorkDir