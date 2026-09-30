#!/bin/bash
#SBATCH -o /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH -e /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH --mem 64G
#SBATCH --nodes=1
#SBATCH -c 16
#SBATCH --account=shame
#SBATCH --partition=gpu-low
#SBATCH --gres=gpu:1
#SBATCH --time=07-00:00:00

CurPath=$PWD
WorkDir="${TMPDIR:-/tmp}/${SLURM_JOB_ID}"
InDir="${1:?ERROR: Missing Input}"
OutDir="${2:?ERROR: Missing Output Directory}"
OutFmt="${3:?ERROR: Missing Output Format}"
Barcode="${4:-NA}"
Remora="${5:-NA}"
Model="${6:-dna_r10.4.1_e8.2_400bps_sup@v4.1.0}"

cpu="${SLURM_CPUS_PER_TASK:-16}"
Half_cpu=$((cpu / 2))
Quarter_cpu=$((cpu / 4))

# Shared, persistent location for downloaded models so every job
# doesn't re-download the same ~GB+ model files.
ModelDir="/data/users/theaven/dorado_models"
mkdir -p "$ModelDir"

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo Output format:
echo $OutFmt
echo Input:
echo $InDir
echo Barcode kit:
echo $Barcode
echo Modification model:
echo $Remora
echo Basecalling model:
echo $Model
echo "CPUs: $cpu"
echo _
echo _

cleanup() { echo "Cleaning up temp workspace: $WorkDir"; rm -rf "$WorkDir"; }
trap cleanup EXIT

mkdir -p $WorkDir
cd $WorkDir
mkdir -p "$OutDir"

module load dorado/0.8.3
module load samtools/1.19.2-gcc-13.3.0-a2yhwkt
echo "dorado version:"
dorado --version

# Download the base model once, reuse across jobs.
if [ ! -d "${ModelDir}/${Model}" ]; then
    echo "Downloading basecalling model: $Model"
    dorado download --model "$Model" --models-directory "$ModelDir"
fi
ModelPath="${ModelDir}/${Model}"

# Build the dorado basecaller command
DORADO_CMD="dorado basecaller \"$ModelPath\" \"$InDir\" --device cuda:all"

if [[ "$Barcode" != "NA" ]]; then
    DORADO_CMD="$DORADO_CMD --kit-name \"$Barcode\""
fi

if [[ "$Remora" != "NA" ]]; then
    if [ ! -d "${ModelDir}/${Remora}" ]; then
        echo "Downloading modified-bases model: $Remora"
        dorado download --model "$Remora" --models-directory "$ModelDir"
    fi
    DORADO_CMD="$DORADO_CMD --modified-bases-models \"${ModelDir}/${Remora}\""
fi

echo "Running dorado:"
echo "$DORADO_CMD"

# Basecall to an unaligned BAM first (dorado always emits SAM/BAM records)
eval "$DORADO_CMD" | samtools view --no-PG -b -o "$OutDir/basecalls.ubam" -

# Convert to the requested output format
module load anaconda3
conda activate basic

case "$OutFmt" in
    fastq)
        samtools bam2fq --threads "$Half_cpu" "$OutDir/basecalls.ubam" > "$OutDir/out.fastq"
        ;;
    bam)
        samtools sort --threads "$Half_cpu" -o "$OutDir/out.bam" "$OutDir/basecalls.ubam"
        samtools index "$OutDir/out.bam"
        ;;
    cram)
        echo "WARNING: cram output requires a --ref FASTA; this script does not currently accept one."
        echo "Leaving unaligned BAM in place at $OutDir/basecalls.ubam"
        ;;
    *)
        echo "WARNING: unrecognised output format '$OutFmt'; leaving unaligned BAM at $OutDir/basecalls.ubam"
        ;;
esac

# If barcoding was requested, split the classified reads into per-barcode files
if [[ "$Barcode" != "NA" ]]; then
    mkdir -p "$OutDir/demuxed"
    dorado demux --output-dir "$OutDir/demuxed" --no-classify "$OutDir/basecalls.ubam"
fi

ls -lh "$OutDir"

echo DONE
echo
echo "OutDir:"
tree "${OutDir}"
