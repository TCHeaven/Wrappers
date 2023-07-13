#!/bin/bash
#SBATCH --job-name=canu
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 50G
#SBATCH --nodes=1
#SBATCH -c 32
#SBATCH -p jic-medium,nbi-medium
#SBATCH --time=2-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
OutDir=$1
OutFile=$2
Genomesize=$3
DataType=$4

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile

echo Genomesize:
echo $Genomesize
echo Datatype:
echo $DataType
echo Homozygous_coverage:
echo $Homozygous_coverage
echo Min_contig:
echo $Min_contig
echo Purge_haplotigs:
echo $Purge_haplotigs
echo Kmer_cuttoff:
echo $Kmer_cuttoff
echo Overlap_iterations:
echo $Overlap_iterations
echo Kmer_size:
echo $Kmer_size
echo Similarity_threshold:
echo $Similarity_threshold

echo ReadFiles:
echo 1:
echo ${5}
echo 2:
echo ${6}
echo 3:
echo ${7}
echo 4:
echo ${8}
echo 5:
echo ${9}
echo 6:
echo ${10}
echo 7:
echo ${11}
echo 8:
echo ${12}
echo 9:
echo ${13}
echo 10:
echo ${14}
echo 11:
echo ${15}
echo 12:
echo ${16}
echo 13:
echo ${17}
echo 14:
echo ${18}
echo 15:
echo ${19}

echo _
echo _

mkdir -p $WorkDir

cp ${5} $WorkDir/fasta1.fq.gz
cp ${6} $WorkDir/fasta2.fq.gz
cp ${7} $WorkDir/fasta3.fq.gz
cp ${8} $WorkDir/fasta4.fq.gz
cp ${9} $WorkDir/fasta5.fq.gz
cp ${10} $WorkDir/fasta6.fq.gz
cp ${11} $WorkDir/fasta7.fq.gz
cp ${12} $WorkDir/fasta8.fq.gz
cp ${13} $WorkDir/fasta9.fq.gz
cp ${14} $WorkDir/fasta10.fq.gz
cp ${15} $WorkDir/fasta11.fq.gz
cp ${16} $WorkDir/fasta12.fq.gz
cp ${17} $WorkDir/fasta13.fq.gz
cp ${18} $WorkDir/fasta14.fq.gz
cp ${19} $WorkDir/fasta15.fq.gz

cd $WorkDir

#source package /tgac/software/testing/bin/canu-2.0
source package /tgac/software/production/bin/abyss-1.3.5

singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/canu_2.2.sif canu -p $OutFile -d . genomeSize=$Genomesize correctedErrorRate=0.105 -${DataType} fasta*.fq.gz 
#singularity exec /hpc-home/did23faz/canu.sif /canu-2.2/bin/canu -p $OutFile -d . genomeSize=$Genomesize correctedErrorRate=0.105 -${DataType} fasta1.fq.gz fasta2.fq.gz fasta3.fq.gz fasta4.fq.gz fasta5.fq.gz fasta6.fq.gz fasta7.fq.gz fasta8.fq.gz fasta9.fq.gz fasta10.fq.gz fasta11.fq.gz fasta12.fq.gz fasta13.fq.gz fasta14.fq.gz fasta15.fq.gz
#canu -p $OutFile -d . genomeSize=$Genomesize correctedErrorRate=0.105 -pacbio-hifi fasta1.fq.gz fasta2.fq.gz fasta3.fq.gz fasta4.fq.gz fasta5.fq.gz fasta6.fq.gz fasta7.fq.gz fasta8.fq.gz fasta9.fq.gz fasta10.fq.gz fasta11.fq.gz fasta12.fq.gz fasta13.fq.gz fasta14.fq.gz fasta15.fq.gz
#stopOnLowCoverage <integer=10>

cp ${OutFile}* $OutDir/.
echo DONE
#rm -r $WorkDir

