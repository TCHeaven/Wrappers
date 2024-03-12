#!/bin/bash
#SBATCH --job-name=mitohifi
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 50G
#SBATCH --nodes=1
#SBATCH -c 16
#SBATCH -p jic-short
#SBATCH --time=00-02:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
Assembly=$1
ReferenceFasta=$2
ReferenceGenebank=$3
Overlap=$4
Code=$5
Kingdom=$6
Good_Reference=$7
OutDir=$8

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo Assembly:
echo $Assembly
echo Reference Fasta:
echo $ReferenceFasta
echo Reference Genebank:
echo $ReferenceGenebank	
echo Overlap:
echo $Overlap
echo Code:
echo $Code
echo kingdom:
echo $Kingdom
echo Is reference good/complete: $Good_Reference
echo _
echo _

mkdir -p $WorkDir
ln -s $Assembly $WorkDir/contigs.fa
ln -s $ReferenceFasta $WorkDir/reference.fa
ln -s $ReferenceGenebank $WorkDir/reference.gb

cd $WorkDir
#source /nbi/software/staging/RCSUPPORT-2522/stagingloader
source package a167f771-f9c0-4e78-93ed-af9f8927276f

if [[ $Good_Reference == "yes" || $Good_Reference == "y" || $Good_Reference == "Y" || $Good_Reference == "Yes" ]]; then 
mitohifi.py -c contigs.fa -f reference.fa -g reference.gb -t 16 -d -a $Kingdom -p $Overlap -o $Code
else
mitohifi.py -c contigs.fa -f reference.fa -g reference.gb -t 16 -d -a $Kingdom -p $Overlap --mitos -o $Code
fi

mkdir ${OutDir}

find . -maxdepth 1 -type l -delete
rm contigs.fa
mv * ${OutDir}/.
echo DONE
rm -r $WorkDir
