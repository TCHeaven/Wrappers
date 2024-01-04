#!/bin/bash
#SBATCH --job-name=omniHiC
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 100G
#SBATCH -c 32
#SBATCH -p jic-medium,jic-long
#SBATCH --time=02-00:00:00

##https://omni-c.readthedocs.io/en/latest/fastq_to_bam.html

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

Assembly=$1
Enzyme=$2
OutDir=$3
OutFile=$4
Read1=$5
Read2=$6
cpu=32

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo Assembly:
echo $Assembly
echo Enzyme:
echo $Enzyme
echo Reads:
echo $Read1
echo $Read2
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo _
echo _

mkdir -p $WorkDir

ln -s $Assembly $WorkDir/genome.fa
ln -s $Read1 $WorkDir/Fread.fq.gz
ln -s $Read2 $WorkDir/Rread.fq.gz
cd $WorkDir

source package 638df626-d658-40aa-80e5-14a275b7464b
source package /tgac/software/testing/bin/preseq-3.1.2
source package /tgac/software/testing/bin/pairtools-0.3.0
source bwa-0.7.17

echo "Creating BWA index..."
bwa index genome.fa

#bwa mem -t$cpu genome.fa Fread.fq.gz Rread.fq.gz > output.bam
#samtools sort -@$cpu -o sorted_output.bam output.bam
#samtools index -@$cpu sorted_output.bam
#samtools view -@$cpu -T genome.fa -C -o cram.cram sorted_output.bam
#samtools index -@$cpu cram.cram

samtools import -@ $cpu -r ID:$(basename $Read1 | cut -d '_' -f1,2) -r CN:$(basename $Read1 | cut -d '_' -f1,2 | cut -d '-' -f2) -r PU:$(basename $Read1 | cut -d '_' -f1,2) -r SM:$(basename $Read1 | cut -d '_' -f1,2 | cut -d '-' -f1) Fread.fq.gz Rread.fq.gz -o cram.cram
samtools index -@ $cpu cram.cram

##map reads
count=1
echo "Mapping Illumina HiC reads..."

CRAM_FILTER="singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/cram_filter.sif cram_filter"
for i in $(ls cram.cram); do
    CRINDEX=$i.crai
    CFROM=0
    CTO=10000
    NCONTAINERS=`zcat $CRINDEX |wc -l`

    if [ "$NCONTAINERS" == "0" ]; then
	echo "can't find HiC reads in $CRINDEX"
	exit 1
    fi

    while [ "$CFROM" -le "$NCONTAINERS" ]; do
        if [ "$CTO" -gt "$NCONTAINERS" ]; then
          CTO=$NCONTAINERS
        fi
        $CRAM_FILTER -n $CFROM-$CTO $i - | samtools fastq -@ $cpu -F0xB00 -nt - | bwa mem -T 10 -t $cpu -5SPCp genome.fa - | samtools fixmate -mpu -@ $cpu - - | samtools sort -@ $cpu --write-index -l9 -o ${OutFile}.${count}.align.bam -
        ((count++))
        CFROM=$((CTO+1 ))
        CTO=$((CFROM+9999))
    done
done

myFilter=~/git_repos/Scripts/NBI/filter_five_end.pl
if [[ -f "$myFilter" ]]; then
	count=1
	echo "Filtering BAM files..."
	for i in `ls -1 *.align.bam`
		do
			samtools view -@ $cpu -h $i | $myFilter | samtools sort -@ $cpu - > ${OutFile}.${count}.filtered.bam
		((count++))
		done
	if [[ ! -f ${OutFile}.1.filtered.bam ]]; then
		echo "${OutFile}.1.filtered.bam doesn't exist." 
	exit 1
	fi
	rm *.align.bam
fi

if [ `ls -1 *.bam | wc -l` -gt 1 ]; then
	echo "Merging BAM files..."
	ls -1 *.bam > bamlist
	samtools merge -@ $cpu -cpu -b bamlist - |samtools markdup -@ $cpu --write-index - ${OutFile}_mapped.bam
else
	samtools markdup -@ $cpu --write-index ${OutFile}.1.*.bam ${OutFile}_mapped.bam
fi

cp ${OutFile}_mapped.bam ${OutDir}/. 
cp ${OutFile}_mapped.bam.csi ${OutDir}/. 

echo DONE
rm -r $WorkDir


