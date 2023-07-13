#!/bin/bash
#SBATCH --job-name=kat_comp
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 150G
#SBATCH --nodes=1
#SBATCH -c 32
#SBATCH -p nbi-long,jic-long
#SBATCH --time=5-00:00:00

CurPath=$PWD
#WorkDir=${TMPDIR}/${SLURM_JOB_ID}
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
OutDir=$1
OutFile=$2
InFile=$3

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo Genome:
echo $InFile
echo ReadFiles:
echo 1:
echo $4
echo 2:
echo $5
echo 3:
echo $6
echo 4:
echo $7
echo 5:
echo $8
echo 6:
echo $9
echo 7:
echo ${10}
echo 8:
echo ${11}
echo 9:
echo ${12}
echo 10:
echo ${13}
echo 11:
echo ${14}
echo 12:
echo ${15}
echo 13:
echo ${16}
echo 14:
echo ${17}
echo 15:
echo ${18}
echo 16:
echo ${19}
echo _
echo _

mkdir -p $WorkDir

cp $InFile $WorkDir/genome.fa
cp $4 $WorkDir/fasta.fq.gz
cp $5 $WorkDir/fasta1.fq.gz
cp $6 $WorkDir/fasta2.fq.gz
cp $7 $WorkDir/fasta3.fq.gz
cp $8 $WorkDir/fasta4.fq.gz
cp $9 $WorkDir/fasta5.fq.gz
cp ${10} $WorkDir/fasta6.fq.gz
cp ${11} $WorkDir/fasta7.fq.gz
cp ${12} $WorkDir/fasta8.fq.gz
cp ${13} $WorkDir/fasta9.fq.gz
cp ${14} $WorkDir/fasta10.fq.gz
cp ${15} $WorkDir/fasta11.fq.gz
cp ${16} $WorkDir/fasta12.fq.gz
cp ${17} $WorkDir/fasta13.fq.gz
cp ${18} $WorkDir/fasta14.fq.gz
cp ${19} $WorkDir/fasta15.fq.gz

cd $WorkDir

if [[ -e fasta15.fq.gz ]]; then
    echo Running with 16
zcat fasta.fq.gz  fasta2.fq.gz fasta4.fq.gz fasta6.fq.gz fasta8.fq.gz fasta10.fq.gz fasta12.fq.gz fasta14.fq.gz > fastaF.fq
rm fasta.fq.gz  fasta2.fq.gz fasta4.fq.gz fasta6.fq.gz fasta8.fq.gz fasta10.fq.gz fasta12.fq.gz fasta14.fq.gz 
gzip fastaF.fq
zcat fasta1.fq.gz fasta3.fq.gz fasta5.fq.gz fasta7.fq.gz fasta9.fq.gz fasta11.fq.gz fasta13.fq.gz fasta15.fq.gz > fastaR.fq
rm fasta1.fq.gz fasta3.fq.gz fasta5.fq.gz fasta7.fq.gz fasta9.fq.gz fasta11.fq.gz fasta13.fq.gz fasta15.fq.gz 
gzip fastaR.fq
elif [[ -e fasta13.fq.gz ]]; then
    echo Running with 14
zcat fasta.fq.gz  fasta2.fq.gz fasta4.fq.gz fasta6.fq.gz fasta8.fq.gz fasta10.fq.gz fasta12.fq.gz > fastaF.fq
rm fasta.fq.gz  fasta2.fq.gz fasta4.fq.gz fasta6.fq.gz fasta8.fq.gz fasta10.fq.gz fasta12.fq.gz 
gzip fastaF.fq
zcat fasta1.fq.gz fasta3.fq.gz fasta5.fq.gz fasta7.fq.gz fasta9.fq.gz fasta11.fq.gz fasta13.fq.gz > fastaR.fq
rm fasta1.fq.gz fasta3.fq.gz fasta5.fq.gz fasta7.fq.gz fasta9.fq.gz fasta11.fq.gz fasta13.fq.gz
gzip fastaR.fq
elif [[ -e fasta11.fq.gz ]]; then
    echo Running with 12
zcat fasta.fq.gz  fasta2.fq.gz fasta4.fq.gz fasta6.fq.gz fasta8.fq.gz fasta10.fq.gz > fastaF.fq
rm fasta.fq.gz  fasta2.fq.gz fasta4.fq.gz fasta6.fq.gz fasta8.fq.gz fasta10.fq.gz 
gzip fastaF.fq
zcat fasta1.fq.gz fasta3.fq.gz fasta5.fq.gz fasta7.fq.gz fasta9.fq.gz fasta11.fq.gz > fastaR.fq
rm fasta1.fq.gz fasta3.fq.gz fasta5.fq.gz fasta7.fq.gz fasta9.fq.gz fasta11.fq.gz
gzip fastaR.fq
elif [[ -e fasta9.fq.gz ]]; then
    echo Running with 10
zcat fasta.fq.gz  fasta2.fq.gz fasta4.fq.gz fasta6.fq.gz fasta8.fq.gz > fastaF.fq
rm fasta.fq.gz  fasta2.fq.gz fasta4.fq.gz fasta6.fq.gz fasta8.fq.gz
gzip fastaF.fq
zcat fasta1.fq.gz fasta3.fq.gz fasta5.fq.gz fasta7.fq.gz fasta9.fq.gz > fastaR.fq
rm fasta1.fq.gz fasta3.fq.gz fasta5.fq.gz fasta7.fq.gz fasta9.fq.gz
gzip fastaR.fq
elif [[ -e fasta7.fq.gz ]]; then
    echo Running with 8
zcat fasta.fq.gz  fasta2.fq.gz fasta4.fq.gz fasta6.fq.gz > fastaF.fq
rm fasta.fq.gz  fasta2.fq.gz fasta4.fq.gz fasta6.fq.gz
gzip fastaF.fq
zcat fasta1.fq.gz fasta3.fq.gz fasta5.fq.gz fasta7.fq.gz > fastaR.fq
rm fasta1.fq.gz fasta3.fq.gz fasta5.fq.gz fasta7.fq.gz 
gzip fastaR.fq
elif [[ -e fasta5.fq.gz ]]; then
    echo Running with 6
zcat fasta.fq.gz  fasta2.fq.gz fasta4.fq.gz > fastaF.fq
rm fasta.fq.gz  fasta2.fq.gz fasta4.fq.gz
gzip fastaF.fq
zcat fasta1.fq.gz fasta3.fq.gz fasta5.fq.gz > fastaR.fq
rm fasta1.fq.gz fasta3.fq.gz fasta5.fq.gz 
gzip fastaR.fq
elif [[ -e fasta3.fq.gz ]]; then
    echo Running with 4
zcat fasta.fq.gz  fasta2.fq.gz > fastaF.fq
rm fasta.fq.gz  fasta2.fq.gz
gzip fastaF.fq
zcat fasta1.fq.gz fasta3.fq.gz > fastaR.fq
rm fasta1.fq.gz fasta3.fq.gz
gzip fastaR.fq
elif [[ -e fasta1.fq.gz ]]; then
    echo Running with 2
zcat fasta.fq.gz > fastaF.fq
rm fasta.fq.gz 
gzip fastaF.fq
zcat fasta1.fq.gz > fastaR.fq
rm fasta1.fq.gz
gzip fastaR.fq
else
    echo "No read files were provided"
fi

source package 7f4fb852-f5c2-4e4b-b9a6-e648176d5543
kat comp -t 32 -o ${OutFile}_31 -m 31 -H 100000000 -I 100000000 'fastaF.fq.gz fastaR.fq.gz' 'genome.fa'
kat comp -t 32 -o ${OutFile}_51 -m 51 -H 100000000 -I 100000000 'fastaF.fq.gz fastaR.fq.gz' 'genome.fa'

kat plot spectra-cn -x 50 -o ${OutFile}_plot50_31 ${OutFile}_31-main.mx
kat plot spectra-cn -x 100 -o ${OutFile}_plot100_31 ${OutFile}_31-main.mx
kat plot spectra-cn -x 300 -o ${OutFile}_plot300_31 ${OutFile}_31-main.mx
kat plot spectra-cn -x 1000 -o ${OutFile}_plot1000_31 ${OutFile}_31-main.mx

kat plot spectra-cn -x 50 -o ${OutFile}_plot50_51 ${OutFile}_51-main.mx
kat plot spectra-cn -x 100 -o ${OutFile}_plot100_51 ${OutFile}_51-main.mx
kat plot spectra-cn -x 300 -o ${OutFile}_plot300_51 ${OutFile}_51-main.mx
kat plot spectra-cn -x 1000 -o ${OuFfile}_plot1000_51 ${OutFile}_51-main.mx

cp ${OutFile}* $OutDir/.
echo DONE
rm -r $WorkDir