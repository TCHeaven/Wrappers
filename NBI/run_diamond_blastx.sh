#!/bin/bash
#SBATCH --job-name=diamond
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 350G
#SBATCH --nodes=1
#SBATCH -c 32
#SBATCH -p nbi-medium,jic-medium,nbi-long,jic-long
#SBATCH --time=02-00:00:00

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
echo _
echo _

mkdir -p $WorkDir
ln -s $InFile $WorkDir/InFile.fa

cd $WorkDir
source package dd43df1f-7eb2-4011-88fc-c457e801ddd0

diamond blastx \
        --query InFile.fa \
        --db $Database \
        --outfmt 6 qseqid staxids bitscore qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore \
        --sensitive \
        --max-target-seqs 1 \
        --evalue 1e-25 \
        --threads 32 \
        > ${OutFile}.vs.$(basename $Database).diamondblastx.out

#mkdir ${OutDir}
rm InFile.fa
cp * ${OutDir}/.
echo "blatx complete" > ${OutDir}/check.txt
echo DONE
rm -r $WorkDir
