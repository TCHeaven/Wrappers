#!/bin/bash
#SBATCH --job-name=RAxML
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem-per-cpu=5G
#SBATCH --cpus-per-task=1
#SBATCH -p jic-long
#SBATCH --time=30-00:00

#Collect inputs
CurPath=$PWD
#WorkDir=${TMPDIR}/${SLURM_JOB_ID}
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
InFile=$1
OutDir=$2
OutFile=$3

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo MSA:
echo $InFile
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo _
echo _

mkdir $OutDir

#Move to working directory
mkdir -p $WorkDir
cp $InFile $WorkDir/msa.fa
cd $WorkDir
#sed -i 's@MYZPE13164_O_EIv2.1_@@g' msa.fa
#sed -i 's@_CDS@@g' msa.fa
#sed -i 's@_@@g' msa.fa

#Execute program
source package 7b014e53-984f-4a0d-8b31-13d189fef2fd
#raxml-ng --all --msa msa.fa --msa-format FASTA --model GTR+G --tree pars{10} --bs-trees 200 --log debug
#raxml-ng --msa msa.fa --model GTR+G --prefix T5 --threads 2 --seed 2 --tree pars{25},rand{25}
#raxml-ng --bootstrap --msa msa.fa --model GTR+G --prefix T8 --seed 2 --threads 2 --bs-trees 1000
#raxml-ng --bsconverge --bs-trees T8.raxml.bootstraps --prefix T10 --seed 2 --threads 2  --bs-cutoff 0.03
#raxml-ng --support --tree T5.raxml.bestTree --bs-trees T8.raxml.bootstraps --prefix T12 --threads 2 
#raxml-ng --support --tree T5.raxml.bestTree --bs-trees T8.raxml.bootstraps --prefix T14 --threads 2 --bs-metric tbe
#source package /nbi/software/production/bin/raxml-7.2.6
#raxmlHPC -m GTRGAMMA -s msa.fa -n $OutFile -b 1234 -N 200 
raxml-ng --all --msa msa.fa --model GTR+G --prefix $OutFile --seed 1234 --threads 1 --bs-cutoff 0.03 --bs-metric fbp,tbe

raxml-ng --evaluate --msa msa.fa --threads 1 --model JC --tree ${OutFile}.raxml.bestTree --prefix JC
raxml-ng --evaluate --msa msa.fa --threads 1 --model JC+G --tree ${OutFile}.raxml.bestTree --prefix JC+G
raxml-ng --evaluate --msa msa.fa --threads 1 --model GTR --tree ${OutFile}.raxml.bestTree --prefix GTR
raxml-ng --evaluate --msa msa.fa --threads 1 --model GTR+G --tree ${OutFile}.raxml.bestTree --prefix GTR+G
raxml-ng --evaluate --msa msa.fa --threads 1 --model GTR+G+FO --tree ${OutFile}.raxml.bestTree --prefix GTR+G+FO
raxml-ng --evaluate --msa msa.fa --threads 1 --model GTR+R4+FO --tree ${OutFile}.raxml.bestTree --prefix GTR+R4+FO
grep "AIC score" E*.raxml.log > ${OutFile}.log

#Collect results
cp ${OutFile}* $OutDir/.
rm -r $WorkDir
echo DONE


