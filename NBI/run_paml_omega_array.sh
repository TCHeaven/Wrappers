#!/bin/bash
#SBATCH --job-name=paml
#SBATCH -o slurm.%A_%a.out
#SBATCH -e slurm.%A_%a.err
#SBATCH --mem 2G
#SBATCH -c 1
#SBATCH -p jic-medium,jic-long
#SBATCH --time=02-00:00:00
#SBATCH --array=0-1000%190

FILES=(`cat $1`)
FILENAME=${FILES[$SLURM_ARRAY_TASK_ID]}

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}_${SLURM_ARRAY_TASK_ID}

Seqfile=$(echo $FILES)
TreeFile=$(dirname $Seqfile)/RAxML/$(basename $Seqfile | sed 's@.fa@@g')/$(basename $Seqfile | sed 's@.fa@@g').raxml.bestTree
OutDir=$(dirname $TreeFile)/paml
OutFile=$(basename $Seqfile | sed 's@_CDS-.fa@@' | sed 's@_CDS+.fa@@').out


if [ ! -e "${OutDir}/${OutFile}" ] || [ ! -s "${OutDir}/${OutFile}" ]; then

echo $TreeFile >> $2
echo Submitted batch job %A_%a >> $2

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo Seqfile:
echo $Seqfile
echo TreeFile:
echo $TreeFile
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo _
echo _

mkdir -p $WorkDir
ln -s $TreeFile $WorkDir/phylogenetic_tree.newick
ln -s $Seqfile $WorkDir/alignment.fasta

cd $WorkDir

source package ade453e1-535b-4ca8-bf5e-5d481e6ffcd5

echo seqfile = alignment.fasta > codeml.ctl
echo treefile = phylogenetic_tree.newick >> codeml.ctl
echo outfile = results.out >> codeml.ctl
echo noisy = 0 >> codeml.ctl
echo verbose = 0 >> codeml.ctl
echo runmode = 0 >> codeml.ctl
echo seqtype = 1 >> codeml.ctl
echo CodonFreq = 2 >> codeml.ctl
echo clock = 0 >> codeml.ctl
echo model = 0 >> codeml.ctl
echo NSsites = 0 >> codeml.ctl
echo icode = 0 >> codeml.ctl
echo fix_kappa = 0 >> codeml.ctl
echo kappa = 2 >> codeml.ctl
echo fix_omega = 0 >> codeml.ctl
echo omega = 0.4 >> codeml.ctl
echo ncatG = 8 >> codeml.ctl

codeml codeml.ctl 2>&1 >> stop.txt

mkdir -p ${OutDir}
cp results.out ${OutDir}/${OutFile}
cp stop.txt ${OutDir}/${OutFile}_stop.txt

echo DONE
rm -r $WorkDir

else

echo Already run for ${OutFile}

fi	