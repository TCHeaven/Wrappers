#!/bin/bash
#SBATCH --job-name=genmap
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 100G
#SBATCH --nodes=1
#SBATCH -c 16
#SBATCH -p jic-medium,jic-long
#SBATCH --time=2-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
OutDir=$1
OutFile=$2
reference=$3
Repeats=$4
VCF=$5
cpu=16

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo Reference:
echo $reference
echo Repeats:
echo $Repeats
echo VCF file:
echo $VCF
echo _
echo _

mkdir -p $WorkDir

ln -s $reference ${WorkDir}/genome.fa
ln -s $Repeats ${WorkDir}/repeats.fa.out
ln -s $VCF ${WorkDir}/vcf.vcf.gz

cd $WorkDir

source package 4028d6e4-21a8-45ec-8545-90e4ed7e1a64
source package 638df626-d658-40aa-80e5-14a275b7464b
source package /tgac/software/testing/bin/bcftools-1.10.2

######################################################################################
#Get mappability of reference
GEM=~/git_repos/Scripts/NBI/GEM-binaries-Linux-x86_64-core_i3-20130406-045632/bin

#$GEM/gem-indexer -T $cpu -c dna -i genome.fa -o reference.gem.index
#$GEM/gem-mappability -T $cpu -I reference.gem.index.gem -l 150 -m 0.04 -o reference.gem.150_004
#$GEM/gem-2-wig -I reference.gem.index -i reference.gem.150_004.mappability -o reference.gem.150_004

singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/genmap1.3.0.sif genmap index -F genome.fa -I index -v
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/genmap1.3.0.sif genmap map -T $cpu -K 100 -E 2 -I index -O . -t -w -bg -v

#cat reference.gem.150_004.wig | cut -f 1,7 -d " " >  reference.gem.150_004.fixed.wig
/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/bedops2.4.41.sif wig2bed < genome.genmap.wig > reference.genmap.wig.bed

#retain only uniquely mapping positions
cat reference.genmap.wig.bed | awk '{if ($5==1)print $0}' > reference.genmap.unique.wig.bed

awk '{print $1,$2,$3}' reference.genmap.unique.wig.bed > reference.genmap.filt.bed
sed 's@ @\t@g' reference.genmap.filt.bed > reference.genmap.filt.tab.bed

#Convert repeatmasker output to bed
awk 'BEGIN{OFS="\t"}{if(NR>3) {if($9=="C"){strand="-"}else{strand="+"};print $5,$6-1,$7,$10,".",strand}}' repeats.fa.out > reference.masked.out.bed
awk '{print $1,$2,$3}' reference.masked.out.bed > reference.masked.filt.out.bed
sed 's@ @\t@g' reference.masked.filt.out.bed > reference.masked.filt.tab.out.bed

#######################################################################################
#Make a VCF with only callable sites (mappability + masked)
#Generate a BED file with all sites in the VCF
bedtools merge -i vcf.vcf.gz > vcf.bed

#Filter the BED file for masked and mappable regions + generate a BED file with callable regions
bedtools intersect -a vcf.bed -b reference.genmap.filt.tab.bed > reference.mappable.bed
bedtools subtract -a reference.mappable.bed -b reference.masked.filt.tab.out.bed > reference.callable.bed
echo "Mappable bases (genmap):"
cat reference.genmap.filt.tab.bed | awk -F'\t' 'BEGIN{SUM=0}{SUM+=$3-$2}END{print SUM}'
echo "Masked bases (repeatmodeler):"
cat reference.masked.filt.tab.out.bed | awk -F'\t' 'BEGIN{SUM=0}{SUM+=$3-$2}END{print SUM}'
echo "callable (overlap of VCF and mappable genmap regions, minus repeatmodeler masked regions):"
cat reference.callable.bed | awk -F'\t' 'BEGIN{SUM=0}{SUM+=$3-$2}END{print SUM}'

#Filter VCF using BED file 'callable'
bedtools intersect -header -a vcf.vcf.gz -b reference.callable.bed > ${OutFile}.callable.vcf
bgzip -c ${OutFile}.callable.vcf > ${OutFile}.callable.vcf.gz
tabix -p vcf ${OutFile}.callable.vcf.gz

echo ${OutFile}.callable.vcf.gz length:
bcftools query -l ${OutFile}.callable.vcf.gz | wc -l
echo ${OutFile}.callable.vcf.gz samples:
bcftools query -l ${OutFile}.callable.vcf.gz

tree
echo _
echo _
ls -lh

mkdir -p $OutDir
mv ${OutFile}.callable.vcf.gz ${OutDir}/${OutFile}_callable.vcf.gz
mv genome.genmap.bedgraph ${OutDir}/${OutFile}_genmap.bedgraph

echo DONE
#rm -r $WorkDir