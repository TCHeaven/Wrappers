#!/bin/bash
#SBATCH --job-name=HiFiAdapterFilt
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 10G
#SBATCH --nodes=1
#SBATCH -c 4
#SBATCH -p jic-medium,nbi-medium
#SBATCH --time=02-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
InFile=$1
OutDir=$2
OutFile=$3

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo InFile:
echo $InFile
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile

echo _
echo _

mkdir -p $WorkDir

ln -s $InFile $WorkDir/${OutFile}.fq.gz

cd $WorkDir

source /nbi/software/staging/RCSUPPORT-2560/stagingloader

pbadapterfilt.sh -p ${OutFile} -t 4 -o $OutDir

echo DONE
rm -r $WorkDir

