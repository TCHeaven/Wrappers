#!/bin/bash
#SBATCH -o /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH -e /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH --mem 64G
#SBATCH --nodes=1
#SBATCH -c 8
#SBATCH --account=shame
#SBATCH --partition=bioagri
#SBATCH --time=02-00:00:00

#Mandatory:
CurPath=$PWD
WorkDir="${TMPDIR:-/tmp}/${SLURM_JOB_ID}"
InPut="${1:?ERROR: Missing Input}"
OutDir="${2:?ERROR: Missing OutDir}"
cpu="${SLURM_CPUS_PER_TASK:-12}"
shift 2

[[ -f "$InPut" ]] || { echo "ERROR: Sample sheet not found"; exit 1; }
[[ -d "$OutDir" ]] || { echo "ERROR: Output directory not found"; exit 1; }

#Optional:
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --database) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --database selected but no value given"; exit 1; }; Database="$2"; shift 2 ;;
    --taxonomy) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --database selected but no value given"; exit 1; }; Taxonomy="$2"; shift 2 ;;
    --max_len) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --max_len selected but no value given"; exit 1; }; max_len="$2"; shift 2 ;;
    --min_len) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --min_len selected but no value given"; exit 1; }; min_len="$2"; shift 2 ;;
    --type) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --type selected but no value given"; exit 1; }; type="$2"; shift 2 ;;
    --Amplicon) [[ -n "${2:-}" && "$2" != --* ]] || { echo "ERROR: --Amplicon selected but no value given"; exit 1; }; Amplicon="$2"; shift 2 ;;
    *) echo "Unknown parameter: $1"; exit 1 ;;
  esac
done

#Defaults:
: "${type:=map-ont}"
: "${Amplicon:=16S}"

if [[ "$Amplicon" == "16S" ]]; then
: "${Database:=/home/clusterusers/theaven/db/GTDB}"
: "${Taxonomy:=/home/clusterusers/theaven/db/GTDB/taxonomy.tsv}"
: "${max_len:=2000}"
: "${min_len:=800}"
elif [[ "$Amplicon" == "ITS" ]]; then
: "${Database:=/home/clusterusers/theaven/db/GTDB}"
: "${Taxonomy:=/home/clusterusers/theaven/db/GTDB/taxonomy.tsv}"
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
echo "$InPut"
echo Amplicon:
echo "$Amplicon"
echo Database:
echo "$Database"
echo Taxonomy:
echo "$Taxonomy"
echo Read type:
echo "$type"

echo "Maximum read length filter (bp): $max_len"
echo "Minimum read length filter (bp): $min_len"

echo _
echo _

cleanup() { echo "Cleaning up temp workspace: $WorkDir"; rm -rf "$WorkDir"; }
trap cleanup EXIT

print_help() {
cat <<EOF
Usage: $0 <Input> <OutDir> [OPTIONS]

Positional arguments:
  Input           Path to input directory with reads
  OutDir             Output directory

Optional flags:
  --Database          Database for use with emu (Default: /home/clusterusers/theaven/db/GTDB)
  --Taxonomy          Path to taxonomy TSV (Defaults: /home/clusterusers/theaven/db/GTDB/taxonomy.tsv)
  --Amplicon          Amplicon (default: 16S)
  --max_len           Maximum read length (excluding clipped bp) (Default: 2000)
  --min_len           Minimun read length (excluding clipped bp) (Default: 800)
  --type              Minimap2 preset (map-ont, map-pb, sr) (Default: map-ont)
  -h, --help          Show this help message and exit

EOF
}

if [[ " $* " == *" --help "* || " $* " == *" -h "* ]]; then
    print_help
    exit 0
fi

##############################################################################

#The auto downloaded ccuriqueo-vi-python-3.8.img is broken, a new version with ps needs to be built 
#from the .def file on the nanovi github and then placed in NXF_SINGULARITY_CACHEDIR with the correct name. 
#Cannot be built on the unibz HPC, done locally on own laptop.
#apptainer exec /data/users/theaven/singularity_cache/ccuriqueo-vi-python-3.8.img which ps
export NXF_SINGULARITY_CACHEDIR=/data/users/theaven/singularity_cache
export SINGULARITY_CACHEDIR=/data/users/theaven/singularity_cache
export APPTAINERENV_TMPDIR="$WorkDir"
#export SINGULARITY_BIND="/usr/bin/ps:/usr/bin/ps"
#export NXF_ENABLE_TASK_MONITORING=false
#export NXF_DISABLE_METRICS=true

module load apptainer/1.4.1-gcc-13.3.0-3  
module load openjdk/17.0.11_9-none-none-2c62zhf

ls $NXF_SINGULARITY_CACHEDIR
echo __
echo __

mkdir -p "$WorkDir"
cd "$WorkDir"

~/nextflow run microbialds/NanoVI -r v1.0.0 \
    --cmd abundance --output_dir "$OutDir" \
    --input "$InPut" \
    --db "$Database" \
    --taxonomy_tsv "$Taxonomy" \
    --kmer_size 21 --N 3 --K 4000000000 \
    --type map-ont \
    --min_length "$min_len" --max_length "$max_len" \
    --keep_counts true \
    --keep_files false \
    -profile singularity \
    -resume

###############################################################################

cp .nextflow.log /home/clusterusers/theaven/slurm_records/slurm.%j.out.nextflow.log

echo __
echo __
echo "Nextfloe log (.nextflow.log):"
cat .nextflow.log

ls -lh

module load anaconda3
conda activate basic

echo DONE
echo
echo "OutDir:"
tree "${OutDir}"