#!/bin/bash
#SBATCH -o /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH -e /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH --mem 1G
#SBATCH --nodes=1
#SBATCH -c 1
#SBATCH --account=shame
#SBATCH --partition=cpu
#SBATCH --time=0-02:00:00

CurPath=$PWD
WorkDir="${TMPDIR:-/tmp}/cutadapt_${SLURM_JOB_ID}"

cpu="${SLURM_CPUS_PER_TASK:-1}"
OutDir=${1:?ERROR: Missing Output Directory}
Forward_Primer=${2:?ERROR: Missing Forward Primer}
Reverse_Primer=${3:?ERROR: Missing Reverse Primer}
shift 3
Reads=("$@")

echo "Running on node $SLURM_NODELIST"
echo "CurPath: $CurPath"
echo "WorkDir: $WorkDir"
echo "OutDir: $OutDir"
echo "Forward primer: $Forward_Primer"
echo "Reverse primer: $Reverse_Primer"
echo "ReadFiles: ${Reads[@]}"

echo _
echo _

module load anaconda3
module load singularity/3.11.4 
conda activate seqkit-2.10

Forward_Primer_RC=$(printf ">p\n%s\n" "$Forward_Primer" | seqkit seq -t dna -r -p -w 0 | tail -n 1)
Reverse_Primer_RC=$(printf ">p\n%s\n" "$Reverse_Primer" | seqkit seq -t dna -r -p -w 0 | tail -n 1)

if [ ${#Reads[@]} -eq 0 ]; then
    echo "ERROR: No read files provided. Exiting."
    exit 1
elif [ ${#Reads[@]} -eq 1 ]; then
	echo "Only one read file provided, running for single end reads"

	mkdir -p "$WorkDir"
	cd $WorkDir
	mkdir -p "$OutDir"

	input_read=${Reads[0]}
	output_read="${OutDir}/$(basename ${input_read%.fastq.gz}).trim.fastq.gz"

	singularity exec --bind /data/users/theaven,/home/clusterusers/theaven ~/git_repos/Containers/cutadapt_5.2--py312h0fa9677_0 cutadapt -j "$cpu" \
	--revcomp \
	-g "^$Forward_Primer" \
        -a "$Reverse_Primer_RC" \
	-e 0.1 \
	--max-n=0 \
	-m 100 \
	--trim-n \
	-o "$output_read" \
	"$input_read"

elif [ ${#Reads[@]} -eq 2 ]; then
	echo "Two read files provided, running for paired reads"

	mkdir -p "$WorkDir"
	cd $WorkDir
	mkdir -p "$OutDir"

    	input_read1=${Reads[0]}
    	input_read2=${Reads[1]}
    	output_read1="${OutDir}/$(basename ${input_read1%.fastq.gz}).trim.fastq.gz"
    	output_read2="${OutDir}/$(basename ${input_read2%.fastq.gz}).trim.fastq.gz"

	singularity exec --bind /data/users/theaven,/home/clusterusers/theaven ~/git_repos/Containers/cutadapt_5.2--py312h0fa9677_0 cutadapt -j $cpu \
	--revcomp \
	-g "^$Forward_Primer" \
	-G "^$Reverse_Primer" \
	-a "$Reverse_Primer_RC" \
	-A "$Forward_Primer_RC" \
	-e 0.1 \
        --max-n=0 \
        -m 100 \
        --trim-n \
	--pair-filter any \
	-o "$output_read1" \
	-p "$output_read2" \
	"$input_read1" "$input_read2"

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
rm -r $WorkDir
