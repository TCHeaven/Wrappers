#!/bin/bash
#SBATCH -o /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH -e /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH --mem 4G
#SBATCH --nodes=1
#SBATCH -c 1
#SBATCH --account=shame
#SBATCH --partition=cpu
#SBATCH --time=0-02:00:00

CurPath=$PWD
WorkDir="${TMPDIR:-/tmp}/${SLURM_JOB_ID}"

cpu="${SLURM_CPUS_PER_TASK:-1}"
OutDir=${1:?ERROR: Missing Output Directory}
Prefix=${2:?ERROR: Missing prefix}
Reference=${3:?ERROR: Missing reference genome}
shift 3
Reads=("$@")

echo "Running on node $SLURM_NODELIST"
echo "cpus: $cpu"
echo "CurPath: $CurPath"
echo "WorkDir: $WorkDir"
echo "OutDir: $OutDir"
echo "Reference: $Reference"
echo "ReadFiles: ${Reads[@]}"

echo _
echo _

module load samtools/1.19.2-gcc-13.3.0-a2yhwkt
module load anaconda3
conda activate bowtie2

Reference_ID=$(basename "$Reference" | sed 's@_index@@g')

if [ ${#Reads[@]} -eq 0 ]; then
    echo "ERROR: No read files provided. Exiting."
    exit 1
elif [ ${#Reads[@]} -eq 1 ]; then
        echo "Only one read file provided, running for single end reads"

        mkdir -p "$OutDir"
        mkdir -p "$WorkDir"
        cd "$WorkDir"

        input_read=${Reads[0]}

	bowtie2 --threads "$cpu" \
	-x "$Reference" \
	-q -U "$input_read" \
	-S "${OutDir}"/"${Prefix}"_vs_"${Reference_ID}"_mapped.sam \
	--un "${OutDir}/"${Prefix}"_unaligned_vs_${Reference_ID}.fastq" \
	--seed 1234 2> "${OutDir}"/"${Prefix}"_vs_"${Reference_ID}"_bowtie2.log 

	gzip -f "${OutDir}/${Prefix}_unaligned_vs_${Reference_ID}.fastq"
	for i in "${OutDir}"/*.sam; do samtools view -@ "$cpu" -b -o "${i%.sam}.bam" "$i"; rm "$i"; done

elif [ ${#Reads[@]} -eq 2 ]; then
        echo "Two read files provided, running for paired reads"

        mkdir -p "$OutDir"
        mkdir -p "$WorkDir"
        cd "$WorkDir"

        input_read1=${Reads[0]}
        input_read2=${Reads[1]}

	bowtie2 \
	-x "$Reference" --threads "$cpu" \
	-q -1 "$input_read1" -2 "$input_read2" \
	-S "${OutDir}"/"${Prefix}"_vs_"${Reference_ID}"_mapped.sam \
        --un-conc "${OutDir}/"${Prefix}"_unaligned_vs_${Reference_ID}.fastq" \
	--seed 1234 2> "${OutDir}"/"${Prefix}"_vs_"${Reference_ID}"_bowtie2.log 

	gzip -f "${OutDir}/${Prefix}_unaligned_vs_${Reference_ID}.1.fastq"
	gzip -f "${OutDir}/${Prefix}_unaligned_vs_${Reference_ID}.2.fastq"
        for i in "${OutDir}"/*.sam; do samtools view -@ "$cpu" -b -o "${i%.sam}.bam" "$i"; rm "$i"; done

else
        echo "ERROR: More than two read files provided. This script only supports single-end or paired-end reads. Exiting."
        exit 1
fi

conda deactivate
conda activate basic

echo DONE
echo
echo "OutDir:"
tree "${OutDir}"
rm -r "$WorkDir"
