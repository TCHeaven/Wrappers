#!/bin/bash
#SBATCH --job-name=kraken
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 4000G
#SBATCH --nodes=1
#SBATCH -c 64
#SBATCH -p jic-largemem
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
source package /nbi/software/testing/bin/kraken2-2.1.2

singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/kraken2.1.3.sif kraken2 \
--db $Database \
--threads 64 \
--output $WorkDir/${OutFile}_output.txt \
--unclassified-out $WorkDir/${OutFile}_unclassified-out.txt \
--classified-out $WorkDir/${OutFile}_classified-out.txt \
--report $WorkDir/${OutFile}_report.txt \
--use-names \
$WorkDir/InFile.fa

#mkdir ${OutDir}
cp ${OutFile}* ${OutDir}/.
echo DONE
rm -r $WorkDir
