#!/bin/bash
#SBATCH --job-name=helixer
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --partition=jic-gpu
#SBATCH --gres=gpu:1
#SBATCH -N 1 
#SBATCH -n 1
#SBATCH --cpus-per-task=32
#SBATCH --mem-per-cpu=12G
#SBATCH --time=03-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
fasta=$1
model_filepath=$2
lineage=$3
species=$4
outfile=$5
outdir=$6

echo Genome:
echo $fasta
echo Model:
echo $model_filepath
echo Lineage:
echo $lineage
echo Species:
echo $species
echo OutFile:
echo $outfile
echo OutDir:
echo $outdir

echo __
echo __

mkdir -p $WorkDir

cd $WorkDir

if [ "$lineage" = "fungi" ]; then
  if [ -e "$model_filepath" ]; then
    echo "running with pre-downloaded model: $model_filepath"
    singularity exec --nv ~/helixer-docker_helixer_v0.3.2_cuda_11.8.0-cudnn8.sif Helixer.py --model-filepath $model_filepath --fasta-path $fasta --subsequence-length 21384 --overlap-offset 10692 --overlap-core-length 16038 --species $species --gff-output-path ${outfile}.gff
  else
    echo "pulling model for: $lineage"
    singularity exec --nv ~/helixer-docker_helixer_v0.3.2_cuda_11.8.0-cudnn8.sif Helixer.py --fasta-path $fasta --lineage fungi --subsequence-length 21384 --overlap-offset 10692 --overlap-core-length 16038 --species $species --gff-output-path ${outfile}.gff
  fi


elif [ "$lineage" = "invertebrate" ]; then
  if [ -e "$model_filepath" ]; then
    echo "running with pre-downloaded model: $model_filepath"
    singularity exec --nv ~/helixer-docker_helixer_v0.3.2_cuda_11.8.0-cudnn8.sif Helixer.py --model-filepath $model_filepath --fasta-path $fasta --subsequence-length 213840 --overlap-offset 106920 --overlap-core-length 160380 --species $species --gff-output-path ${outfile}.gff
  else
    echo "pulling model for: $lineage"
    singularity exec --nv ~/helixer-docker_helixer_v0.3.2_cuda_11.8.0-cudnn8.sif Helixer.py --fasta-path $fasta --lineage invertebrate --subsequence-length 213840 --overlap-offset 106920 --overlap-core-length 160380 --species $species --gff-output-path ${outfile}.gff
  fi


elif [ "$lineage" = "vertebrate" ]; then
  if [ -e "$model_filepath" ]; then
    echo "running with pre-downloaded model: $model_filepath"
    singularity exec --nv ~/helixer-docker_helixer_v0.3.2_cuda_11.8.0-cudnn8.sif Helixer.py --model-filepath $model_filepath --fasta-path $fasta --subsequence-length 213840 --overlap-offset 106920 --overlap-core-length 160380 --species $species --gff-output-path ${outfile}.gff
  else
    echo "pulling model for: $lineage"
    singularity exec --nv ~/helixer-docker_helixer_v0.3.2_cuda_11.8.0-cudnn8.sif Helixer.py --fasta-path $fasta --lineage vertebrate --subsequence-length 213840 --overlap-offset 106920 --overlap-core-length 160380 --species $species --gff-output-path ${outfile}.gff
  fi


elif [ "$lineage" = "land_plant" ]; then
  if [ -e "$model_filepath" ]; then
    echo "running with pre-downloaded model: $model_filepath"
    singularity exec --nv ~/helixer-docker_helixer_v0.3.2_cuda_11.8.0-cudnn8.sif Helixer.py --model-filepath $model_filepath --fasta-path $fasta --subsequence-length 21384 --overlap-offset 10692 --overlap-core-length 16038 --species $species --gff-output-path ${outfile}.gff
  else
    echo "pulling model for: $lineage"
    singularity exec --nv ~/helixer-docker_helixer_v0.3.2_cuda_11.8.0-cudnn8.sif Helixer.py --fasta-path $fasta --lineage land_plant --subsequence-length 21384 --overlap-offset 10692 --overlap-core-length 16038 --species $species --gff-output-path ${outfile}.gff
  fi

else
echo "lineage not recognised"
fi

tree

ls -lh

mv *.gff ${outdir}/.

echo DONE
