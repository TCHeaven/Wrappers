#!/bin/bash
#SBATCH --job-name=fcs
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 500G
#SBATCH --nodes=1
#SBATCH -c 48
#SBATCH -p jic-largemem
#SBATCH --time=00-02:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

fasta=$1
TAXID=$2
OutDir=$3
OutFile=$4
cpu=48

echo Genome:
echo ${fasta}
echo TAXID:
echo ${TAXID}
echo OutDir:
echo ${OutDir}
echo OutFile:
echo ${OutFile}

mkdir $WorkDir
cd $WorkDir
cp ${fasta} ./genome.fa
GX_NUM_CORES=${cpu}
source package 1413a4f0-44e3-4b9d-b6c6-0f5c0048df88
export FCS_DEFAULT_IMAGE=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/fcs-gx.sif
python3 /hpc-home/did23faz/git_repos/Scripts/NBI/fcs.py screen genome --fasta ./genome.fa --out-dir ${OutDir} --out-basename ${OutFile} --gx-db "/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/databases/fcs/gxdb/all" --tax-id ${TAXID}

cat ${fasta} | python3 /hpc-home/did23faz/git_repos/Scripts/NBI/fcs.py clean genome --action-report ${OutDir}/${OutFile}.fcs_gx_report.txt --output ${OutDir}/${OutFile}_clean.fasta --contam-fasta-out ${OutDir}/${OutFile}_contam.fasta

echo DONE
rm -r $WorkDir
