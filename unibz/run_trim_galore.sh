#!/bin/bash
#SBATCH -o /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH -e /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH --mem 16G
#SBATCH --nodes=1
#SBATCH -c 4
#SBATCH --account=shame
#SBATCH --partition=bioagri
#SBATCH --time=2-00:00:00

####

CurPath=$PWD
WorkDir="${TMPDIR}/${SLURM_JOB_ID}"
cpu="${SLURM_CPUS_PER_TASK:-1}"

DELETE_INPUT=false
ARGS=()

for arg in "$@"; do
    if [[ "$arg" == "--delete-input" ]]; then
        DELETE_INPUT=true
    else
        ARGS+=("$arg")
    fi
done

if [[ "${#ARGS[@]}" -lt 6 ]]; then
    echo "ERROR: Insufficient arguments."
    echo "Usage:"
    echo "  $0 [--delete-input] OutDir OutFile Quality Length READS(paired)..."
    exit 1
fi

OutDir="${ARGS[0]}"
OutFile="${ARGS[1]}"
Quality="${ARGS[2]}"
Length="${ARGS[3]}"

Reads=("${ARGS[@]:4}")

echo "Output directory: $OutDir"
echo "Output file: $OutFile"
echo "Quality threshold: $Quality"
echo "Minimum length: $Length"
echo "CPUs: $cpu"
echo "Reads: ${Reads[*]}"

echo _
echo _

####

mkdir -p $WorkDir
cd $WorkDir

module load anaconda3
conda activate trim_galore

FREADS=()
RREADS=()

declare -A R1_BY_KEY
declare -A R2_BY_KEY

for read in "${Reads[@]}"; do
    basename=$(basename "$read")
    case "$basename" in
        *_1.fastq.gz)
            key="${basename%_1.fastq.gz}"
            R1_BY_KEY["$key"]="$read"
            ;;
        *_2.fastq.gz)
            key="${basename%_2.fastq.gz}"
            R2_BY_KEY["$key"]="$read"
            ;;
        *_R1.fastq.gz)
            key="${basename%_R1.fastq.gz}"
            R1_BY_KEY["$key"]="$read"
            ;;
        *_R2.fastq.gz)
            key="${basename%_R2.fastq.gz}"
            R2_BY_KEY["$key"]="$read"
            ;;
        *_R1_*.fastq.gz)
            key="${basename%_R1_*.fastq.gz}"
            suffix="${basename#*_R1_}"
            suffix="${suffix%.fastq.gz}"
            key="${key}_${suffix}"
            R1_BY_KEY["$key"]="$read"
            ;;
        *_R2_*.fastq.gz)
            key="${basename%_R2_*.fastq.gz}"
            suffix="${basename#*_R2_}"
            suffix="${suffix%.fastq.gz}"
            key="${key}_${suffix}"
            R2_BY_KEY["$key"]="$read"
            ;;
        *)
            echo "ERROR: Cannot determine R1/R2 for:"
            echo "  $read"
            exit 1
            ;;
    esac
done

for key in "${!R1_BY_KEY[@]}"; do
    if [[ ! -v "R2_BY_KEY[$key]" ]]; then
        echo "ERROR: No matching R2 for:"
        echo "  R1: ${R1_BY_KEY[$key]}"
        exit 1
    fi
done

for key in "${!R2_BY_KEY[@]}"; do
    if [[ ! -v "R1_BY_KEY[$key]" ]]; then
        echo "ERROR: No matching R1 for:"
        echo "  R2: ${R2_BY_KEY[$key]}"
        exit 1
    fi
done

mapfile -t KEYS < <(
    printf '%s\n' "${!R1_BY_KEY[@]}" | sort -V
)

for key in "${KEYS[@]}"; do
    FREADS+=("${R1_BY_KEY[$key]}")
    RREADS+=("${R2_BY_KEY[$key]}")
done

for ((i=0; i<${#FREADS[@]}; i++)); do
    echo "  Pair $((i+1)):"
    echo "    R1: ${FREADS[$i]}"
    echo "    R2: ${RREADS[$i]}"
done

cat "${FREADS[@]}" > "$WorkDir/F.fq.gz"
cat "${RREADS[@]}" > "$WorkDir/R.fq.gz"

trim_galore --gzip -j "$cpu" --quality "$Quality" --length "$Length" --output_dir . --paired F.fq.gz R.fq.gz

####

mkdir -p "$OutDir"
cp F.fq.gz_trimming_report.txt ${OutDir}/${OutFile}_1_report.txt
cp R.fq.gz_trimming_report.txt ${OutDir}/${OutFile}_2_report.txt
cp F_val_1.fq.gz ${OutDir}/${OutFile}_1.fq.gz
cp R_val_2.fq.gz ${OutDir}/${OutFile}_2.fq.gz

if [[ ! -s "${OutDir}/${OutFile}_1.fq.gz" ||
      ! -s "${OutDir}/${OutFile}_2.fq.gz" ||
      ! -s "${OutDir}/${OutFile}_1_report.txt" ||
      ! -s "${OutDir}/${OutFile}_2_report.txt" ]]; then
    echo "ERROR: Expected Trim Galore output files were not created."
    echo "Input files will NOT be deleted."
    exit 1
fi

if [[ "$DELETE_INPUT" == true ]]; then
    echo "Verified output files. Deleting input FASTQ files..."
    rm -f "${Reads[@]}"
    echo "Input files deleted."
else
    echo "Input files retained."
fi

ls -lh
echo DONE
rm -r $WorkDir
