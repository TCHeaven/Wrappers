#!/bin/bash
#SBATCH --job-name=longranger
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 200G
#SBATCH --nodes=1
#SBATCH -c 32
#SBATCH -p jic-medium,nbi-medium
#SBATCH --time=02-0:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
Fread=$1
Rread=$2
ID=$3
OutDir=$4
OutFile=$5

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir

echo Fread:
echo $Fread
echo Rread:
echo $Rread
echo ID:
echo $ID
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile

echo _
echo _

mkdir -p $WorkDir

ln -s $Fread $WorkDir/.
ln -s $Rread $WorkDir/.

cd $WorkDir
#source package /tgac/software/testing/bin/longranger-2.1.2
#source package /tgac/software/testing/bin/longranger-2.1.2_tellseq
export PATH=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/longranger/longranger-2.2.2:$PATH
longranger basic --fastqs ./ --sample=$ID --id $OutFile

ls -lh

mv ${OutFile}/outs/barcoded.fastq.gz ${OutDir}/${OutFile}_barcoded.fastq.gz
mv ${OutFile}/outs/summary.csv ${OutDir}/${OutFile}_summary.csv
echo DONE
rm -r $WorkDir

for dir in $(ls -d *); do
ID=$(grep $dir key.txt | cut -d $'\t' -f2 | sed 's@S110@NIC_23@g' | sed 's@S111@NIC_410G@g' | sed 's@S106@NIC_5191A@g'| sed 's@S114@NIC_57@g'| sed 's@S115@NIC_8124@g'| sed 's@S112@NIC_926B@g'| sed 's@S105@SUS_4106a@g'| sed 's@S108@SUS_4225A@g'| sed 's@S107@SUS_NS@g'| sed 's@S109@SUS_US1L@g')
if [ -e ../$ID/qualimap ]; then
echo $ID
fastq-dump --split-files --gzip -O ../$ID $dir/*.sra
else
echo $dir
fi
done