#!/bin/bash
#SBATCH --job-name=EarlGreyTE
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 100G
#SBATCH --nodes=1
#SBATCH -c 32
#SBATCH -p jic-medium,jic-long,nbi-medium,nbi-long,RG-Saskia-Hogenhout
#SBATCH --time=02-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

Genome=$1
OutFile=$2
OutDir=$3
repeatmaskersearchterm=$4
cpu=32

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo Genome:
echo $Genome
echo Repeat Masker Search Term:
echo $repeatmaskersearchterm

echo __
echo __

#source package 14fbfadb-9fe7-419a-9f20-cd5f458c0fff
source /jic/software/staging/RCSUPPORT-3017/stagingloader 
#singularity shell -C -H $(pwd):/work --writable-tmpfs -u /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/earlgrey4.0.6.sif
#eval "$(/anaconda3/bin/conda shell.bash  hook)"
#conda env create -f /home/user/EarlGrey/earlGrey.yml
#conda activate earlGrey
#Rscript /home/user/EarlGrey/scripts/install_r_packages.R

if [[ -n $repeatmaskersearchterm && $repeatmaskersearchterm != 'NA' ]]; then
echo "y" | earlGrey -g $Genome -s $OutFile -o $OutDir -t $cpu -d yes -r $repeatmaskersearchterm
else
echo "y" | earlGrey -g $Genome -s $OutFile -o $OutDir -t $cpu -d yes 
fi

echo DONE

#singularity build --sandbox earlgrey earlgrey.sif
