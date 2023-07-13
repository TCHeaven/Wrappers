#!/bin/bash
#SBATCH --job-name=bash
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 50G
#SBATCH --nodes=1
#SBATCH -c 32
#SBATCH -p nbi-medium,jic-medium
#SBATCH --time=2-00:00:00

for scaffold in $(grep '>' /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Myzus_persicae/O_v2/Myzus_persicae_O_v2.0.scaffolds.fasta); do
name=$(echo $scaffold | sed 's@>@@g')
grep -w -A 1 "$scaffold" /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Myzus_persicae/O_v2/Myzus_persicae_O_v2.0.scaffolds.fasta > /jic/research-groups/Saskia-Hogenhout/TCHeaven/Genomes/Myzus/persicae/O_v2/scaffolds/${name}.fa
grep -w "##gff-version 3\|$name" /jic/research-groups/Saskia-Hogenhout/Tom_Mathers/aphid_genomes_db/Myzus_persicae/O_v2/MYZPE13164_O_EIv2.1.annotation.gff3 > /jic/research-groups/Saskia-Hogenhout/TCHeaven/Genomes/Myzus/persicae/O_v2/scaffolds/${name}.gff
done 

for scaffold in $(ls /jic/research-groups/Saskia-Hogenhout/TCHeaven/Genomes/Myzus/persicae/O_v2/scaffolds/*.fa); do
name=$(echo $scaffold | cut -d '/' -f11 | sed 's@.fa@@g')
echo $name
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif gff3_to_fasta -g /jic/research-groups/Saskia-Hogenhout/TCHeaven/Genomes/Myzus/persicae/O_v2/scaffolds/${name}.gff -f $scaffold -st gene -d simple -o /jic/research-groups/Saskia-Hogenhout/TCHeaven/Genomes/Myzus/persicae/O_v2/scaffolds/${name}.gff3.nt

source package /tgac/software/testing/bin/bedops-2.2.0
source package 4028d6e4-21a8-45ec-8545-90e4ed7e1a64
gff2bed < /jic/research-groups/Saskia-Hogenhout/TCHeaven/Genomes/Myzus/persicae/O_v2/scaffolds/${name}.gff > /jic/research-groups/Saskia-Hogenhout/TCHeaven/Genomes/Myzus/persicae/O_v2/scaffolds/${name}.bed
grep "gene" /jic/research-groups/Saskia-Hogenhout/TCHeaven/Genomes/Myzus/persicae/O_v2/scaffolds/${name}.bed > /jic/research-groups/Saskia-Hogenhout/TCHeaven/Genomes/Myzus/persicae/O_v2/scaffolds/${name}_2.bed
bedtools getfasta -fi $scaffold -bed /jic/research-groups/Saskia-Hogenhout/TCHeaven/Genomes/Myzus/persicae/O_v2/scaffolds/${name}_2.bed -fo /jic/research-groups/Saskia-Hogenhout/TCHeaven/Genomes/Myzus/persicae/O_v2/scaffolds/${name}.gff3.nt2 -name+

source package /tgac/software/testing/bin/gffread-0.11.4
gffread -x /jic/research-groups/Saskia-Hogenhout/TCHeaven/Genomes/Myzus/persicae/O_v2/scaffolds/${name}.gff3.nt3 -g $scaffold /jic/research-groups/Saskia-Hogenhout/TCHeaven/Genomes/Myzus/persicae/O_v2/scaffolds/${name}.gff
done


