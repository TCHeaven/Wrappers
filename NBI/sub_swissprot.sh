#!/bin/bash
#SBATCH --job-name=swissprot
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 1G
#SBATCH -c 8
#SBATCH -p jic-medium,nbi-medium,jic-long,nbi-long
#SBATCH --time=2-00:00:00

 #  This script performs blast searches against a database of swissprot genes
 # to determine homology between predicted gene models and previosuly
 # charcaterised gene models.

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

Proteome=$1
OutDir=$2
SwissDB_Dir=$3
SwissDB_Name=$4

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir

echo "Query Proteins: $Proteome"
echo "Output directory: $OutDir"
echo "Using Swissprot database from directory: $SwissDB_Dir"
echo "The basename for this database is: $SwissDB_Name"

echo _
echo _

mkdir -p $WorkDir
cd $WorkDir


ln -s $Proteome proteins.fa
mkdir -p $WorkDir/db
cp -r $SwissDB_Dir/* db/.

source package d6092385-3a81-49d9-b044-8ffb85d0c446

blastp \
  -db db/$SwissDB_Name \
  -query proteins.fa \
  -out swissprot_hits.tbl \
  -evalue 1e-100 \
  -outfmt 6 \
  -num_threads 8 \
  -num_alignments 10


singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 ~/git_repos/Scripts/NBI/swissprot_parser.py --blast_tbl swissprot_hits.tbl --blast_db_fasta db/"$SwissDB_Name".fasta > swissprot_tophit_parsed.tbl

cp -r $WorkDir/swissprot_vSept2019_10_hits.tbl $OutDir/.
cp -r $WorkDir/swissprot_vSept2019_tophit_parsed.tbl $OutDir/.
rm -r $WorkDir
