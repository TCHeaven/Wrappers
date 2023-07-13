#!/bin/bash
#SBATCH --job-name=create_mutant_CDS
#SBATCH -o logs/splice_CDS/slurm.%j.out
#SBATCH -e logs/splice_CDS/slurm.%j.err
#SBATCH --mem 4G
#SBATCH -c 1
#SBATCH -p jic-short, nbi-short
#SBATCH --time=0-02:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

gene_multifasta=$1
gff=$2
genename=$3
OutDir=$4
OutFile=$5

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile

echo Mulifasta:
echo $gene_multifasta
echo Gff:
echo $gff
echo GeneName:
echo $genename
echo _
echo _

mkdir -p $WorkDir

cp $gene_multifasta ${WorkDir}/multifasta.fa
grep "ID=$(echo $genename | cut -d '.' -f1,2);" $gff > ${WorkDir}/gff.gff
grep "$genename" $gff >> ${WorkDir}/gff.gff

cd $WorkDir

singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 /hpc-home/did23faz/git_repos/Scripts/NBI/splice_CDS.py multifasta.fa gff.gff $OutFile

cp $OutFile ${OutDir}/${OutFile}
echo DONE
rm -r $WorkDir
