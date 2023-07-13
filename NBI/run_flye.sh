#!/bin/bash
#SBATCH --job-name=flye
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 150G
#SBATCH -c 32
#SBATCH -p jic-long,nbi-long
#SBATCH --time=2-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
OutDir=$1
OutFile=$2
Genomesize=$3
PolishingIterations=$4
DataType=$5
ReadErrorRate=$6

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile

echo Genomesize:
echo $Genomesize
echo Polishing iterations:
echo $PolishingIterations
echo Data type:
echo $DataType
echo Read Error Rate:
echo $ReadErrorRate

echo ReadFiles:
echo 1:
echo ${7}
echo 2:
echo ${8}
echo 3:
echo ${9}
echo 4:
echo ${10}
echo 5:
echo ${11}
echo 6:
echo ${12}
echo 7:
echo ${13}
echo 8:
echo ${14}
echo 9:
echo ${15}
echo 10:
echo ${16}
echo 11:
echo ${17}
echo 12:
echo ${18}
echo 13:
echo ${19}
echo 14:
echo ${20}
echo 15:
echo ${21}

echo _
echo _

mkdir -p $WorkDir

zcat ${7} ${8} ${9} ${10} ${11} ${12} ${13} ${14} ${15} ${16} ${17} ${18} ${19} ${20} ${21} > $WorkDir/fasta.fq

cd $WorkDir

source package 72ecae8a-1685-482f-8240-f3373e232b37
source package /tgac/software/production/bin/abyss-1.3.5

mkdir unscaffoldeddef
mkdir unscaffolded
mkdir scaffolded

flye --$DataType fasta.fq -o ./unscaffolded -t 32 --debug
flye --pacbio-hifi fasta.fq -o ./scaffolded -t 32 --debug --scaffold
flye --pacbio-hifi fasta.fq --out-dir ./unscaffoldeddef -t 32 --genome-size $Genomesize --read-error $ReadErrorRate
#awk '/^S/{print ">"$2;print $3}' ${OutFile}.bp.p_ctg.gfa > ${OutFile}.bp.p_ctg.fa
abyss-fac unscaffoldeddef/assembly.fasta > unscaffoldeddef/abyss_report.txt
abyss-fac unscaffolded/assembly.fasta > unscaffolded/abyss_report.txt
abyss-fac scaffolded/assembly.fasta > scaffolded/abyss_report.txt

rm fasta.fq
cp unscaffolded/assembly.fasta $OutDir/${OutFile}_unscaffolded.fa
cp scaffolded/assembly.fasta $OutDir/${OutFile}_scaffolded.fa
cp unscaffolded/abyss_report.txt $OutDir/${OutFile}_unscaffolded_abyss_report.txt
cp scaffolded/abyss_report.txt $OutDir/${OutFile}_scaffolded_abyss_report.txt
echo DONE
rm -r $WorkDir

