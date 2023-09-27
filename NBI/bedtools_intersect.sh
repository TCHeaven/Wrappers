#!/bin/bash
#SBATCH --job-name=bedtools
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 2G
#SBATCH -c 1
#SBATCH -p jic-short,nbi-short
#SBATCH --time=0-02:00:00

CurPath=$PWD
WorkDir=${PWD}${TMPDIR}_${SLURM_JOB_ID}

#Move to Working Directory
mkdir -p $WorkDir

cp $2 $WorkDir/gff.gff3
rm $2
cd $WorkDir
wc -l gff.gff3

    singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/pybed.simg bedtools intersect \
    -a $1 \
    -b gff.gff3 \
    -header > $3

echo DONE
rm -r $WorkDir