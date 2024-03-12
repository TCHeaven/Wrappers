#!/bin/bash
#SBATCH --job-name=diamond
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 25G
#SBATCH --nodes=1
#SBATCH -c 32
#SBATCH -p nbi-short,jic-short
#SBATCH --time=00-02:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
InFile=$1
Database=$2
OutDir=$3
OutFile=$4


echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo Input:
echo $InFile
echo Database:
echo $Database
echo Max target sequences:
echo $5
echo _
echo _

mkdir -p $WorkDir
ln -s $InFile $WorkDir/InFile.fa

cd $WorkDir
source package dd43df1f-7eb2-4011-88fc-c457e801ddd0
#source package /nbi/software/testing/bin/blast+-2.12.0 

diamond blastp \
        --query InFile.fa \
        --db $Database \
        --outfmt 6 qseqid staxids bitscore qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore \
        --sensitive \
        --max-target-seqs $5 \
        --evalue 1e-25 \
        --threads 32 \
        > ${OutFile}.vs.$(basename $Database).diamond_blastp.out

#mkdir ${OutDir}
rm InFile.fa
cp * ${OutDir}/.
#echo "blatx complete" > ${OutDir}/check.txt
echo DONE
rm -r $WorkDir
