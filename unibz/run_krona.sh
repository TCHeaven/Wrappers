#!/bin/bash
#SBATCH -o /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH -e /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH --mem 4G
#SBATCH --nodes=1
#SBATCH -c 1
#SBATCH --account=shame
#SBATCH --partition=bioagri
#SBATCH --time=02-00:00:00

set -euo pipefail

# ==========================
# Usage:
# ./generate_krona.sh <EMU_output_dir> <Krona_output_dir>
# ==========================

EMU_DIR="${1:?Missing EMU output directory}"
KRONA_DIR="${2:?Missing Krona output directory}"

mkdir -p "$KRONA_DIR"

echo "Preparing hierarchical Krona input files..."
apptainer exec --bind /data:/data --bind /home/clusterusers/theaven:/home/clusterusers/theaven ~/git_repos/Containers/python3.sif python - << PYTHON
import pandas as pd
import glob
import os

EMU_DIR = "$EMU_DIR"
KRONA_DIR = "$KRONA_DIR"

os.makedirs(KRONA_DIR, exist_ok=True)

files = glob.glob(os.path.join(EMU_DIR, "*_rel-abundance.tsv"))

if not files:
    raise RuntimeError(f"No EMU _rel-abundance.tsv files found in {EMU_DIR}")

# canonical taxonomic order for Krona
tax_cols = ['superkingdom','phylum','class','order','family','genus','species']

for f in files:
    sample_name = os.path.basename(f).replace("_rel-abundance.tsv", "")
    df = pd.read_csv(f, sep="\t")

    # -----------------------------
    # 1. Normalize abundance column name
    # -----------------------------
    if "estimated_counts" in df.columns:
        count_col = "estimated_counts"
    elif "estimated counts" in df.columns:
        count_col = "estimated counts"
    else:
        raise ValueError(f"No count column found in {f}")

    # -----------------------------
    # 2. Ensure all tax columns exist (fill missing with empty string)
    # -----------------------------
    for col in tax_cols:
        if col not in df.columns:
            df[col] = ""

    # -----------------------------
    # 3. Build Krona table (order DOES matter here)
    # -----------------------------
    krona_df = df[[count_col] + tax_cols].fillna("")

    # ensure counts are numeric
    krona_df[count_col] = pd.to_numeric(krona_df[count_col], errors="coerce").fillna(0)

    krona_file = os.path.join(KRONA_DIR, f"{sample_name}_krona.txt")
    krona_df.to_csv(krona_file, sep="\t", index=False, header=False)

    print(f"Prepared Krona input for {sample_name}: {krona_file}")
PYTHON

echo "Generating Krona HTML plots..."
module load anaconda3
conda activate krona

for f in "$KRONA_DIR"/*_krona.txt; do
    sample=$(basename "$f" "_krona.txt")
    ktImportText "$f" -o "${KRONA_DIR}/${sample}_krona.html"
    echo "Krona plot created: ${sample}_krona.html"
done

echo "All Krona plots generated in $KRONA_DIR"


