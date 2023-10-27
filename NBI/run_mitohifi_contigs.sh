#!/bin/bash
#SBATCH --job-name=kraken
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 50G
#SBATCH --nodes=1
#SBATCH -c 16
#SBATCH -p nbi-medium,jic-medium,nbi-long,jic-long
#SBATCH --time=02-00:00:00

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
OutFile=$9

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
ln -s $ReferenceGenebank $WorkDir/reference.gbk

cd $WorkDir
source /nbi/software/staging/RCSUPPORT-2522/stagingloader

if [[ $Good_Reference == "yes" || $Good_Reference == "y" || $Good_Reference == "Y" || $Good_Reference == "Yes" ]]; then 
mitohifi.py -c contigs.fa -f reference.fa -g reference.gbk -t 16 -d -a $Kingdom -p $Overlap -o $Code
else
mitohifi.py -c contigs.fa -f reference.fa -g reference.gbk -t 16 -d -a $Kingdom -p $Overlap --mitos -o $Code
fi

#mkdir ${OutDir}
#cp ${OutFile}* ${OutDir}/.
echo DONE
#rm -r $WorkDir
