#!/bin/bash
#SBATCH --job-name="VCF2Dis"
#SBATCH --partition=jic-medium
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem 4G
#SBATCH --time=1-00:00
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH #--mail-type=END,FAIL
#SBATCH #--mail-user=$USER@NBI.ac.uk

WorkDir=${PWD}${TMPDIR}_${SLURM_JOB_ID}
echo Input: $1
echo OutDir: $2
echo Outfile: $3
mkdir -p $WorkDir

if [[ $1 == *.gz ]]; then
  gzip -cd "$1" > "$WorkDir/vcf.vcf"
else
  cp "$1" "$WorkDir/vcf.vcf"
fi

cd $WorkDir


/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Aphididae/tools/VCF2Dis -InPut vcf.vcf -OutPut $2/$3

rm -r $WorkDir
echo DONE
