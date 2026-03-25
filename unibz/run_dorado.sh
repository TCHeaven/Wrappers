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
OutFmt="${3:?ERROR: Missing Output Formay}"
Barcode="${4:-NA}"
Remora="${5:-NA}"

cpu="${SLURM_CPUS_PER_TASK:-16}"
Half_cpu=$((cpu / 2))
Quarter_cpu=$((cpu / 4))

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
echo "CPUs: $cpu"
echo _
echo _

cleanup() { echo "Cleaning up temp workspace: $WorkDir"; rm -rf "$WorkDir"; }
trap cleanup EXIT

mkdir -p $WorkDir
cd $WorkDir

module load apptainer/1.4.1-gcc-13.3.0-3
module load nextflow/23.10.1-gcc-12.1.0

export NXF_SINGULARITY_CACHEDIR=/data/users/theaven/Ips_jam_project/.singularity-cache
export APPTAINER_CACHEDIR=/data/users/theaven/Ips_jam_project/.apptainer-cache

NF_CMD="nextflow run epi2me-labs/wf-basecalling \
  --basecaller_cfg 'dna_r10.4.1_e8.2_400bps_sup@v5.2.0' \
  --dorado_ext 'pod5' \
  --input '$InDir' \
  --out_dir '$OutDir' \
  --output_fmt '$OutFmt' \
  --cuda_device 'cuda:all' \
  -profile singularity \
  --ubam_map_threads $cpu \
  --ubam_sort_threads $Half_cpu \
  --ubam_bam2fq_threads $Quarter_cpu \
  --merge_threads $Half_cpu \
  -resume"

if [[ "$Barcode" != "NA" ]]; then
    NF_CMD="$NF_CMD --barcode_kit '$Barcode'"
fi

if [[ "$Remora" != "NA" ]]; then
    NF_CMD="$NF_CMD --remora_cfg '$Remora'"
fi

echo "Running Nextflow:"
echo "$NF_CMD"
eval "$NF_CMD"

ls -lh

module load anaconda3 
conda activate basic

echo DONE
echo
echo "OutDir:"
tree "${OutDir}"

