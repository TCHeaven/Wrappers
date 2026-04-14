#!/bin/bash
#SBATCH -o /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH -e /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH --mem 1G
#SBATCH --nodes=1
#SBATCH -c 1
#SBATCH --account=shame
#SBATCH --partition=bioagri
#SBATCH --time=0-02:00:00

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
    *) echo "Unknown parameter: $1"; exit 1 ;;
  esac
done

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

echo "Running on node $SLURM_NODELIST"
echo "CurPath: $CurPath"
echo "WorkDir: $WorkDir"
echo "OutDir: $OutDir"
echo "Max read length: $max_len"
echo "Min read length: $min_len"
echo "ReadFiles: $Reads"

echo _
echo _

module load anaconda3
module load singularity/3.11.4 
conda activate seqkit-2.10

mkdir -p "$WorkDir"
cd "$WorkDir"
mkdir -p "$OutDir"

input_read="$Reads"
output_read="${OutDir}/$(basename ${input_read%.fastq}).trim.fastq"

if [[ "$Amplicon" == "16S" ]]; then
singularity exec --bind /data/users/theaven,/home/clusterusers/theaven ~/git_repos/Containers/cutadapt_5.2--py312h0fa9677_0 cutadapt -j "$cpu" \
-g "AGRGTTYGATYMTGGCTCAG" \
-g "AGAGTTTGATCCTGGCTTAG" \
-g "AGAATTTGATCTTRGTTCAG" \
-g "AGAGTTTGATCATGGCTCAG" \
-g "CTGAGCCAKRATCRAACYCT" \
-g "CTAAGCCAGGATCAAACTCT" \
-g "CTGAACYAAGATCAAATTCT" \
-g "CTGAGCCATGATCAAACTCT" \
-a "SGGYTACCTTGTTACGACTT" \
-a "CGGCTACCTTGTTACGACTT" \
-a "GGGCTACCTTGTTACGACTT" \
-a "AAGTCGTAACAAGGTARCCS" \
-a "AAGTCGTAACAAGGTAGCCG" \
-a "AAGTCGTAACAAGGTAGCCC" \
-e 0.15 \
--discard-untrimmed \
--trim-n \
-m "$min_len" -M "$max_len" \
-o "$output_read" \
"$input_read"

elif [[ "$Amplicon" == "ITS" ]]; then
singularity exec --bind /data/users/theaven,/home/clusterusers/theaven ~/git_repos/Containers/cutadapt_5.2--py312h0fa9677_0 cutadapt -j "$cpu" \
-g "TCCGTAGGTGAACCTGCGG" \
-g "TCCGTTGGTGAACCAGCGG" \
-g "TCTGTAGGTGAACCTGCAG" \
-g "CCGCAGGTTCACCTACGGA" \
-g "CCGCTGGTTCACCAACGGA" \
-g "CTGCAGGTTCACCTACAGA" \
-a "TCCTCCGCTTATTGATATGC" \
-a "TCCTCCGCTTATTAATATGC" \
-a "GCATATCAATAAGCGGAGGA" \
-a "GCATATTAATAAGCGGAGGA" \
-e 0.15 \
--discard-untrimmed \
--trim-n \
-m "$min_len" -M "$max_len" \
-o "$output_read" \
"$input_read"
else
echo "ERROR: amplicon must be '16S' or 'ITS'"
exit 1
fi

conda deactivate
conda activate basic

echo DONE
echo
echo "OutDir:"
tree "${OutDir}"
rm -r $WorkDir
