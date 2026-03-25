#!/bin/bash
#SBATCH -o /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH -e /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH --mem 32G
#SBATCH --nodes=1
#SBATCH -c 12
#SBATCH --account=shame
#SBATCH --partition=bioagri
#SBATCH --time=02-00:00:00

set -euo pipefail

CurPath=$PWD
WorkDir="${TMPDIR:-/tmp}/${SLURM_JOB_ID}"
InDir="${1:?ERROR: Missing Input}"
Sample_Sheet="${2:?ERROR: Missing Sample Sheet}"
Amplicon="${3?ERROR: Missing Amplicon (16S or ITS)}"
OutDir="${4:?ERROR: Missing OutDir}"
Classifier="${5:-minimap2}"
shift 5

if [[ " $* " == *" --help "* || " $* " == *" -h "* ]]; then
    print_help
    exit 0
fi

[[ -d "$InDir" ]] || { echo "ERROR: Input directory not found"; exit 1; }
[[ -f "$Sample_Sheet" ]] || { echo "ERROR: Sample sheet not found"; exit 1; }

while [[ "$#" -gt 0 ]]; do
  case $1 in
    --database) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --database selected but no value given"; exit 1; }; Database="$2"; shift 2 ;;
    --exclude) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --exclude selected but no value given"; exit 1; }; exclude_host="$2"; shift 2 ;;
    --unclassified) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --unclassified selected but no value given"; exit 1; }; analyse_unclassified="$2"; shift 2 ;;
    --max_len) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --max_len selected but no value given"; exit 1; }; max_len="$2"; shift 2 ;;
    --min_len) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --min_len selected but no value given"; exit 1; }; min_len="$2"; shift 2 ;;
    --min_qual) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --min_qual selected but no value given"; exit 1; }; min_read_qual="$2"; shift 2 ;;
    --abundance) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --abundance selected but no value given"; exit 1; }; abundance_threshold="$2"; shift 2 ;;
    --rank) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --rank selected but no value given"; exit 1; }; taxonomic_rank="$2"; shift 2 ;;
    --pct) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --pct selected but no value given"; exit 1; }; min_percent_identity="$2"; shift 2 ;;
    --cov) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --cov selected but no value given"; exit 1; }; min_ref_coverage="$2"; shift 2 ;;
    --barplot) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --barplot selected but no value given"; exit 1; }; n_taxa_barplot="$2"; shift 2 ;;
    *) echo "Unknown parameter: $1"; exit 1 ;;
  esac
done

if [[ "$Amplicon" == "16S" ]]; then
: "${Database:=ncbi_16s_18s}"
: "${max_len:=2000}"
: "${min_len:=800}"
elif [[ "$Amplicon" == "ITS" ]]; then
: "${Database:=ncbi_16s_18s_28s_ITS}"
: "${max_len:=2000}"
: "${min_len:=300}"
else
echo "ERROR: amplicon must be '16S' or 'ITS'"
exit 1
fi

: "${analyse_unclassified:=False}"
if [[ "$analyse_unclassified" != "true" && "$analyse_unclassified" != "false" ]]; then
  echo "ERROR: analyse_unclassified must be 'true' or 'false'"
  exit 1
fi

: "${exclude_host:=N}"
: "${min_read_qual:=NA}"
: "${abundance_threshold:=0.0}"
: "${taxonomic_rank:=G}"
: "${min_percent_identity:=95}"
: "${min_ref_coverage:=90}"
: "${n_taxa_barplot:=9}"

cpu="${SLURM_CPUS_PER_TASK:-12}"

echo CurPth:
echo "$CurPath"
echo WorkDir:
echo "$WorkDir"
echo OutDir:
echo "$OutDir"
echo "CPUs: $cpu"

echo Input:
echo "$InDir"
echo Sample Sheet:
echo "$Sample_Sheet"
echo Amplicon:
echo "$Amplicon"
echo Database:
echo "$Database"
echo Classifier:
echo "$Classifier"
echo "Exclude?: $exclude_host"
echo "Max read length: $max_len"
echo "Min read length: $min_len"
echo "Min read quality: $min_read_qual"
echo "Min read abundance: $abundance_threshold"
echo "taxonomic rank if using braken: $taxonomic_rank"
echo "Min percent identity if using minimap2: $min_percent_identity"
echo "Min reference coverage if using minimap2: $min_ref_coverage"
echo "Analyse unclassified?: $analyse_unclassified"
echo _
echo _

cleanup() { echo "Cleaning up temp workspace: $WorkDir"; rm -rf "$WorkDir"; }
trap cleanup EXIT

print_help() {
cat <<EOF
Usage: $0 <InputDir> <SampleSheet> <Amplicon> <OutDir> [Classifier] [OPTIONS]

Positional arguments:
  InputDir           Path to input directory with reads
  SampleSheet        CSV sample sheet
  Amplicon           16S or ITS
  OutDir             Output directory
  Classifier         minimap2 (default) or kraken2

Optional flags:
  --database          Database to use (default depends on amplicon)
  --exclude           Host/sample to exclude (default: N)
  --unclassified      Analyse unclassified reads: True or False (default: False)
  --max_len           Maximum read length (default: 2000)
  --min_len           Minimum read length (16S:800, ITS:300)
  --min_qual          Minimum read quality (default: NA)
  --abundance         Minimum read abundance (default: 0.0)
  --rank              Taxonomic rank for Kraken2 (default: G)
  --pct               Minimum percent identity for minimap2 (default: 95)
  --cov               Minimum reference coverage for minimap2 (default: 90)
  --barplot           Number of taxa in barplot (default: 9)
  -h, --help          Show this help message and exit

Example:
  $0 reads/ samples.csv 16S output/ minimap2 --database ncbi_16s_18s --unclassified True
EOF
}

###############################################################################

mkdir -p "$WorkDir"
cd "$WorkDir"

module load apptainer/1.4.1-gcc-13.3.0-3
module load nextflow/23.10.1-gcc-12.1.0

export NXF_SINGULARITY_CACHEDIR=/data/users/theaven/.singularity-cache
export APPTAINER_CACHEDIR=/data/users/theaven/.apptainer-cache

NF_CMD=(
  nextflow run epi2me-labs/wf-16s
  --fastq "$InDir"
  --sample_sheet "$Sample_Sheet"
  --database_set "$Database"
  --min_len "$min_len"
  --max_len "$max_len"
  --abundance_threshold "$abundance_threshold"
  --analyse_unclassified "$analyse_unclassified"
  --out_dir "$OutDir"
  --include_read_assignments
  --output_unclassified
  --n_taxa_barplot "$n_taxa_barplot"
  --threads "$cpu"
  -profile singularity
  -resume
)

if [[ "$exclude_host" != "N" ]]; then
  NF_CMD+=(--exclude_host "$exclude_host")
fi

if [[ "$min_read_qual" != "NA" ]]; then
  NF_CMD+=(--min_read_qual "$min_read_qual")
fi

if [[ "$Classifier" == "minimap2" ]]; then
  NF_CMD+=(--classifier "$Classifier" --minimap2_by_reference --keep_bam False \
           --min_percent_identity "$min_percent_identity" \
           --min_ref_coverage "$min_ref_coverage")
elif [[ "$Classifier" == "kraken2" ]]; then
  NF_CMD+=(--classifier "$Classifier" --taxonomic_rank "$taxonomic_rank" \
           --bracken_threshold 10 --kraken2_memory_mapping False \
           --kraken2_confidence 0.0)
else
  echo "ERROR: classifier must be 'kraken2' or 'minimap2'"
  exit 1
fi


echo "Running Nextflow:"
printf '%q ' "${NF_CMD[@]}"
echo
"${NF_CMD[@]}"

###############################################################################

ls -lh

module load anaconda3
conda activate basic

echo DONE
echo
echo "OutDir:"
tree "${OutDir}"
