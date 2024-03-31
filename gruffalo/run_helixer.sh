#!/bin/bash
#SBATCH --job-name=helixer
#SBATCH --partition=gpu
#SBATCH --gpus=1
#SBATCH --c 32
#SBATCH --mem-per-cpu=6G
#SBATCH --time=03-00:00:00

WorkDir=$TMPDIR/${SLURM_JOB_USER}_${SLURM_JOBID}
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
conda activate tensorflow-gpu-env

if [ "$lineage" = "fungi" ]; then
  if [ -e "$model_filepath" ]; then
    echo "running with pre-downloaded model: $model_filepath"
    singularity run --nv /home/theaven/scratch/apps/helixer/helixer-docker_helixer_v0.3.2_cuda_11.8.0-cudnn8.sif Helixer.py --model-filepath $model_filepath --fasta-path $fasta --subsequence-length 21384 --overlap-offset 10692 --overlap-core-length 16038 --species $species --gff-output-path ${outfile}.gff
  else
    echo "pulling model for: $lineage"
    singularity run --nv /home/theaven/scratch/apps/helixer/helixer-docker_helixer_v0.3.2_cuda_11.8.0-cudnn8.sif Helixer.py --fasta-path $fasta --lineage fungi --subsequence-length 21384 --overlap-offset 10692 --overlap-core-length 16038 --species $species --gff-output-path ${outfile}.gff
  fi


elif [ "$lineage" = "invertebrate" ]; then
  if [ -e "$model_filepath" ]; then
    echo "running with pre-downloaded model: $model_filepath"
    singularity run --nv /home/theaven/scratch/apps/helixer/helixer-docker_helixer_v0.3.2_cuda_11.8.0-cudnn8.sif Helixer.py --model-filepath $model_filepath --fasta-path $fasta --subsequence-length 213840 --overlap-offset 106920 --overlap-core-length 160380 --species $species --gff-output-path ${outfile}.gff
  else
    echo "pulling model for: $lineage"
    singularity run --nv /home/theaven/scratch/apps/helixer/helixer-docker_helixer_v0.3.2_cuda_11.8.0-cudnn8.sif Helixer.py --fasta-path $fasta --lineage invertebrate --subsequence-length 213840 --overlap-offset 106920 --overlap-core-length 160380 --species $species --gff-output-path ${outfile}.gff
  fi


elif [ "$lineage" = "vertebrate" ]; then
  if [ -e "$model_filepath" ]; then
    echo "running with pre-downloaded model: $model_filepath"
    singularity run --nv /home/theaven/scratch/apps/helixer/helixer-docker_helixer_v0.3.2_cuda_11.8.0-cudnn8.sif Helixer.py --model-filepath $model_filepath --fasta-path $fasta --subsequence-length 213840 --overlap-offset 106920 --overlap-core-length 160380 --species $species --gff-output-path ${outfile}.gff
  else
    echo "pulling model for: $lineage"
    singularity run --nv /home/theaven/scratch/apps/helixer/helixer-docker_helixer_v0.3.2_cuda_11.8.0-cudnn8.sif Helixer.py --fasta-path $fasta --lineage vertebrate --subsequence-length 213840 --overlap-offset 106920 --overlap-core-length 160380 --species $species --gff-output-path ${outfile}.gff
  fi


elif [ "$lineage" = "land_plant" ]; then
  if [ -e "$model_filepath" ]; then
    echo "running with pre-downloaded model: $model_filepath"
    singularity run --nv /home/theaven/scratch/apps/helixer/helixer-docker_helixer_v0.3.2_cuda_11.8.0-cudnn8.sif Helixer.py --model-filepath $model_filepath --fasta-path $fasta --subsequence-length 21384 --overlap-offset 10692 --overlap-core-length 16038 --species $species --gff-output-path ${outfile}.gff
  else
    echo "pulling model for: $lineage"
    singularity run --nv /home/theaven/scratch/apps/helixer/helixer-docker_helixer_v0.3.2_cuda_11.8.0-cudnn8.sif Helixer.py --fasta-path $fasta --lineage land_plant --subsequence-length 21384 --overlap-offset 10692 --overlap-core-length 16038 --species $species --gff-output-path ${outfile}.gff
  fi

else
echo "lineage not recognised"
fi

tree

ls -lh

conda deactivate
echo DONE
