#!/bin/bash
#SBATCH --job-name=blastx
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 350G
#SBATCH --nodes=1
#SBATCH -c 32
#SBATCH -p jic-short
#SBATCH --time=00-02:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
InFile=$1
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
echo Input:
echo $InFile
echo Database:
echo $Database
echo _
echo _

mkdir -p $WorkDir
ln -s $InFile $WorkDir/InFile.fa

cd $WorkDir
#source package d6092385-3a81-49d9-b044-8ffb85d0c446 #v2.9.0
source package /nbi/software/testing/bin/blast+-2.12.0 #v2.12.0

#singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/blast2.9.0.sif blastn \
blastx \
-task blastx \
-query InFile.fa \
-db $Database \
-outfmt '6 qseqid staxids bitscore std' \
-max_target_seqs 10 \
-max_hsps 1 \
-num_threads 32 \
-evalue 1e-25 \
-out ${OutFile}.vs.faa.mts1.hsp1.1e25.megablast.out

#mkdir ${OutDir}
cp ${OutFile}* ${OutDir}/.
echo DONE
rm -r $WorkDir
