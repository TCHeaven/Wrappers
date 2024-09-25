#!/bin/bash
#SBATCH --job-name=fastortho
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 32G
#SBATCH -c 32
#SBATCH -p jic-long,nbi-long
#SBATCH --time=14-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
OutDir=$1
OutFile=$2
Fasta=$3
Evalue=$4
cpu=32

echo OutDir: $OutDir
echo OutFile: $OutFile
echo Fasta: $fasta
echo Evalue: $Evalue

echo __
echo __

mkdir $WorkDir
ln -s $Fasta $WorkDir/fasta.fasta

cd $WorkDir
source /hpc-home/did23faz/mamba/bin/activate fastortho

FastOrtho --pv_cutoff $Evalue --inflation 1.5 --blast_cpus $cpu --project_name $OutFile --working_directory . --mixed_genome_fasta fasta.fasta

tree

cp *.end $OutDir/.
cp *.ocl $OutDir/.
cp *.mtx $OutDir/.
cp *.idx $OutDir/.

rm -rf $WorkDir