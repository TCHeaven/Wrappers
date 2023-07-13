#!/bin/bash

# Script uses 16 cores for mapping, will use at least 140Gb ram for 400Mb genome.
# Run in dir containing assembly to polish

if [ $# -ne 5 ]; then
    echo usage: sh ~/git_repos/Wrappers/NBI/racon_3_rounds_pilon_3_rounds_kat_comp_busco.sh \<assembly\> \<path_to_r1\> \<path_to_r2\> \<path_to_long_reads\> \<minimap_mapping_default\>
    exit 1
fi

# note - adjust order or sourcing. Run minimap2 / racon then run busco and kat comp on input and racon assemblies. Then run pilon section

assembly=$1
path_r1=$2
path_r2=$3
path_LR=$4
minimap_LR_opt=$5

# Source software for racon

source minimap2-2.14
source anaconda3-5.2.0
source activate racon

# Racon round 1

minimap2 -ax ${minimap_LR_opt} -t 16 ${assembly} ${path_LR} > racon_r1.sam

racon -t 16 --include-unpolished ${path_LR} racon_r1.sam ${assembly} | cut -d " " -f1 > racon_r1.fasta

# Racon round 2

minimap2 -ax ${minimap_LR_opt} -t 16 racon_r1.fasta ${path_LR} > racon_r2.sam

racon -t 16 --include-unpolished ${path_LR} racon_r2.sam racon_r1.fasta | cut -d " " -f1 > racon_r2.fasta

# Racon round 3

minimap2 -ax ${minimap_LR_opt} -t 16 racon_r2.fasta ${path_LR} > racon_r3.sam

racon -t 16 --include-unpolished ${path_LR} racon_r3.sam racon_r2.fasta | cut -d " " -f1 > racon_r3.fasta

source deactivate

# Source software for BUSCO, kat comp and pilon

source switch-institute ei
source bwa-0.7.7
source samtools-1.3
source pilon-1.22
source kat-2.3.4
source busco-3.0

# BUSCO on input and racon iterations

# KAT comp on input assembly

kat comp -t 16 -o ./kat_comp_unpolished -m 31 -H 100000000 -I 100000000 "${path_r1} ${path_r2}" "${assembly}"

# BUSCO input assembly

run_BUSCO.py -i ${assembly} -o unpolished_BUSCO_arth -m geno -l /jic/research-groups/Saskia-Hogenhout/BUSCO_sets/v3/arthropoda_odb9/ -c 16 -sp peach_aphid --tmp_path unpolished_BUSCO_tmp

# KAT comp on racon_r1

kat comp -t 16 -o ./kat_comp_racon_r1 -m 31 -H 100000000 -I 100000000 "${path_r1} ${path_r2}" "racon_r1.fasta"

# BUSCO racon_r1

run_BUSCO.py -i racon_r1.fasta -o racon_r1_BUSCO_arth -m geno -l /jic/research-groups/Saskia-Hogenhout/BUSCO_sets/v3/arthropoda_odb9/ -c 16 -sp peach_aphid --tmp_path racon_r1_BUSCO_tmp

# KAT comp on racon_r2

kat comp -t 16 -o ./kat_comp_racon_r2 -m 31 -H 100000000 -I 100000000 "${path_r1} ${path_r2}" "racon_r2.fasta"

# BUSCO racon_r2

run_BUSCO.py -i racon_r2.fasta -o racon_r2_BUSCO_arth -m geno -l /jic/research-groups/Saskia-Hogenhout/BUSCO_sets/v3/arthropoda_odb9/ -c 16 -sp peach_aphid --tmp_path racon_r2_BUSCO_tmp

# KAT comp on racon_r3

kat comp -t 16 -o ./kat_comp_racon_r3 -m 31 -H 100000000 -I 100000000 "${path_r1} ${path_r2}" "racon_r3.fasta"

# BUSCO racon_r3

run_BUSCO.py -i racon_r3.fasta -o racon_r3_BUSCO_arth -m geno -l /jic/research-groups/Saskia-Hogenhout/BUSCO_sets/v3/arthropoda_odb9/ -c 16 -sp peach_aphid --tmp_path racon_r3_BUSCO_tmp

# Pilon iterations

# Round 1

bwa index racon_r3.fasta
bwa mem -t 16 -R '@RG\tID:self\tSM:self\tPL:ILLUMINA' racon_r3.fasta ${path_r1} ${path_r2}| samtools view -bS - | samtools sort -m 8G --threads 16 - > r1.sorted.bam
samtools index -b r1.sorted.bam
java -Xmx150G -jar /tgac/software/testing/pilon/1.22/x86_64/pilon-1.22.jar --genome racon_r3.fasta --frags r1.sorted.bam --output pilon_r1 --diploid --threads 16

kat comp -t 16 -o ./kat_comp_r1 -m 31 -H 100000000 -I 100000000 "${path_r1} ${path_r2}" "pilon_r1.fasta"

run_BUSCO.py -i pilon_r1.fasta -o r1_BUSCO_arth -m geno -l /jic/research-groups/Saskia-Hogenhout/BUSCO_sets/v3/arthropoda_odb9/ -c 16 -sp peach_aphid --tmp_path r1_BUSCO_tmp

# Round 2

bwa index pilon_r1.fasta
bwa mem -t 16 -R '@RG\tID:self\tSM:self\tPL:ILLUMINA' pilon_r1.fasta ${path_r1} ${path_r2}| samtools view -bS - | samtools sort -m 8G --threads 16 - > r2.sorted.bam
samtools index -b r2.sorted.bam
java -Xmx150G -jar /tgac/software/testing/pilon/1.22/x86_64/pilon-1.22.jar --genome pilon_r1.fasta --frags r2.sorted.bam --output pilon_r2 --diploid --threads 16

kat comp -t 16 -o ./kat_comp_r2 -m 31 -H 100000000 -I 100000000 "${path_r1} ${path_r2}" "pilon_r2.fasta"

run_BUSCO.py -i pilon_r2.fasta -o r2_BUSCO_arth -m geno -l /jic/research-groups/Saskia-Hogenhout/BUSCO_sets/v3/arthropoda_odb9/ -c 16 -sp peach_aphid --tmp_path r2_BUSCO_tmp

# Round 3

bwa index pilon_r2.fasta
bwa mem -t 16 -R '@RG\tID:self\tSM:self\tPL:ILLUMINA' pilon_r2.fasta ${path_r1} ${path_r2}| samtools view -bS - | samtools sort -m 8G --threads 16 - > r3.sorted.bam
samtools index -b r3.sorted.bam
java -Xmx150G -jar /tgac/software/testing/pilon/1.22/x86_64/pilon-1.22.jar --genome pilon_r2.fasta --frags r3.sorted.bam --output pilon_r3 --diploid --threads 16

kat comp -t 16 -o ./kat_comp_r3 -m 31 -H 100000000 -I 100000000 "${path_r1} ${path_r2}" "pilon_r3.fasta"

run_BUSCO.py -i pilon_r3.fasta -o r3_BUSCO_arth -m geno -l /jic/research-groups/Saskia-Hogenhout/BUSCO_sets/v3/arthropoda_odb9/ -c 16 -sp peach_aphid --tmp_path r3_BUSCO_tmp

# Clean up

rm r1.sorted.bam
rm r2.sorted.bam
rm r3.sorted.bam

rm r1.sorted.bam.bai
rm r2.sorted.bam.bai
rm r3.sorted.bam.bai

rm racon_r1.sam
rm racon_r2.sam
rm racon_r3.sam
