#!/bin/bash
#SBATCH -o /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH -e /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH --mem 24G
#SBATCH --nodes=1
#SBATCH -c 12
#SBATCH --account=shame
#SBATCH --partition=bioagri
#SBATCH --time=02-00:00:00

set -euo pipefail

#Mandatory:
CurPath=$PWD
WorkDir="${TMPDIR:-/tmp}/${SLURM_JOB_ID}"
InDir="${1:?ERROR: Missing Input}"
Sample_Sheet="${2:?ERROR: Missing Sample Sheet}"
OutDir="${3:?ERROR: Missing OutDir}"
cpu="${SLURM_CPUS_PER_TASK:-12}"
shift 3

[[ -d "$InDir" ]] || { echo "ERROR: Input directory not found"; exit 1; }
[[ -f "$Sample_Sheet" ]] || { echo "ERROR: Sample sheet not found"; exit 1; }

#Optional:
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --database) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --database selected but no value given"; exit 1; }; Database="$2"; shift 2 ;;
    --max_len) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --max_len selected but no value given"; exit 1; }; max_len="$2"; shift 2 ;;
    --min_len) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --min_len selected but no value given"; exit 1; }; min_len="$2"; shift 2 ;;
    --abundance) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --abundance selected but no value given"; exit 1; }; abundance_threshold="$2"; shift 2 ;;
    --type) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --type selected but no value given"; exit 1; }; type="$2"; shift 2 ;;
    --min-pid) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --min-pid selected but no value given"; exit 1; }; min_percent_identity="$2"; shift 2 ;;
    --max_al) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --max_al selected but no value given"; exit 1; }; max_alignments_used="$2"; shift 2 ;;
    --Amplicon) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --Amplicon selected but no value given"; exit 1; }; Amplicon="$2"; shift 2 ;;
    *) echo "Unknown parameter: $1"; exit 1 ;;
  esac
done

#Defaults:
: "${abundance_threshold:=0.0001}"
: "${type:=map-ont}"
: "${min_percent_identity:=0}"
: "${max_alignments_used:=50}"
: "${Amplicon:=16S}"

if [[ "$Amplicon" == "16S" ]]; then
: "${Database:=/data/users/theaven/db/emu/emu2026}"
: "${max_len:=2000}"
: "${min_len:=800}"
elif [[ "$Amplicon" == "ITS" ]]; then
: "${Database:=/data/users/theaven/db/emu/unite-all}"
: "${max_len:=1500}"
: "${min_len:=300}"
else
echo "ERROR: amplicon must be '16S' or 'ITS'"
exit 1
fi

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
echo Read type:
echo "$type"

echo "Max alignment length: $max_len"
echo "Min alignment length: $min_len"
echo "Min relative abundance: $abundance_threshold"
echo "Min percent identity based on NM tag: $min_percent_identity"
echo "Max number of alignments utilized for each read in minimap2: $max_alignments_used"

echo _
echo _

cleanup() { echo "Cleaning up temp workspace: $WorkDir"; rm -rf "$WorkDir"; }
trap cleanup EXIT

print_help() {
cat <<EOF
Usage: $0 <InputDir> <SampleSheet> <OutDir> [OPTIONS]

Positional arguments:
  InputDir           Path to input directory with reads
  SampleSheet        CSV sample sheet giving sample-barcode pairs
  OutDir             Output directory

Optional flags:
  --Database          Database for use with emu (Default: /data/users/theaven/db/emu/emu2026)
  --Amplicon          Amplicon (default: 16S)
  --max_len           Maximum aligned query length (excluding clipped bp) (Default: 2000)
  --min_len           Minimun aligned query length (excluding clipped bp) (Default: 800)
  --abundance         Generates results with species relative abundance above this value in addition to full results; .01 = 1% (Default: 0.0001)
  --min-pid           Minimum percent identity (PID) based on NM tag (Default: 0)
  --type              Denote sequencer [short-read:sr, Pac-Bio:map-pb, ONT:map-ont, Nanopore Q20:lr:hq, PacBio HiFi:map-hifi, traditional cDNA:splice:hq] (Default: map-ont)
  --max_al            Max number of alignments utilized for each read in minimap2 (Default: 50)
  -h, --help          Show this help message and exit

EOF
}

if [[ " $* " == *" --help "* || " $* " == *" -h "* ]]; then
    print_help
    exit 0
fi

###############################################################################

mkdir -p "$WorkDir"
cd "$WorkDir"

module load anaconda3
module load seqtk/1.4-gcc-12.3.0
conda activate emu

sed -i 's/\r$//' "$Sample_Sheet"

while IFS=, read -r barcode sample; do
  [[ "$barcode" == "barcode" ]] && continue 

  src="${InDir}/${barcode}.fastq"
  fasta="./${sample}.fasta"

  if [[ -f "$src" ]]; then
    seqtk seq -a "$src" > "$fasta"
    echo "Running emu for $sample"
    emu abundance --type "$type" \
      --min-abundance "$abundance_threshold" \
      --db "$Database" \
      --N "$max_alignments_used" \
      --K 500000000 \
      --min-pid "$min_percent_identity" \
      --min-align-len "$min_len" \
      --max-align-len "$max_len" \
      --output-dir "$OutDir" \
      --keep-counts \
      --keep-read-assignments \
      --output-unclassified \
      --threads "$cpu" \
      "$fasta"

  else
    echo "WARNING: File not found for $barcode"
  fi
done < "$Sample_Sheet"

###############################################################################

ls -lh

conda activate basic

echo DONE
echo
echo "OutDir:"
tree "${OutDir}"
touch "${OutDir}"/track.txt