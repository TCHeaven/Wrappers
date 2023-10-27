#!/bin/bash
#SBATCH --job-name=bwa
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 50G
#SBATCH --nodes=1
#SBATCH -c 62
#SBATCH -p jic-medium
#SBATCH --time=02-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
OutDir=$1
OutFile=$2
Reference=$3

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo Reference:
echo $Reference
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo ReadFiles:
echo 1:
echo ${4}
echo 2:
echo ${5}

echo 3:
echo ${6}
echo 4:
echo ${7}

echo 5:
echo ${8}
echo 6:
echo ${9}

echo 7:
echo ${10}
echo 8:
echo ${11}

mkdir $WorkDir
zcat ${4} ${5} ${6} ${7} ${8} ${9} ${10} ${11} > $WorkDir/read.fq
ln -s $Reference $WorkDir/reference.fasta

cd $WorkDir
gzip read.fq
source package /nbi/software/testing/bin/bwa-0.7.15
source package 638df626-d658-40aa-80e5-14a275b7464b
bwa index reference.fasta

bwa mem -t 62 reference.fasta read.fq.gz > $OutFile.sam

samtools view -bS ${OutFile}.sam > ${OutFile}.bam

cp ${OutFile}.bam $OutDir/.
echo DONE
pwd
ls -lh

cd $CurPath
ProgDir=~/git_repos/Wrappers/NBI
sbatch $ProgDir/run_qualimap.sh ${OutDir}/${OutFile}.bam $Reference $OutDir 

echo qualimap submitted
rm -r $WorkDir
