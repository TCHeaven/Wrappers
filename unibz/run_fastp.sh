#!/bin/bash
#SBATCH -o /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH -e /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH --mem 4G
#SBATCH --nodes=1
#SBATCH -c 1
#SBATCH --account=shame
#SBATCH --partition=bioagri
#SBATCH --time=0-02:00:00

CurPath=$PWD
WorkDir="${TMPDIR:-/tmp}/${SLURM_JOB_ID}"

cpu="${SLURM_CPUS_PER_TASK:-1}"
OutDir=${1:?ERROR: Missing Output Directory}
shift 1
Reads=("$@")

echo "Running on node $SLURM_NODELIST"
echo "cpus: $cpu"
echo "CurPath: $CurPath"
echo "WorkDir: $WorkDir"
echo "OutDir: $OutDir"
echo "ReadFiles: ${Reads[@]}"

echo _
echo _

module load anaconda3
conda activate fastp

if [ ${#Reads[@]} -eq 0 ]; then
    echo "ERROR: No read files provided. Exiting."
    exit 1
elif [ ${#Reads[@]} -eq 1 ]; then
        echo "Only one read file provided, running for single end reads"

        mkdir -p "$WorkDir"
        cd "$WorkDir"
        mkdir -p "$OutDir"

        input_read=${Reads[0]}
        output_read="${OutDir}/$(basename ${input_read%.fastq.gz}).trimmed.fastq.gz"
        Prefix="${OutDir}/$(basename ${input_read1%.fastq.gz})_paired"

		fastp --thread "$cpu" \
	 	--in1 "$input_read" \
	 	--out1 "$output_read" \
	 	--length_required 100 \
	 	--overrepresentation_analysis \
	 	--qualified_quality_phred 20 \
	 	--unqualified_percent_limit 40 \
	 	--html "$Prefix"_trimmed_l100.html \
	 	--json "$Prefix"_trimmed_l100.json

elif [ ${#Reads[@]} -eq 2 ]; then
        echo "Two read files provided, running for paired reads"

        mkdir -p "$WorkDir"
        cd "$WorkDir"
        mkdir -p "$OutDir"

        input_read1=${Reads[0]}
        output_read1="${OutDir}/$(basename ${input_read1%.fastq.gz}).trimmed.fastq.gz"
        input_read2=${Reads[1]}
        output_read2="${OutDir}/$(basename ${input_read2%.fastq.gz}).trimmed.fastq.gz"
        Prefix="${OutDir}/$(basename ${input_read1%.fastq.gz})_paired"

    	fastp --thread "$cpu" \
        --in1 "$input_read1" \
        --in2 "$input_read2" \
        --out1 "$output_read1" \
        --out2 "$output_read2" \
        --length_required 100 \
        --detect_adapter_for_pe \
        --overrepresentation_analysis \
        --qualified_quality_phred 20 \
        --unqualified_percent_limit 40 \
	 	--html "$Prefix"_trimmed_l100.html \
	 	--json "$Prefix"_trimmed_l100.json

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
