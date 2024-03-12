#!/bin/bash
#SBATCH --job-name=paml
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 2G
#SBATCH -c 2
#SBATCH -p jic-medium,jic-long
#SBATCH --time=02-00:00:00

# Your job script here

# Assuming your executable supports OpenMP parallelization
export OMP_NUM_THREADS=1  # Set the number of threads per task

# Loop over tasks and run different jobs on each CPU
for ((i=0; i<2; i++))
do
    # Use srun to run commands on each CPU
    srun -n 1 -c 1 echo "Message $i on CPU $SLURM_LOCALID"
done

# Wait for all background jobs to finish
wait

