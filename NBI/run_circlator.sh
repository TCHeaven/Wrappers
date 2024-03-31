#!/bin/bash
#SBATCH --job-name=circlator
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 100G
#SBATCH --nodes=1
#SBATCH -c 32
#SBATCH -p jic-medium,jic-long,nbi-medium,nbi-long,RG-Saskia-Hogenhout
#SBATCH --time=02-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
InFile=$1
Read_type=$2
OutDir=$3
OutFile=$4
Read1=$5
Read2=$6
Read3=$7
Read4=$8
cpu=32

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo Assembly:
echo $InFile
echo Read type:
echo $Read_type
echo Reads:
echo $Read1
echo $Read2
echo $Read3
echo $Read4

echo _
echo _

mkdir -p $WorkDir
ln -s $InFile ${WorkDir}/assembly.fasta
cat $Read1 $Read2 $Read3 $Read4 > ${WorkDir}/reads.fasta

cd $WorkDir

source package 8d5e6fe6-0b34-4ff4-a645-0fe3209c0f75

circlator minimus2 $InFile ${OutFile}_minimus

if [ "$Read_type" = "illumina" ]; then
    echo "running with short reads"
    circlator all --threads $cpu --assembler spades assembly.fasta reads.fasta ${WorkDir}/1
elif [ "$Read_type" = "pacbio-raw" ] || [ "$Read_type" = "pacbio-corrected" ] || [ "$Read_type" = "nanopore-raw" ] || [ "$Read_type" = "nanopore-corrected" ]; then
    echo "running with long reads"
    #singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/circlator1.5.5.sif circlator all --threads $cpu --assembler canu --data_type $Read_type assembly.fasta reads.fasta ${WorkDir}/1
    circlator all --threads $cpu --assembler canu --data_type $Read_type assembly.fasta reads.fasta ${WorkDir}/1
else
    echo "unknown read type"
fi