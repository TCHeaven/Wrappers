#!/bin/bash
#SBATCH --job-name=create_sample_sequence_files
#SBATCH -o logs/create_sample_sequence_files/slurm.%j.out
#SBATCH -e logs/create_sample_sequence_files/slurm.%j.err
#SBATCH --mem 8G
#SBATCH -c 4
#SBATCH --ntasks-per-node=1
#SBATCH -p jic-medium,nbi-medium
#SBATCH --time=2-00:00:00

CurPath=$PWD
#WorkDir=${TMPDIR}/${SLURM_JOB_ID}
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
InFile=$1
OutDir=$2
OutFile=$3
fasta=$4
gene_info=$5
Unique_ID=${SLURM_JOB_ID}

Genename=$(echo $OutFile | sed 's@.fa@@g' | sed 's@hom_@@g')

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
echo GeneName:
echo $Genename
echo Unique_ID:
echo $Unique_ID
echo _
echo _

mkdir -p $WorkDir

cp $InFile $WorkDir/vcf.vcf
grep -A 1 "$Genename" $fasta | cut -d ':' -f1 > $WorkDir/fasta.fa
grep "$Genename" $gene_info > $WorkDir/geneinfo.txt
cd $WorkDir

ls -lh $WorkDir

singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 /hpc-home/did23faz/git_repos/Scripts/NBI/create_sample_sequence_files.py geneinfo.txt vcf.vcf fasta.fa $Unique_ID .

for file in $(ls *${SLURM_JOB_ID}_REFERENCE.fasta); do
echo $file
header=$(echo $file | rev | cut -d '.' --complement -f1,2 | rev)
echo Header: $header
#echo '>'${header} >> $OutFile
cat $file >> ${SLURM_JOB_ID}_${OutFile}
#echo >> $OutFile
done

for file in $(ls *${SLURM_JOB_ID}_SAMPLE.fasta); do
echo $file
header=$(echo $file | rev | cut -d '_' --complement -f1,2 | rev)
echo Header: $header
#echo '>'${header} >> $OutFile
cat $file >> ${SLURM_JOB_ID}_$OutFile
#echo >> $OutFile
done

echo final contents:
ls

cp *${OutFile} $OutDir/.
echo DONE
rm -r $WorkDir

