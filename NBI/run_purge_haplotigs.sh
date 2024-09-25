#!/bin/bash
#SBATCH --job-name=purge_haplotigs
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 50G
#SBATCH -c 64
#SBATCH -p jic-medium,jic-long,RG-Saskia-Hogenhout
#SBATCH --time=2-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

Assembly=$1
AssemblyIndex=$2
MappingFile=$3
MappingIndex=$4
low=$5
mid=$6
high=$7
diploid_cuttoff=$8
junk_cuttoff=$9
hap_percent_cuttoff=${10}
rep_percent_cuttoff=${11}
OutDir=${12}
OutFile=${13}

cpu=64

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo Assembly:
echo $Assembly
echo AssemblyIndex:
echo $AssemblyIndex
echo Mapping File:
echo $MappingFile
echo Mapping index File:
echo $MappingIndex
echo Lower cuttoff for read coverage:
echo $low
echo Mid point coverage between Het and Homozygous peaks:
echo $mid
echo Upper cuttoff for read coverage:
echo $high
echo "Auto-assign contig as s (suspected haplotig) if contig is diploid level of coverage:"
echo $diploid_cuttoff
echo "Auto-assign contig as j (junk) if this percentage or greater of the contig is low/high coverage:"
echo $junk_cuttoff
echo Percent cutoff for identifying a contig as a haplotig:
echo $hap_percent_cuttoff 
echo Percent cutoff for identifying repetitive contigs:
echo $rep_percent_cuttoff 
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo _
echo _

mkdir -p $WorkDir

ln -s $Assembly $WorkDir/genome.fa
ln -s $AssemblyIndex $WorkDir/genome.fa.fai
ln -s $MappingFile $WorkDir/bam.bam
ln -s $MappingIndex $WorkDir/bam.bam.bai
cd $WorkDir

#source /nbi/software/staging/RCSUPPORT-2652/stagingloader
source package 0567474a-7a7f-40c6-9f91-6272b934f8a4
source package 222eac79-310f-4d4b-8e1c-0cece4150333
source package /tgac/software/production/bin/abyss-1.3.5

purge_haplotigs hist -b bam.bam -g genome.fa -t $cpu

purge_haplotigs cov -i bam.bam.gencov -l $low -m $mid -h $high -o ${OutFile}_coverage_stats.csv -j $junk_cuttoff -s $diploid_cuttoff

purge_haplotigs purge -g genome.fa -c ${OutFile}_coverage_stats.csv -t $cpu -o ${OutFile}_curated -d -b bam.bam -a $hap_percent_cuttoff -m $rep_percent_cuttoff 

purge_haplotigs  clip  -p ${OutFile}_curated.fasta  -h ${OutFile}_curated.haplotigs.fasta -o ${OutFile}_clip -t $cpu

purge_haplotigs  place  -p ${OutFile}_curated.fasta  -h ${OutFile}_curated.haplotigs.fasta -o ${OutFile}_out.tsv -t $cpu -falconNaming

abyss-fac ${OutFile}_curated.fasta > ${OutFile}_curated.abyss_report.txt

echo DONE
ls -lh
cp ${OutFile}* ${OutDir}/.
cp -r dotplots_reassigned_contigs ${OutDir}/${OutFile}_dotplots_reassigned_contigs
cp -r dotplots_unassigned_contigs ${OutDir}/${OutFile}_dotplots_unassigned_contigs
cp bam.bam.histogram.png ${OutDir}/${OutFile}.histogram
rm -r $WorkDir
