#!/bin/bash
#SBATCH --job-name=create_sample_sequence_files
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 2G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH -p jic-short
#SBATCH --time=0-02:00:00

CurPath=$PWD
#WorkDir=${TMPDIR}/${SLURM_JOB_ID}
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
InFile=$1
OutDir=$2
OutFile=$3
fasta=$4
gene_info=$5

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
echo GeneInfoFile:
echo $gene_info
echo _
echo _

mkdir -p $WorkDir

cp $InFile $WorkDir/vcf.vcf
cp $fasta $WorkDir/fasta.fa
cp $gene_info $WorkDir/geneinfo.txt
cd $WorkDir

singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 /hpc-home/did23faz/git_repos/Scripts/NBI/create_sample_sequence_files_het.py geneinfo.txt vcf.vcf fasta.fa . 

touch het_${OutFile}
for file in $(ls *_REFERENCE.fasta); do
echo $file
header=$(echo $file | rev | cut -d '.' --complement -f1 | rev)
echo $header
#echo '>'${header} >> $OutFile
cat $file >> het_${OutFile}
#echo >> $OutFile
done
for file in $(ls *_SAMPLE.fasta); do
echo $file
header=$(echo $file | rev | cut -d '_' --complement -f1 | rev)
echo $header
#echo '>'${header} >> $OutFile
cat $file >> het_$OutFile
#echo >> $OutFile
done

cp *${OutFile} $OutDir/.
echo DONE
rm -r $WorkDir

