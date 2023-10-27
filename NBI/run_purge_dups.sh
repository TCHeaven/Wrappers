#!/bin/bash
#SBATCH --job-name=purge_dups
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 50G
#SBATCH -c 4
#SBATCH -p jic-medium, nbi-medium
#SBATCH --time=2-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

Assembly=$1
MappingFile=$2
Type=$3
OutDir=$4
OutFile=$5

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo Assembly:
echo $Assembly
echo Mapping File:
echo $MappingFile
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo _
echo _

mkdir -p $WorkDir

ln -s $Assembly $WorkDir/genome.fa
ln -s $MappingFile $WorkDir/bam.bam
cd $WorkDir

source package /tgac/software/testing/bin/htsbox-2.2
source package 42a2e141-dade-4497-b4ce-79d1191da721
source package 222eac79-310f-4d4b-8e1c-0cece4150333
source package /tgac/software/production/bin/abyss-1.3.5

htsbox samview -p bam.bam > bam.paf

if [[ $Type = "long" ]]; then
    echo $Type
    pbcstat bam.paf
elif [[ $Type = "short" ]]; then
    echo $Type
    ngscstat bam.paf
else
    echo "Type unknown"
fi

calcuts PB.stat > cutoffs
cat cutoffs

singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 ~/git_repos/Scripts/NBI/hist_plot.py -X 100 PB.stat PB.stat.hist.png

split_fa genome.fa > genome.fa.split
minimap2 -xasm5 -DP genome.fa.split genome.fa.split | gzip -c - > genome.fa.split.self.paf.gz

purge_dups -2 -T cutoffs -c PB.base.cov genome.fa.split.self.paf.gz > dups.bed 2> purge_dups.log

get_seqs dups.bed genome.fa

mv purged.fa ${OutFile}.fa
mv PB.stat.hist.png ${OutFile}.PB.stat.hist.png
mv hap.fa ${OutFile}.hap.fa
mv purge_dups.log ${OutFile}.purge_dups.log
abyss-fac ${OutFile}.fa > ${OutFile}.abyss_report.txt

mv ${OutFile}* ${OutDir}/.
echo DONE
rm -r $WorkDir
