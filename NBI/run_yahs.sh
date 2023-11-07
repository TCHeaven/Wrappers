#!/bin/bash
#SBATCH --job-name=yahs
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 1380G
#SBATCH -c 32
#SBATCH -p jic-largemem
#SBATCH --time=02-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

Assembly=$1
Alignment=$2
Alignment_Index=$3
Enzyme=$4
OutDir=$5
OutFile=$6

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo Assembly:
echo $Assembly
echo Alignment:
echo $Alignment	
echo Alignment Index:
echo $Alignment_Index	
echo Enzyme:
echo $Enzyme
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo _
echo _

mkdir -p $WorkDir

ln -s $Assembly $WorkDir/genome.fa
ln -s $Alignment $WorkDir/mapped.PT.bam
ln -s $Alignment_Index $WorkDir/mapped.PT.bam.bai
cd $WorkDir


source package 638df626-d658-40aa-80e5-14a275b7464b
source package f5f245b9-09e4-49c5-9710-85a134a9c20f
source package /tgac/software/production/bin/abyss-1.3.5

samtools faidx genome.fa
yahs genome.fa mapped.PT.bam -o $OutFile -e $Enzyme 
#yahs -l 20000 --no-contig-ec genome.fa mapped.PT.bam -o $OutFile -e $Enzyme #with lower cuttoffs

abyss-fac ${OutFile}_scaffolds_final.fa > ${OutDir}/abyss_report.txt

cp ${OutFile}.bin ${OutDir}/.
cp ${OutFile}_scaffolds_final.agp ${OutDir}/.
cp ${OutFile}_scaffolds_final.fa ${OutDir}/.

echo DONE
#rm -r $WorkDir
