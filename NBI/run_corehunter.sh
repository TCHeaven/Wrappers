#!/bin/bash
#SBATCH --job-name=corehunter
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 60G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH -p jic-training
#SBATCH --time=0-02:00

CurPath=$PWD
WorkDir=${TMPDIR}/${SLURM_JOB_ID}
InFile=$1
OutDir=$3
OutFile=$4
BASE=$2

echo $CurPath
echo $WorkDir
echo $InFile
echo $OutDir
echo $OutFile
echo $BASE

mkdir -p $WorkDir
cp $InFile $WorkDir/p_dis.csv
cd $WorkDir


# on dmatrix
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/corehunter.cif  Rscript /hpc-home/did23faz/git_repos/Scripts/NBI/corehunter.R $OutFile $BASE

cp $OutFile  $OutDir/.
echo DONE
rm -r $WorkDir
