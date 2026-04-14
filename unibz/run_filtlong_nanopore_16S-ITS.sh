#!/bin/bash
#SBATCH -o /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH -e /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH --mem 1G
#SBATCH --nodes=1
#SBATCH -c 1
#SBATCH --account=shame
#SBATCH --partition=bioagri
#SBATCH --time=0-02:00:00

print_help() {
cat <<EOF
Usage: $0 <OutDir> <Amplicon> <Reads> [OPTIONS]

Positional arguments:
  OutDir             Output directory
  Amplicon           Amplicon 
  Reads              Reads File (must be FASTQ format).
Optional flags:
  --max_len          Maximum read length (excluding clipped bp) (Default: 2000 for 16S, 1500 for ITS)
  --min_len          Minimun read length (excluding clipped bp) (Default: 800 for 16S, 300 for ITS)
  --min_mean_q       Minimum mean quality threshold (Default 70)
  --keep_percent     Eg. keep the best 90% of reads. This is measured by bp, not by read count. So this option throws out the worst 10% of read bases.
  --target_bases     Remove the worst reads until only eg. 500 Mbp remain (using unit suffix), useful for very large read sets. If the input read set is less than 500 Mbp, this setting will have no effect.
  --min_window_q     Minimum window quality threshold
  --window_size      Size of sliding window used when measuring window quality (default: 250)
  --length_weight    Adjust weight given to the length score (default: 1)
  --mean_q_weight    Adjust weight given to the mean quality score (default: 1)
  --window_q_weight  Adjust weight given to the window quality score (default: 1)
External references (if provided, read quality will be determined using these instead of from the Phred scores):
  --assembly         Reference mode - reference assembly in FASTA format
  --shortF           Reference mode - reference short reads in FASTQ format
  --shortR           Reference mode - reference short reads in FASTQ format
  --trim             Reference mode - Trim bases from the start and end of reads which do not match a k-mer in the reference. This ensures the each read starts and ends with good sequence.
  --split            Reference mode - Split reads whenever 500 consecutive bases fail to match a k-mer in the reference. This serves to remove very poor parts of reads while keeping the good parts. A lower value will split more aggressively and a higher value will be more conservative.
  -h, --help         Show this help message and exit

EOF
}

if [[ " $* " == *" --help "* || " $* " == *" -h "* ]]; then
    print_help
    exit 0
fi

#################################################################################################

CurPath=$PWD
WorkDir="${TMPDIR:-/tmp}/cutadapt_${SLURM_JOB_ID}"

cpu="${SLURM_CPUS_PER_TASK:-1}"
OutDir=${1:?ERROR: Missing Output Directory}
Amplicon=${2:?ERROR: Missing Amplicon}
Reads=${3:?ERROR: Missing reads}
shift 3

#Optional:
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --max_len) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --max_len selected but no value given"; exit 1; }; max_len="$2"; shift 2 ;;
    --min_len) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --min_len selected but no value given"; exit 1; }; min_len="$2"; shift 2 ;;
    --keep_percent) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --keep_percent selected but no value given"; exit 1; }; keep="$2"; shift 2 ;;
    --target_bases) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --target_bases selected but no value given"; exit 1; }; bases="$2"; shift 2 ;;
    --shortF) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --shortF selected but no value given"; exit 1; }; shortf="$2"; shift 2 ;;
    --shortR) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --shortR selected but no value given"; exit 1; }; shortr="$2"; shift 2 ;;
    --trim) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --trim selected but no value given"; exit 1; }; trim="$2"; shift 2 ;;
    --split) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --split selected but no value given"; exit 1; }; split="$2"; shift 2 ;;
    --mean_q_weight) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --mean_q_weight selected but no value given"; exit 1; }; q_weight="$2"; shift 2 ;;
    --length_weight) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --length_weight selected but no value given"; exit 1; }; l_weight="$2"; shift 2 ;;
    --window_q_weight) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --window_q_weight selected but no value given"; exit 1; }; w_weight="$2"; shift 2 ;;
    --min_mean_q) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --min_mean_q selected but no value given"; exit 1; }; min_q="$2"; shift 2 ;;
    --assembly) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --assembly selected but no value given"; exit 1; }; assembly="$2"; shift 2 ;;
    --min_window_q) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --min_window_q selected but no value given"; exit 1; }; min_w_q="$2"; shift 2 ;;
    --window_size) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --window_size selected but no value given"; exit 1; }; w_size="$2"; shift 2 ;;
    *) echo "Unknown parameter: $1"; exit 1 ;;
  esac
done

#Defaults
if [[ "$Amplicon" == "16S" ]]; then
: "${max_len:=2000}"
: "${min_len:=800}"
elif [[ "$Amplicon" == "ITS" ]]; then
: "${max_len:=1500}"
: "${min_len:=300}"
else
echo "ERROR: amplicon must be '16S' or 'ITS'"
exit 1
fi

: "${q_weight:=1}"
: "${l_weight:=1}"
: "${w_weight:=1}"
: "${min_q:=70}"
: "${w_size:=250}"

: "${keep:=NA}"
: "${bases:=NA}"
: "${shortf:=NA}"
: "${shortr:=NA}"
: "${trim:=NA}"
: "${split:=NA}"
: "${assembly:=NA}"
: "${min_w_q:=NA}"


echo "Running on node $SLURM_NODELIST"
echo "CurPath: $CurPath"
echo "WorkDir: $WorkDir"
echo "OutDir: $OutDir"
echo "Amplicon: $Amplicon"
echo "Max read length: $max_len"
echo "Min read length: $min_len"
echo "ReadFiles: $Reads"
echo "Minimum quality: $min_q"
echo "Minimum window quality $min_w_q"
echo "Window size $w_size"
echo "Keep percentage $keep"
echo "target bases $bases"
echo "Weights: quality - $q_weight length - $l_weight window - $w_weight"
echo "Reference short reads: $shortf $shortr"
echo "Reference assembly: $assembly"

echo _
echo _

cleanup() { echo "Cleaning up temp workspace: $WorkDir"; rm -rf "$WorkDir"; }
trap cleanup EXIT

set -euo pipefail

#################################################################################################
module load anaconda3
conda activate filtlong

mkdir -p "$WorkDir"
cd "$WorkDir"
mkdir -p "$OutDir"

FL_CMD=(
 --min_length "$min_len" --max_length "$max_len" --min_mean_q "$min_q"  --length_weight "$l_weight" --mean_q_weight "$q_weight" --window_q_weight "$w_weight" --window_size "$w_size"
)

if [[ "$keep" != "NA" ]]; then
  FL_CMD+=(--keep_percent "$keep")
fi
if [[ "$shortf" != "NA" ]]; then
  FL_CMD+=(--short_1 "$shortf")
fi
if [[ "$shortr" != "NA" ]]; then
  FL_CMD+=(--short_2 "$shortr")
fi
if [[ "$trim" != "NA" ]]; then
  FL_CMD+=(--trim )
fi
if [[ "$split" != "NA" ]]; then
  FL_CMD+=(--split "$split")
fi
if [[ "$assembly" != "NA" ]]; then
  FL_CMD+=(--assembly "$assembly")
fi
if [[ "$min_w_q" != "NA" ]]; then
  FL_CMD+=(--min_window_q "$min_w_q")
fi
if [[ "$bases" != "NA" ]]; then
  FL_CMD+=(--target_bases "$bases")
fi

filtlong "${FL_CMD[@]}" "$Reads" | gzip > "$OutDir"/$(basename "$Reads" | sed 's@\.fastq$@.filtlong.fastq@').gz

#################################################################################################

conda deactivate
conda activate basic

echo DONE
echo
echo "OutDir:"
tree "${OutDir}"
