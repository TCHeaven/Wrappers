#!/bin/bash
#SBATCH --job-name=create_sample_sequence_files
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 60G
#SBATCH -c 1
#SBATCH -p jic-long,nbi-long
#SBATCH --time=30-00:00:00

CurPath=$PWD
#WorkDir=${TMPDIR}/${SLURM_JOB_ID}
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
InFile=$1
OutDir=$2
OutFile=$3
fasta=$4

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
echo fastaFile:
echo $fasta
echo _
echo _

mkdir -p $WorkDir
mkdir ${OutDir}/hom
mkdir ${OutDir}/het

#cp $InFile $WorkDir/vcf.vcf.gz
#cp $fasta $WorkDir/fasta.fa
#cd $WorkDir

#(zgrep "^#" vcf.vcf.gz; zgrep -v "^#" vcf.vcf.gz | sort -k1,1 -k2,2n) | gzip > sorted.vcf.gz
#singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 /hpc-home/did23faz/git_repos/Scripts/NBI/create_sample_sequences.py sorted.vcf.gz fasta.fa $OutDir/hom
#singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 /hpc-home/did23faz/git_repos/Scripts/NBI/create_sample_sequences_het.py sorted.vcf.gz fasta.fa $OutDir/het 

#NOTE
#Python scripts were initially written the handle the whole genome and vcf at once, however this uses too much memory therefore the .fa and .vcf files are provided one scaffold at a time and then outputs re-concatenated:

cp $InFile $WorkDir/vcf.vcf.gz
awk '/^>/ {printf("%s%s\t",(N>0?"\n":""),$0);N++;next;} {printf("%s",$0);} END {printf("\n");}' < $fasta > $WorkDir/fasta.fa
cd $WorkDir

source package 01ef5a53-c149-4c9e-b07d-0b9a46176cc0
(zgrep "^#" vcf.vcf.gz; zgrep -v "^#" vcf.vcf.gz | sort -k1,1 -k2,2n) | gzip > sorted.vcf.gz
rm vcf.vcf.gz

cat fasta.fa | while IFS= read -r line; do
  entry=$line
  scaffold_name=$(echo $entry | cut -d ' ' -f1 | sed 's@>@@g')
  echo $scaffold_name
  zcat sorted.vcf.gz | grep '#' > ${scaffold_name}.vcf
  zcat sorted.vcf.gz | grep -v '#' | grep -w "$scaffold_name" >> ${scaffold_name}.vcf
  bgzip ${scaffold_name}.vcf
  echo \>${scaffold_name} > ${scaffold_name}.fa
  echo $entry | cut -d ' ' -f2 >> ${scaffold_name}.fa
  mkdir ${OutDir}/hom/${scaffold_name}
  singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 /hpc-home/did23faz/git_repos/Scripts/NBI/create_sample_sequences.py ${scaffold_name}.vcf.gz ${scaffold_name}.fa ${OutDir}/hom/${scaffold_name}
  mkdir ${OutDir}/het/${scaffold_name}
  singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 /hpc-home/did23faz/git_repos/Scripts/NBI/create_sample_sequences_het.py ${scaffold_name}.vcf.gz ${scaffold_name}.fa ${OutDir}/het/${scaffold_name}
done

#for file in $(ls ${OutDir}/hom/${scaffold_name}/*); do
#sample_name=$(rev $file | cut -d '/' -f1 | rev | cut -d '_' -f1)
#cat ${OutDir}/hom/*/${sample_name}_hom.fasta > ${OutDir}/hom/${sample_name}_hom.fasta
#done

#find ${OutDir}/hom -type d -exec rmdir {} \;

#for file in $(ls ${OutDir}/het/${scaffold_name}/*); do
#sample_name=$(rev $file | cut -d '/' -f1 | rev | cut -d '_' -f1)
#cat ${OutDir}/het/*/${sample_name}_het.fasta > ${OutDir}/het/${sample_name}_het.fasta
#done

#find ${OutDir}/het -type d -exec rmdir {} \;

echo DONE
rm -r $WorkDir

