#!/bin/bash
#SBATCH --job-name=break10x
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 50G
#SBATCH -c 32
#SBATCH -p jic-medium
#SBATCH --time=02-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

Assembly=$1
ReadDir=$2
OutDir=$3
OutFile=$4


echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo Assembly:
echo $Assembly
echo ReadDir:
echo $ReadDir
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo _
echo _

mkdir -p $WorkDir

cp -s $Assembly $WorkDir/genome.fa
cd $WorkDir

#source /nbi/software/staging/RCSUPPORT-2569/stagingloader
source package 19ae21f4-7ab2-49b6-b532-f50d560d6544
source package /tgac/software/production/bin/abyss-1.3.5

for Read in $(find $ReadDir/ -name "*.fastq.gz" -exec readlink -f {} \; | sort); do
if [ $(basename $Read | grep '_R1_') ]; then
echo "q1=$Read" >> input.dat
elif [ $(basename $Read | grep '_R2_') ]; then
echo "q2=$Read" >> input.dat
else
echo error
fi
done

scaff_reads -nodes 32  input.dat genome-BC_1.fastq.gz genome-BC_2.fastq.gz  
 
break10x -nodes 32  genome.fa  genome-BC_1.fastq.gz genome-BC_2.fastq.gz scaffolds-break.fasta scaffolds-break.name	     

cp scaffolds-break.fasta ${OutDir}/${OutFile}_break.fa
cp scaffolds-break.name ${OutDir}/${OutFile}_scaffolds-break.name

abyss-fac ${OutDir}/${OutFile}_break.fa > ${OutDir}/abyss_report.txt


echo DONE
rm -r $WorkDir
