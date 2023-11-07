#!/bin/bash
#SBATCH --job-name=mash
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 30G
#SBATCH -c 32
#SBATCH -p jic-medium,jic-long
#SBATCH --time=02-00:00:00



CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

ReadsFile=$1
OutDir=$2
Assembly1=$3
Assembly2=$4
Assembly3=$5
OutFile=$(basename $ReadsFile | sed 's@.fastq.gz@@g')

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo ReadsFile:
echo $ReadsFile
echo Assemblys:
echo $Assembly1
echo $Assembly2
echo $Assembly3
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo _
echo _

mkdir -p $WorkDir

ln -s $Assembly1 $WorkDir/.
ln -s $Assembly2 $WorkDir/.
ln -s $Assembly3 $WorkDir/.

cd $WorkDir

source package /nbi/software/testing/bin/mash-2.1

#sketch assemblies
mash sketch -p 32 -o genomes.msh *.fa

#sketch reads
mash sketch -r -m 2 $ReadsFile

#mash screen
mash screen -p 32 genomes.msh $ReadsFile > ${OutFile}_mashscreen.txt

cp ${OutFile}_mashscreen.txt ${OutDir}/.
rm ${ReadsFile}.msh

echo DONE
rm -r $WorkDir
