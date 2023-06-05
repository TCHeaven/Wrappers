#!/bin/bash
#SBATCH --job-name=IQtree
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
source package 358771a3-b1e5-4282-abaf-0c11915fce60
source package /nbi/software/production/bin/openmpi-1.6.3
#source package /tgac/software/production/bin/iqtree-1.6.10
iqtree -s alignment.fa -m GTR+P+FO -bb 10000


#Collect results
cp ${OutFile}* $OutDir/.
#rm -r $WorkDir
echo DONE

