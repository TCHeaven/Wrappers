#!/bin/bash
#SBATCH --job-name=extract_gene_snps
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 10G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH -p jic-long
#SBATCH --time=1-0:00:00


#Collect inputs
CurPath=$PWD
WorkDir=${PWD}${TMPDIR}_${SLURM_JOB_ID}
InFile=$1
OutDir=$2
OutFile=$3
GffFile=$4

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo InFile:
echo $InFile
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo GffFile:
echo $GffFile

echo _
echo _


#Move to Working Directory
mkdir -p $WorkDir

if [[ $InFile == *.gz ]]; then
  gzip -cd "$InFile" > "$WorkDir/vcf.vcf"
else
  cp "$InFile" "$WorkDir/vcf.vcf"
fi

if [[ $GffFile == *.gz ]]; then
  gzip -cd "$GffFile" > "$WorkDir/gff.gff3"
else
  cp "$GffFile" "$WorkDir/gff.gff3"
fi

cd $WorkDir
mkdir OutFiles


#Execute programmes
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 /hpc-home/did23faz/git_repos/Scripts/NBI/extract_gene_snps.py vcf.vcf gff.gff3 OutFiles


#Collect Outputs
cd OutFiles
source package 01ef5a53-c149-4c9e-b07d-0b9a46176cc0
for file in *; do bgzip "$file"; done

cp * $OutDir/.
echo DONE
rm -r $WorkDir
