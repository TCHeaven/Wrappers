 #!/bin/bash
#SBATCH --job-name=phame
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 2G
#SBATCH -c 64
#SBATCH -p jic-medium,jic-long
#SBATCH --time=02-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

if [ "$1" = "Eukarya" ]; then
    class=2
elif [ "$1" = "Bacteria" ]; then
    class=0
elif [ "$1" = "Virus" ]; then
    class=1
else
    echo ERROR
fi
Reference=$2



mkdir -p $WorkDir/ref
cd $WorkDir

echo refdir = ./ref > phame.ctl  # directory where reference (Complete) files are located
echo workdir = . > phame.ctl # directory where contigs/reads files are located and output is stored
echo reference = 1 > phame.ctl  # 0:pick a random reference from refdir; 1:use given reference; 2: use ANI based reference
echo reffile = $(basename $Reference) > phame.ctl  # reference filename when option 1 is chosen
echo project = t4 > phame.ctl  # main alignment file name
echo cdsSNPS = 0 > phame.ctl  # 0:no cds SNPS; 1:cds SNPs, divides SNPs into coding and non-coding sequences, gff file is required
echo buildSNPdb = 0 > phame.ctl # 0: only align to reference 1: build SNP database of all complete genomes from refdir
echo FirstTime = 1 > phame.ctl  # 1:yes; 2:update existing SNP alignment, only works when buildSNPdb is used first time to build DB
echo data = 2 > phame.ctl  # *See below 0:only complete(F); 1:only contig(C); 2:only reads(R);
               # 3:combination F+C; 4:combination F+R; 5:combination C+R;
               # 6:combination F+C+R; 7:realignment  *See below
echo reads = 2 > phame.ctl  # 1: single reads; 2: paired reads; 3: both types present;
echo tree = 2 > phame.ctl  # 0:no tree; 1:use FastTree; 2:use RAxML; 3:use both;
echo bootstrap = 1 > phame.ctl  # 0:no; 1:yes;  # Run bootstrapping  *See below
echo N = 100 > phame.ctl  # Number of bootstraps to run *See below
echo PosSelect = 1 > phame.ctl  # 0:No; 1:use PAML; 2:use HyPhy; 3:use both # these analysis need gff file to parse genomes to genes
echo code = $class > phame.ctl  # 0:Bacteria; 1:Virus; 2: Eukarya # Bacteria and Virus sets ploidy to haploid
echo clean = 1 > phame.ctl  # 0:no clean; 1:clean # remove intermediate and temp files after analysis is complete
echo threads = 64 > phame.ctl  # Number of threads to use
echo cutoff = 0.1 > phame.ctl  # Linear alignment (LA) coverage against reference - ignores SNPs from organism that have lower cutoff.

singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/phame.sif phame phame.ctl
