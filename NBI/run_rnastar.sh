#!/bin/bash
#SBATCH --job-name=star
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 50G
#SBATCH --nodes=1
#SBATCH -c 16
#SBATCH -p jic-medium,jic-long
#SBATCH --time=02-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
OutDir=$1
OutFile=$2
Fread=$3
Rread=$4
Reference=$5
GtfFile=$6
Stringency=$7
cpu=16

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo Reads:
echo $Fread
echo $Rread
echo Index Directory:
echo $IndexDir
echo GTF:
echo $GtfFile
echo Stringency:
echo $Stringency

echo _
echo _

mkdir -p $WorkDir

ln -s $Fread ${WorkDir}/F_1.fastq.gz
ln -s $Fread ${WorkDir}/R_2.fastq.gz
ln -s $GtfFile ${WorkDir}/gtf.gtf

cd $WorkDir
mkdir GenomeDir
source package 266730e5-6b24-4438-aecb-ab95f1940339

STAR --genomeDir $IndexDir \
--readFilesIn F_1.fastq.gz R_2.fastq.gz \
--outFileNamePrefix ${OutFile}_ \
--readFilesCommand zcat \
--runThreadN $cpu \
--genomeLoad NoSharedMemory \
--twopassMode Basic \
--sjdbGTFfile gtf.gtf \
--sjdbScore 2 \
--sjdbOverhang 150 \
--limitSjdbInsertNsj 1000000 \
--outFilterMultimapNmax 20 \
--alignSJoverhangMin 8 \
--alignSJDBoverhangMin 1 \
--outFilterMismatchNmax 999 \
--outFilterMismatchNoverReadLmax 0.04 \
--alignIntronMin 20 \
--alignIntronMax 1000000 \
--alignMatesGapMax 1000000 \
--outSAMunmapped Within \
--outFilterType BySJout \
--outSAMattributes NH HI AS NM MD \
--outSAMtype BAM SortedByCoordinate \
--quantMode TranscriptomeSAM GeneCounts \
--quantTranscriptomeBan $Stringency \
--limitBAMsortRAM 50000000000

tree
echo _
echo _
ls -lhtr

mv ${OutFile}_Aligned.sortedByCoord.out.bam ${OutDir}/.
mv ${OutFile}_Log.final.out ${OutDir}/.
mv ${OutFile}_Log.out ${OutDir}/.

echo DONE
rm -r $WorkDir
