#!/bin/bash
#SBATCH --job-name=faststructure
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 4G
#SBATCH --nodes=1
#SBATCH -c 1
#SBATCH -p nbi-long,jic-long
#SBATCH --time=30-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

InFile=$1
k=$2
n=$3
OutDir=$4
OutFile=$5

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo Input:
echo $InFile
echo K being tested:
echo $k
echo Number of replicate runs:
echo $n
echo _
echo _

### Prep
mkdir -p ${WorkDir}/faststructure_$k\_$n

cd ${WorkDir}/faststructure_${k}\_${n}

for ((i=1;i<=$n;i++))
do
    singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/faststructure_1.0.sif structure.py -K $k --input=$InFile --output=${OutFile}_k${k}_${i} #--format=str
done

cp -r ${WorkDir}/faststructure_${k}\_${n} $OutDir

echo DONE
