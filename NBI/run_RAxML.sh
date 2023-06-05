#!/bin/bash
#SBATCH --job-name=RAxML
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem-per-cpu=2G
#SBATCH --cpus-per-task=1
#SBATCH -p jic-long
#SBATCH --time=30-00:00

#Collect inputs
CurPath=$PWD
#WorkDir=${TMPDIR}/${SLURM_JOB_ID}
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
InFile=$1
OutDir=$2
OutFile=$3

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo vcfFile:
echo $InFile
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo _
echo _

mkdir $OutDir

#Move to working directory
mkdir -p $WorkDir
cp $InFile $WorkDir/alignment.fa
cd $WorkDir

#Execute program
#source package 7b014e53-984f-4a0d-8b31-13d189fef2fd
#raxml-ng --force --all --msa alignment.fa --bs-trees 200 --model GTR+G --prefix $OutFile --threads 8

source package /nbi/software/production/bin/raxml-7.2.6
raxmlHPC -m GTR -s alignment.fa -n $OutFile -b 200 

#Collect results
cp ${OutFile}* $OutDir/.
#rm -r $WorkDir
echo DONE

