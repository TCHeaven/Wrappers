#!/bin/bash
#SBATCH --job-name=jellyfish
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 32G
#SBATCH --nodes=1
#SBATCH -c 32
#SBATCH -p nbi-medium,jic-medium
#SBATCH --time=1-00:00:00

CurPath=$PWD
#WorkDir=${TMPDIR}/${SLURM_JOB_ID}
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
OutDir=$1
OutFile=$2

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo ReadFiles:
echo 1:
echo $3
echo 2:
echo $4
echo 3:
echo $5
echo 4:
echo $6
echo 5:
echo $7
echo 6:
echo $8
echo 7:
echo $9
echo 8:
echo ${10}
echo 9:
echo ${11}
echo 10:
echo ${12}
echo 11:
echo ${13}
echo 12:
echo ${14}
echo 13:
echo ${15}
echo 14:
echo ${16}
echo 15:
echo ${17}
echo _
echo _

mkdir -p $WorkDir

cp $3 $WorkDir/fasta.fq.gz
cp $4 $WorkDir/fasta1.fq.gz
cp $5 $WorkDir/fasta2.fq.gz
cp $6 $WorkDir/fasta3.fq.gz
cp $7 $WorkDir/fasta4.fq.gz
cp $8 $WorkDir/fasta5.fq.gz
cp $9 $WorkDir/fasta6.fq.gz
cp ${10} $WorkDir/fasta7.fq.gz
cp ${11} $WorkDir/fasta8.fq.gz
cp ${12} $WorkDir/fasta9.fq.gz
cp ${13} $WorkDir/fasta10.fq.gz
cp ${14} $WorkDir/fasta11.fq.gz
cp ${15} $WorkDir/fasta12.fq.gz
cp ${16} $WorkDir/fasta13.fq.gz
cp ${17} $WorkDir/fasta14.fq.gz

cd $WorkDir

source package 7f4fb852-f5c2-4e4b-b9a6-e648176d5543
source package 3fe68588-ae0b-4935-b029-7a2dfbf1c4f3

if [[ -e fasta14.fq.gz ]]; then
    echo Running with 15
    jellyfish count -t 32 -C -m 19 -s 650M -o ${OutFile}_19mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz) <(zcat fasta8.fq.gz) <(zcat fasta9.fq.gz) <(zcat fasta10.fq.gz) <(zcat fasta11.fq.gz) <(zcat fasta12.fq.gz) <(zcat fasta13.fq.gz) <(zcat fasta14.fq.gz) 
	jellyfish count -t 32 -C -m 21 -s 650M -o ${OutFile}_21mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz) <(zcat fasta8.fq.gz) <(zcat fasta9.fq.gz) <(zcat fasta10.fq.gz) <(zcat fasta11.fq.gz) <(zcat fasta12.fq.gz) <(zcat fasta13.fq.gz) <(zcat fasta14.fq.gz) 
	jellyfish count -t 32 -C -m 25 -s 650M -o ${OutFile}_25mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz) <(zcat fasta8.fq.gz) <(zcat fasta9.fq.gz) <(zcat fasta10.fq.gz) <(zcat fasta11.fq.gz) <(zcat fasta12.fq.gz) <(zcat fasta13.fq.gz) <(zcat fasta14.fq.gz) 
	jellyfish count -t 32 -C -m 31 -s 650M -o ${OutFile}_31mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz) <(zcat fasta8.fq.gz) <(zcat fasta9.fq.gz) <(zcat fasta10.fq.gz) <(zcat fasta11.fq.gz) <(zcat fasta12.fq.gz) <(zcat fasta13.fq.gz) <(zcat fasta14.fq.gz) 
elif [[ -e fasta13.fq.gz ]]; then
    echo Running with 14
    jellyfish count -t 32 -C -m 19 -s 650M -o ${OutFile}_19mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz) <(zcat fasta8.fq.gz) <(zcat fasta9.fq.gz) <(zcat fasta10.fq.gz) <(zcat fasta11.fq.gz) <(zcat fasta12.fq.gz) <(zcat fasta13.fq.gz)
	jellyfish count -t 32 -C -m 21 -s 650M -o ${OutFile}_21mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz) <(zcat fasta8.fq.gz) <(zcat fasta9.fq.gz) <(zcat fasta10.fq.gz) <(zcat fasta11.fq.gz) <(zcat fasta12.fq.gz) <(zcat fasta13.fq.gz)
	jellyfish count -t 32 -C -m 25 -s 650M -o ${OutFile}_25mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz) <(zcat fasta8.fq.gz) <(zcat fasta9.fq.gz) <(zcat fasta10.fq.gz) <(zcat fasta11.fq.gz) <(zcat fasta12.fq.gz) <(zcat fasta13.fq.gz)
	jellyfish count -t 32 -C -m 31 -s 650M -o ${OutFile}_31mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz) <(zcat fasta8.fq.gz) <(zcat fasta9.fq.gz) <(zcat fasta10.fq.gz) <(zcat fasta11.fq.gz) <(zcat fasta12.fq.gz) <(zcat fasta13.fq.gz)
elif [[ -e fasta12.fq.gz ]]; then
    echo Running with 13
    jellyfish count -t 32 -C -m 19 -s 650M -o ${OutFile}_19mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz) <(zcat fasta8.fq.gz) <(zcat fasta9.fq.gz) <(zcat fasta10.fq.gz) <(zcat fasta11.fq.gz) <(zcat fasta12.fq.gz)
	jellyfish count -t 32 -C -m 21 -s 650M -o ${OutFile}_21mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz) <(zcat fasta8.fq.gz) <(zcat fasta9.fq.gz) <(zcat fasta10.fq.gz) <(zcat fasta11.fq.gz) <(zcat fasta12.fq.gz)
	jellyfish count -t 32 -C -m 25 -s 650M -o ${OutFile}_25mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz) <(zcat fasta8.fq.gz) <(zcat fasta9.fq.gz) <(zcat fasta10.fq.gz) <(zcat fasta11.fq.gz) <(zcat fasta12.fq.gz)
	jellyfish count -t 32 -C -m 31 -s 650M -o ${OutFile}_31mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz) <(zcat fasta8.fq.gz) <(zcat fasta9.fq.gz) <(zcat fasta10.fq.gz) <(zcat fasta11.fq.gz) <(zcat fasta12.fq.gz)
elif [[ -e fasta11.fq.gz ]]; then
    echo Running with 12
    jellyfish count -t 32 -C -m 19 -s 650M -o ${OutFile}_19mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz) <(zcat fasta8.fq.gz) <(zcat fasta9.fq.gz) <(zcat fasta10.fq.gz) <(zcat fasta11.fq.gz)
	jellyfish count -t 32 -C -m 21 -s 650M -o ${OutFile}_21mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz) <(zcat fasta8.fq.gz) <(zcat fasta9.fq.gz) <(zcat fasta10.fq.gz) <(zcat fasta11.fq.gz)
	jellyfish count -t 32 -C -m 25 -s 650M -o ${OutFile}_25mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz) <(zcat fasta8.fq.gz) <(zcat fasta9.fq.gz) <(zcat fasta10.fq.gz) <(zcat fasta11.fq.gz)
	jellyfish count -t 32 -C -m 31 -s 650M -o ${OutFile}_31mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz) <(zcat fasta8.fq.gz) <(zcat fasta9.fq.gz) <(zcat fasta10.fq.gz) <(zcat fasta11.fq.gz)
elif [[ -e fasta10.fq.gz ]]; then
    echo Running with 11
    jellyfish count -t 32 -C -m 19 -s 650M -o ${OutFile}_19mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz) <(zcat fasta8.fq.gz) <(zcat fasta9.fq.gz) <(zcat fasta10.fq.gz)
	jellyfish count -t 32 -C -m 21 -s 650M -o ${OutFile}_21mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz) <(zcat fasta8.fq.gz) <(zcat fasta9.fq.gz) <(zcat fasta10.fq.gz)
	jellyfish count -t 32 -C -m 25 -s 650M -o ${OutFile}_25mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz) <(zcat fasta8.fq.gz) <(zcat fasta9.fq.gz) <(zcat fasta10.fq.gz)
	jellyfish count -t 32 -C -m 31 -s 650M -o ${OutFile}_31mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz) <(zcat fasta8.fq.gz) <(zcat fasta9.fq.gz) <(zcat fasta10.fq.gz)
elif [[ -e fasta9.fq.gz ]]; then
    echo Running with 10
    jellyfish count -t 32 -C -m 19 -s 650M -o ${OutFile}_19mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz) <(zcat fasta8.fq.gz) <(zcat fasta9.fq.gz)
	jellyfish count -t 32 -C -m 21 -s 650M -o ${OutFile}_21mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz) <(zcat fasta8.fq.gz) <(zcat fasta9.fq.gz)
	jellyfish count -t 32 -C -m 25 -s 650M -o ${OutFile}_25mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz) <(zcat fasta8.fq.gz) <(zcat fasta9.fq.gz)
	jellyfish count -t 32 -C -m 31 -s 650M -o ${OutFile}_31mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz) <(zcat fasta8.fq.gz) <(zcat fasta9.fq.gz)
elif [[ -e fasta8.fq.gz ]]; then
    echo Running with 9
    jellyfish count -t 32 -C -m 19 -s 650M -o ${OutFile}_19mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz) <(zcat fasta8.fq.gz)
	jellyfish count -t 32 -C -m 21 -s 650M -o ${OutFile}_21mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz) <(zcat fasta8.fq.gz)
	jellyfish count -t 32 -C -m 25 -s 650M -o ${OutFile}_25mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz) <(zcat fasta8.fq.gz)
	jellyfish count -t 32 -C -m 31 -s 650M -o ${OutFile}_31mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz) <(zcat fasta8.fq.gz)
elif [[ -e fasta7.fq.gz ]]; then
    echo Running with 8
    jellyfish count -t 32 -C -m 19 -s 650M -o ${OutFile}_19mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz)
	jellyfish count -t 32 -C -m 21 -s 650M -o ${OutFile}_21mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz)
	jellyfish count -t 32 -C -m 25 -s 650M -o ${OutFile}_25mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz)
	jellyfish count -t 32 -C -m 31 -s 650M -o ${OutFile}_31mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz) <(zcat fasta7.fq.gz)
elif [[ -e fasta6.fq.gz ]]; then
    echo Running with 7
    jellyfish count -t 32 -C -m 19 -s 650M -o ${OutFile}_19mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz)
	jellyfish count -t 32 -C -m 21 -s 650M -o ${OutFile}_21mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz)
	jellyfish count -t 32 -C -m 25 -s 650M -o ${OutFile}_25mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz)
	jellyfish count -t 32 -C -m 31 -s 650M -o ${OutFile}_31mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz) <(zcat fasta6.fq.gz)
elif [[ -e fasta5.fq.gz ]]; then
    echo Running with 6
    jellyfish count -t 32 -C -m 19 -s 650M -o ${OutFile}_19mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz)
	jellyfish count -t 32 -C -m 21 -s 650M -o ${OutFile}_21mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz)
	jellyfish count -t 32 -C -m 25 -s 650M -o ${OutFile}_25mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz)
	jellyfish count -t 32 -C -m 31 -s 650M -o ${OutFile}_31mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz) <(zcat fasta5.fq.gz)
elif [[ -e fasta4.fq.gz ]]; then
    echo Running with 5
    jellyfish count -t 32 -C -m 19 -s 650M -o ${OutFile}_19mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz)
	jellyfish count -t 32 -C -m 21 -s 650M -o ${OutFile}_21mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz)
	jellyfish count -t 32 -C -m 25 -s 500G -o ${OutFile}_25mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz)
	jellyfish count -t 32 -C -m 31 -s 500G -o ${OutFile}_31mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz) <(zcat fasta4.fq.gz)
elif [[ -e fasta3.fq.gz ]]; then
    echo Running with 4
    jellyfish count -t 32 -C -m 19 -s 650M -o ${OutFile}_19mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz)
	jellyfish count -t 32 -C -m 21 -s 650M -o ${OutFile}_21mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz)
	jellyfish count -t 32 -C -m 25 -s 650M -o ${OutFile}_25mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz)
	jellyfish count -t 32 -C -m 31 -s 650M -o ${OutFile}_31mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz) <(zcat fasta3.fq.gz)
elif [[ -e fasta2.fq.gz ]]; then
    echo Running with 3
    jellyfish count -t 32 -C -m 19 -s 650M -o ${OutFile}_19mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz)
	jellyfish count -t 32 -C -m 21 -s 650M -o ${OutFile}_21mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz)
	jellyfish count -t 32 -C -m 25 -s 650M -o ${OutFile}_25mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz)
	jellyfish count -t 32 -C -m 31 -s 650M -o ${OutFile}_31mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz) <(zcat fasta2.fq.gz)
elif [[ -e fasta1.fq.gz ]]; then
    echo Running with 2
    jellyfish count -t 32 -C -m 19 -s 650M -o ${OutFile}_19mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz)
	jellyfish count -t 32 -C -m 21 -s 650M -o ${OutFile}_21mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz)
	jellyfish count -t 32 -C -m 25 -s 650M -o ${OutFile}_25mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz)
	jellyfish count -t 32 -C -m 31 -s 650M -o ${OutFile}_31mer_out --min-qual-char=? <(zcat fasta.fq.gz) <(zcat fasta1.fq.gz)
elif [[ -e fasta.fq.gz ]]; then
    echo Running with 1
    jellyfish count -t 32 -C -m 19 -s 650M -o ${OutFile}_19mer_out --min-qual-char=? <(zcat fasta.fq.gz) 
	jellyfish count -t 32 -C -m 21 -s 650M -o ${OutFile}_21mer_out --min-qual-char=? <(zcat fasta.fq.gz) 
	jellyfish count -t 32 -C -m 25 -s 650M -o ${OutFile}_25mer_out --min-qual-char=? <(zcat fasta.fq.gz) 
	jellyfish count -t 32 -C -m 31 -s 650M -o ${OutFile}_31mer_out --min-qual-char=? <(zcat fasta.fq.gz) 
else
    echo "No read files were provided"
fi


jellyfish histo -h 10000000 -o ${OutFile}_19mer_out.histo ${OutFile}_19mer_out
jellyfish histo -h 10000000 -o ${OutFile}_21mer_out.histo ${OutFile}_21mer_out
jellyfish histo -h 10000000 -o ${OutFile}_25mer_out.histo ${OutFile}_25mer_out
jellyfish histo -h 10000000 -o ${OutFile}_31mer_out.histo ${OutFile}_31mer_out

#NOTE: Jellyfish cannot count kmers larger than 31
source package 88c30fea-a263-44d2-a0b6-07681251a41d

gunzip *.fq.gz
cat *.fq > bigfile.fastaq
rm *.fq
kmc -k39 -sm -m32 -t32 -ci1 bigfile.fastaq ${OutFile}_39mer_out $WorkDir
kmc_tools transform ${OutFile}_39mer_out dump 39mers.txt
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 /hpc-home/did23faz/git_repos/Scripts/NBI/kmc_histo.py 39mers.txt ${OutFile}_39mer_out.histo
rm 39mers.txt

kmc -k49 -sm -m32 -t32 -ci1 bigfile.fastaq ${OutFile}_49mer_out $WorkDir
kmc_tools transform ${OutFile}_49mer_out dump 49mers.txt
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 /hpc-home/did23faz/git_repos/Scripts/NBI/kmc_histo.py 49mers.txt ${OutFile}_49mer_out.histo
rm 49mers.txt

kmc -k61 -sm -m32 -t32 -ci1 bigfile.fastaq ${OutFile}_61mer_out $WorkDir
kmc_tools transform ${OutFile}_61mer_out dump 61mers.txt
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 /hpc-home/did23faz/git_repos/Scripts/NBI/kmc_histo.py 61mers.txt ${OutFile}_61mer_out.histo
rm 61mers.txt

kmc -k75 -sm -m32 -t32 -ci1 bigfile.fastaq ${OutFile}_75mer_out $WorkDir
kmc_tools transform ${OutFile}_75mer_out dump 75mers.txt
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 /hpc-home/did23faz/git_repos/Scripts/NBI/kmc_histo.py 75mers.txt ${OutFile}_75mer_out.histo
rm 75mers.txt

cp ${OutFile}*.histo $OutDir/.
echo DONE
rm -r $WorkDir


