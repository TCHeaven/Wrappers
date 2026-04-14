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
# sbatch ./run_krona_group.sh <EMU_output_dir> <Krona_output_dir> <Krona_output_prefix> <sample_list_file>
# ==========================

EMU_DIR="${1:?Missing EMU output directory}"
KRONA_DIR="${2:?Missing Krona output directory}"
PREFIX="${3:?Missing Krona output prefix}"
SAMPLE_LIST="${4:?Missing sample list file (one sample name per line)}"


mkdir -p "$KRONA_DIR"

echo "Preparing combined Krona input for samples from $SAMPLE_LIST..."

apptainer exec --bind /data:/data --bind /home/clusterusers/theaven:/home/clusterusers/theaven ~/git_repos/Containers/python3.sif python - << PYTHON
import pandas as pd
import os
import glob

EMU_DIR = "$EMU_DIR"
KRONA_DIR = "$KRONA_DIR"
SAMPLE_LIST_FILE = "$SAMPLE_LIST"

os.makedirs(KRONA_DIR, exist_ok=True)

# -------------------------
# sample list
# -------------------------
with open(SAMPLE_LIST_FILE) as f:
    sample_names = [x.strip() for x in f if x.strip()]

combined_rows = []

# Krona taxonomy order (IMPORTANT)
tax_cols = [
    "superkingdom",
    "phylum",
    "class",
    "order",
    "family",
    "genus",
    "species"
]

for sample_name in sample_names:
    fpath = os.path.join(EMU_DIR, f"{sample_name}_rel-abundance.tsv")

    if not os.path.isfile(fpath):
        print(f"WARNING: missing {fpath}, skipping")
        continue

    df = pd.read_csv(fpath, sep="\t")

    # -------------------------
    # detect abundance column
    # -------------------------
    if "estimated_counts" in df.columns:
        count_col = "estimated_counts"
    elif "estimated counts" in df.columns:
        count_col = "estimated counts"
    else:
        print(f"WARNING: no count column in {sample_name}, skipping")
        continue

    # -------------------------
    # ensure taxonomy columns exist
    # -------------------------
    for col in tax_cols:
        if col not in df.columns:
            df[col] = ""

    # -------------------------
    # force correct Krona structure
    # IMPORTANT ORDER:
    # count → sample → taxonomy
    # -------------------------
    df["sample"] = sample_name

    df = df[[count_col, "sample"] + tax_cols].copy()

    # ensure numeric counts
    df[count_col] = pd.to_numeric(df[count_col], errors="coerce").fillna(0)

    combined_rows.append(df)

if not combined_rows:
    raise RuntimeError("No valid EMU files found.")

combined_df = pd.concat(combined_rows, ignore_index=True)

out_file = os.path.join(KRONA_DIR, "all_samples_krona.txt")
combined_df.to_csv(out_file, sep="\t", index=False, header=False)

print(f"Written Krona input: {out_file}")
PYTHON

echo "Generating multi-sample Krona HTML plot..."
module load anaconda3
conda activate krona

ktImportText "${KRONA_DIR}/all_samples_krona.txt" -o "${KRONA_DIR}/${PREFIX}_krona.html"

echo "Multi-sample Krona plot created: ${KRONA_DIR}/${PREFIX}_krona.html"
