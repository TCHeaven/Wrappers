#!/bin/bash
#SBATCH --job-name=blastn
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 500G
#SBATCH --nodes=1
#SBATCH -c 32
#SBATCH -p nbi-medium,jic-medium,nbi-long,jic-long
#SBATCH --time=02-00:00:00

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
#source package /nbi/software/testing/bin/blast+-2.12.0 #v2.12.0

singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/blast2.7.1.sif blastn \
-task megablast \
-query InFile.fa \
-db $Database \
-outfmt '6 qseqid staxids bitscore std' \
-max_target_seqs 10 \
-max_hsps 1 \
-num_threads 32 \
-evalue 1e-25 \
-out ${OutFile}.vs.nt.mts1.hsp1.1e25.megablast.out

#mkdir ${OutDir}
cp ${OutFile}* ${OutDir}/.
echo DONE
rm -r $WorkDir
