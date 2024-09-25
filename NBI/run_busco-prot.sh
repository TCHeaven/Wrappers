#!/bin/bash
#SBATCH --job-name=busco
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 32G
#SBATCH -c 32
#SBATCH -p jic-medium,jic-short,nbi-short,nbi-medium
#SBATCH --time=00-02:00:00

# #SBATCH -p jic-short
# #SBATCH --nodelist=j64n11,j64n12,j64n13,j64n14,j64n15,j64n16

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
Proteome=$1
Database=$2
OutDir=$3
OutFile=$4

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo Proteome:
echo $Proteome
echo Database:
echo $Database
echo _
echo _

mkdir -p $WorkDir
cp $Proteome $WorkDir/proteome.fa

cd $WorkDir
mkdir 1
#source package ad80b294-03bf-44cd-a1c2-1fc33efc411e

singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/busco_5.7.0.sif busco -i proteome.fa -l $Database -m prot -c 32 -f --tar --offline -o 1

cp 1/run*/short_summary.txt ${OutDir}/${OutFile}_short_summary.txt
echo DONE
rm -r $WorkDir
