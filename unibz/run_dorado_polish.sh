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
Assembly="${1:?ERROR: Missing Assembly}"
Reads="${2:?ERROR: Missing Reads}"
OutDir="${3:?ERROR: Missing Output Directory}"
shift 3

cpu="${SLURM_CPUS_PER_TASK:-16}"

Bacteria="NA"
Regions="NA"

while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --bacteria)
            Bacteria="Y"
            shift
            ;;
        --regions)
            [[ -n "${2:-}" && "$2" != --* ]] || {
                echo "ERROR: --regions selected but no value given"
                exit 1
            }
            Regions="$2"
            shift 2
            ;;
        *)
            echo "ERROR: Unknown parameter: $1"
            exit 1
            ;;
    esac
done


echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo Assembly:
echo "$Assembly"
echo Reads:
echo "$Reads"
echo Bacteria mode?:
echo "$Bacteria"
echo Regions:
echo "$Regions"

module load anaconda3
module load samtools/1.16.1
module load bcftools/1.19-gcc-12.3.0
module load gnuplot/6.0.0-gcc-12.3.0-637ora5
module load seqtk/1.4-gcc-12.3.0
conda activate /data/users/theaven/conda/envs/seqkit

mkdir -p "$OutDir"
mkdir -p "$WorkDir"
mkdir /data/users/theaven/dorado_models

cd "$WorkDir"

/data/users/theaven/software/dorado-2.1.2-linux-x64/bin/dorado aligner "$Assembly" "$Reads" --output-dir "$OutDir" -t "$cpu" --emit-summary

mapfile -t BAMS < <(find "$OutDir" -type f -name "*.bam" | sort)

if [[ "${#BAMS[@]}" -eq 0 ]]; then
    echo "ERROR: No BAM files found in $OutDir"
    exit 1
fi

echo "Found ${#BAMS[@]} BAM files:"
printf '  %s\n' "${BAMS[@]}"

AlignedBam="$OutDir/aligned.bam"

samtools merge -@ "$cpu" -o "$AlignedBam" "${BAMS[@]}"
samtools index -@ "$cpu" "$AlignedBam"

POLISH_CMD=(
    /data/users/theaven/software/dorado-2.1.2-linux-x64/bin/dorado
    polish "$AlignedBam" "$Assembly"
    -t "$cpu"
    -x cuda:all
    --output-dir "$OutDir"
    --models-directory /data/users/theaven/dorado_models
    --qualities
    --vcf
    --ambig-ref --ignore-read-groups
)

if [[ "$Bacteria" == "Y" ]]; then
    POLISH_CMD+=(--bacteria)
fi

if [[ "$Regions" != "NA" ]]; then
    POLISH_CMD+=(--regions "$Regions")
fi

echo "Running Dorado polish:"
printf ' %q' "${POLISH_CMD[@]}"
echo

"${POLISH_CMD[@]}"

rm "$AlignedBam"

seqkit fq2fa \
    "$OutDir/consensus.fastq" \
    -o "$OutDir/consensus.fasta"

~/git_repos/Scripts/unibz/dorado_polish_report2.sh \
--draft "$Assembly" \
--polished "$OutDir/consensus.fastq" \
--reads "$Reads" \
--vcf  "$OutDir/variants.vcf" \
--output "$OutDir/polishing_report.txt" \
--quast-dir "$OutDir/quast" \
--keep-bams

conda activate basic

echo DONE
echo
echo "OutDir:"
tree "${OutDir}"