#!/bin/bash
#SBATCH --job-name=bash
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 100G
#SBATCH -c 1
#SBATCH -p jic-medium, jic-long
#SBATCH --time=02-00:00:00

WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
mkdir $WorkDir  
cd $WorkDir 
singularity exec --overlay /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/overlays/genomation1.34.0-overlay.sif:ro /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/genomation1.34.0.sif R --save - <<EOF 

library("genomation")
library("methylKit")
#Read in the methylation ratio files
NB.file.list <- list("/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/BR25_E2_1/bsmap/CpG_BR25_E2_1_bsmap_ratios_filtered.txt",
"/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/BR25_E2_2/bsmap/CpG_BR25_E2_2_bsmap_ratios_filtered.txt",
"/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/BR25_E2_3/bsmap/CpG_BR25_E2_3_bsmap_ratios_filtered.txt",
"/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/NB25_E2_1/bsmap/CpG_NB25_E2_1_bsmap_ratios_filtered.txt",
"/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/NB25_E2_2/bsmap/CpG_NB25_E2_2_bsmap_ratios_filtered.txt",
"/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/NB25_E2_3/bsmap/CpG_NB25_E2_3_bsmap_ratios_filtered.txt")
NB.week1=methRead(NB.file.list, 
    sample.id=list("BR25_E2_1","BR25_E2_2","BR25_E2_3","NB25_E2_1","NB25_E2_2","NB25_E2_3"),
    assembly="O_v2",
    header=TRUE,
    treatment=c(0,0,0,1,1,1),
    mincov = 4,
    context="CpG",
    resolution="base",
    pipeline=list(fraction=TRUE,chr.col=1,start.col=2,end.col=2,coverage.col=6,strand.col=3,freqC.col=5 ))
NB.week1
AT.file.list <- list("/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/BR25_E2_1/bsmap/CpG_BR25_E2_1_bsmap_ratios_filtered.txt",
"/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/BR25_E2_2/bsmap/CpG_BR25_E2_2_bsmap_ratios_filtered.txt",
"/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/BR25_E2_3/bsmap/CpG_BR25_E2_3_bsmap_ratios_filtered.txt",
"/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/AT25_E2_1/bsmap/CpG_AT25_E2_1_bsmap_ratios_filtered.txt",
"/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/AT25_E2_2/bsmap/CpG_AT25_E2_2_bsmap_ratios_filtered.txt",
"/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/alignment/Myzus/persicae/WGBS/Archana_Mar2021/AT25_E2_3/bsmap/CpG_AT25_E2_3_bsmap_ratios_filtered.txt")
AT.week1=methRead(AT.file.list, 
    sample.id=list("BR25_E2_1","BR25_E2_2","BR25_E2_3","AT25_E2_1","AT25_E2_2","AT25_E2_3"),
    assembly="O_v2",
    header=TRUE,
    treatment=c(0,0,0,1,1,1),
    mincov = 4,
    context="CpG",
    resolution="base",
    pipeline=list(fraction=TRUE,chr.col=1,start.col=2,end.col=2,coverage.col=6,strand.col=3,freqC.col=5 ))
AT.week1

#Read in annotation info
refseq_anot <- readTranscriptFeatures("/jic/research-groups/Saskia-Hogenhout/TCHeaven/Genomes/Myzus/persicae/O_v2/MYZPE13164_O_EIv2.1.annotation.bed12",remove.unusual=FALSE)
cpg_anot <- readFeatureFlank("/jic/research-groups/Saskia-Hogenhout/TCHeaven/Genomes/Myzus/persicae/O_v2/MYZPE13164_O_EIv2.1.cpg.bed", feature.flank.name = c("CpGi", "shores"), flank=2000)

##################################################################################################################

#Group methylation count by sliding window region:
NB.tiles <- tileMethylCounts(NB.week1,win.size=1000,step.size=1000,cov.bases = 10)

#Filter and normalise
NB.tiles.filt <- filterByCoverage(NB.tiles,
                      lo.count=4,
                      lo.perc=NULL,
                      hi.count=NULL,
                      hi.perc=99.9)
NB.tiles.filt.norm <- normalizeCoverage(NB.tiles.filt, method = "median")
NB.meth.tiles <- unite(NB.tiles.filt.norm, destrand=FALSE)
NB.meth.tiles
NB.diff.tiles <- calculateDiffMeth(NB.meth.tiles,
                            treatment=c(0,0,0,1,1,1),
                            overdispersion = "MN",
                            adjust="BH")
NB.diff.tiles
save(NB.diff.tiles, file = "/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/analysis/Myzus/persicae/WGBS/Archana_Mar2021/methylkit/NB25_diffmeth_windowed.RData")

#################################################################################################################

#Group methylation count by sliding window region:
AT.tiles <- tileMethylCounts(AT.week1,win.size=1000,step.size=1000,cov.bases = 10)

#Filter and normalise
AT.tiles.filt <- filterByCoverage(AT.tiles,
                      lo.count=4,
                      lo.perc=NULL,
                      hi.count=NULL,
                      hi.perc=99.9)
AT.tiles.filt.norm <- normalizeCoverage(AT.tiles.filt, method = "median")
AT.meth.tiles <- unite(AT.tiles.filt.norm, destrand=FALSE)
AT.meth.tiles
AT.diff.tiles <- calculateDiffMeth(AT.meth.tiles,
                            treatment=c(0,0,0,1,1,1),
                            overdispersion = "MN",
                            adjust="BH")
AT.diff.tiles
save(AT.diff.tiles, file = "/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/analysis/Myzus/persicae/WGBS/Archana_Mar2021/methylkit/AT25_diffmeth_windowed.RData")

#################################################################################################################
EOF

echo Done
rm -r $WorkDir