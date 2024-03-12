#!/bin/bash
#SBATCH --job-name=hifiasm
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 50G
#SBATCH -c 32
#SBATCH -p jic-long,nbi-long
#SBATCH --time=2-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
OutDir=$1
OutFile=$2

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile

echo ReadFiles:
echo 1:
echo $3

echo _
echo _

mkdir -p $WorkDir

cd $WorkDir
source package /tgac/software/production/bin/abyss-1.3.5

singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/hifiasm_19.5.2.sif hifiasm -t 32  -o $OutFile $3

cp ${OutFile}.bp.p_ctg.gfa $OutDir/.
awk '/^S/{print ">"$2;print $3}' ${OutFile}.bp.p_ctg.gfa > ${OutFile}.bp.p_ctg.fa
abyss-fac ${OutFile}.bp.p_ctg.fa > $OutDir/abyss_report.txt

cp ${OutFile}* $OutDir/.
echo DONE
rm -r $WorkDir