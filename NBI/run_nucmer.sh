#!/bin/bash
#SBATCH --job-name=nucmer
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 64G
#SBATCH -c 32
#SBATCH -p jic-short
#SBATCH --time=00-02:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
Reference=$1
Query=$2
OutDir=$3
OutFile=$4

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo Reference:
echo $Reference
echo Query:
echo $Query
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo _
echo _

mkdir -p $WorkDir

ln -s $Reference $WorkDir/reference.fa
ln -s $Query $WorkDir/query.fa

cd $WorkDir

source package 70b0e328-5a66-4c7c-971b-b2face8a50d4
source package 09b2c824-1ef0-4879-b4d2-0a04ee1bbd6d

nucmer  -p $OutFile  reference.fa  query.fa
show-coords -T ${OutFile}.delta > ${OutFile}.coords
#mummerplot -l ${OutFile}.delta
awk 'NR > 4 {print $1 "\t" $2-1}' ${OutFile}.coords > ${OutFile}.bed

ls -lh

mv out.* ${OutDir}/.
mv ${OutFile}.delta ${OutDir}/.
mv ${OutFile}.coords ${OutDir}/.
mv ${OutFile}.bed ${OutDir}/.
#rm -r $WorkDir

echo DONE
