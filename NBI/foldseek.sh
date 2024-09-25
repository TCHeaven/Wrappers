#!/bin/bash
#SBATCH -p jic-largemem
#SBATCH -t 0-12:00
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH -c 64
#SBATCH --mem=500G
#SBATCH -J foldseek

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

InFile=$1
Database=$2
OutDir=$3
OutFile=$4

pwd
hostname
date

echo InFile: $InFile
echo Database: $Database
echo OutDir: $OutDir
echo OutFile: $OutFile
echo __
echo __ 

source package cda29b6a-320e-4d73-83c6-240ed7a6201e

foldseek easy-search -e inf --format-output "query,target,fident,alnlen,mismatch,gapopen,qstart,qend,tstart,tend,evalue,bits,alntmscore,qtmscore,ttmscore,lddt,lddtfull,prob"  $InFile $Database ${OutDir}/${OutFile} $WorkDir

date
