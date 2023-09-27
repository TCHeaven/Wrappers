#!/bin/bash
#SBATCH --job-name=blobtools
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 20G
#SBATCH --nodes=1
#SBATCH -c 8
#SBATCH -p nbi-medium,jic-medium,nbi-long,jic-long
#SBATCH --time=02-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
Assembly=$1
MappingFile=$2
BlastFile=$3
OutDir=$4
OutFile=$5
ColourFile=$6

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo Assembly:
echo $Assembly
echo MappingFile:
echo $MappingFile
echo BlastFile
echo $BlastFile
echo ColourFile:
echo $ColourFile
echo _
echo _

mkdir -p $WorkDir
cp $Assembly $WorkDir/Input.fa
cp $MappingFile $WorkDir/Input.bam
cp $BlastFile $WorkDir/Input.out
cp $ColourFile $WorkDir/colours.txt

cd $WorkDir
source package 102a6af9-7422-4e1a-9e42-d43a2bcd3d1f
source package 638df626-d658-40aa-80e5-14a275b7464b

samtools sort -@ 8 -o Input-sorted.bam Input.bam
samtools index -@ 8 Input-sorted.bam

echo Creating blobtools database
blobtools create \
--db /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/databases/blobtools/22092023/nodesDB.txt \
-i Input.fa \
-b Input-sorted.bam \
-t Input.out \
-o $OutFile

echo Viewing blobtools database
blobtools view \
-i ${OutFile}.blobDB.json \
-r species \
-o ${OutFile}_species \
--concoct --cov --experimental 

grep '^##' ${OutFile}_species.blobDB.table.txt ; \
grep -v '^##' ${OutFile}_species.blobDB.table.txt | \
column -t -s $'\t' > ${OutFile}_species.inspect

blobtools view \
-i ${OutFile}.blobDB.json \
-r genus \
-o ${OutFile}_genus \
--concoct --cov --experimental 

grep '^##' ${OutFile}_genus.blobDB.table.txt ; \
grep -v '^##' ${OutFile}_genus.blobDB.table.txt | \
column -t -s $'\t' > ${OutFile}_genus.inspect

blobtools view \
-i ${OutFile}.blobDB.json \
-r family \
-o ${OutFile}_family \
--concoct --cov --experimental

grep '^##' ${OutFile}_family.blobDB.table.txt ; \
grep -v '^##' ${OutFile}_family.blobDB.table.txt | \
column -t -s $'\t' > ${OutFile}_family.inspect

blobtools view \
-i ${OutFile}.blobDB.json \
-r order \
-o ${OutFile}_order \
--concoct --cov --experimental

grep '^##' ${OutFile}_order.blobDB.table.txt ; \
grep -v '^##' ${OutFile}_order.blobDB.table.txt | \
column -t -s $'\t' > ${OutFile}_order.inspect

blobtools view \
-i ${OutFile}.blobDB.json \
-r phylum \
-o ${OutFile}_phylum \
--concoct --cov --experimental

grep '^##' ${OutFile}_phylum.blobDB.table.txt ; \
grep -v '^##' ${OutFile}_phylum.blobDB.table.txt | \
column -t -s $'\t' > ${OutFile}_phylum.inspect

blobtools view \
-i ${OutFile}.blobDB.json \
-r superkingdom \
-o ${OutFile}_superkingdom \
--concoct --cov --experimental

grep '^##' ${OutFile}_superkingdom.blobDB.table.txt ; \
grep -v '^##' ${OutFile}_superkingdom.blobDB.table.txt | \
column -t -s $'\t' > ${OutFile}_superkingdom.inspect

echo Plotting blobtools 
if [ -e colours.txt ]; then 
blobtools plot \
-i ${OutFile}.blobDB.json \
--notitle \
-r species -p 7 \
--colours colours.txt \
-o ${OutFile}_species_plot_set_colours

blobtools plot \
-i ${OutFile}.blobDB.json \
--notitle \
-r genus -p 7 \
--colours colours.txt \
-o ${OutFile}_genus_plot_set_colours

blobtools plot \
-i ${OutFile}.blobDB.json \
--notitle \
-r family -p 7 \
--colours colours.txt \
-o ${OutFile}_family_plot_set_colours

blobtools plot \
-i ${OutFile}.blobDB.json \
--notitle \
-r order -p 7 \
--colours colours.txt \
-o ${OutFile}_order_plot_set_colours

blobtools plot \
-i ${OutFile}.blobDB.json \
--notitle \
-r phylum -p 7 \
--colours colours.txt \
-o ${OutFile}_phylum_plot_set_colours

blobtools plot \
-i ${OutFile}.blobDB.json \
--notitle \
-r superkingdom -p 7 \
--colours colours.txt \
-o ${OutFile}_superkingdom_plot_set_colours

else

blobtools plot \
-i ${OutFile}.blobDB.json \
--notitle \
-r species -p 7 \
-o ${OutFile}_species_plot_default_colours

blobtools plot \
-i ${OutFile}.blobDB.json \
--notitle \
-r genus -p 7 \
-o ${OutFile}_genus_plot_default_colours

blobtools plot \
-i ${OutFile}.blobDB.json \
--notitle \
-r family -p 7 \
-o ${OutFile}_family_plot_default_colours

blobtools plot \
-i ${OutFile}.blobDB.json \
--notitle \
-r order -p 7 \
-o ${OutFile}_order_plot_default_colours

blobtools plot \
-i ${OutFile}.blobDB.json \
--notitle \
-r phylum -p 7 \
-o ${OutFile}_phylum_plot_default_colours

blobtools plot \
-i ${OutFile}.blobDB.json \
--notitle \
-r superkingdom -p 7 \
-o ${OutFile}_superkingdom_plot_default_colours

fi

echo Collecting outputs:
ls -lh
#mkdir ${OutDir}
cp ${OutFile}* ${OutDir}/.
echo DONE
rm -r $WorkDir
