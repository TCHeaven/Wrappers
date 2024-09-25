#!/bin/bash
#SBATCH --job-name=minimap
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 50G
#SBATCH --nodes=1
#SBATCH -c 32
#SBATCH -p jic-medium,nbi-medium
#SBATCH --time=2-00:00:00

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

mkdir $WorkDir
ln -s ${4} $WorkDir/read1.fq.gz
ln -s ${5} $WorkDir/read2.fq.gz
ln -s $Reference $WorkDir/reference.fasta

cd $WorkDir
source package /tgac/software/testing/bin/minimap2-2.24
if [ -n "$5" ]; then
minimap2 -ax map-hifi reference.fasta read1.fq.gz read2.fq.gz > aln.sam
else
minimap2 -ax map-hifi reference.fasta read1.fq.gz > aln.sam
fi

source package 638df626-d658-40aa-80e5-14a275b7464b
samtools view -bS aln.sam > ${OutFile}.bam

cp ${OutFile}.bam $OutDir/.
echo minimap DONE

cd $CurPath
ProgDir=~/git_repos/Wrappers/NBI
sbatch $ProgDir/run_qualimap.sh ${OutDir}/${OutFile}.bam $Reference $OutDir 

echo qualimap submitted
rm -r $WorkDir
