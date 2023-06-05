#!/bin/bash
#SBATCH --job-name=nei-from-vcf
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 10G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH -p jic-long
#SBATCH --time=1-0:00:00

#Collect inputs
CurPath=$PWD
WorkDir=${PWD}${TMPDIR}_${SLURM_JOB_ID}
InFile=$1
OutDir=$2
OutFile=$3

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo InFile:
echo $InFile
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile

echo _
echo _

#Move to Working Directory
mkdir -p $WorkDir

if [[ $InFile == *.gz ]]; then
  gzip -cd "$InFile" > "$WorkDir/vcf.vcf"
else
  cp "$InFile" "$WorkDir/vcf.vcf"
fi

cd $WorkDir

#Execute programmes
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 /hpc-home/did23faz/git_repos/Scripts/NBI/nei-from-vcf.py  --infile vcf.vcf --outfile $OutFile

#Collect Outputs
cp $OutFile $OutDir/.
echo DONE
#rm -r $WorkDir
