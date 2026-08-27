#!/bin/bash
#SBATCH -o /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH -e /home/clusterusers/theaven/slurm_records/slurm.%j.out
#SBATCH --mem 100G
#SBATCH --nodes=1
#SBATCH -c 12
#SBATCH --account=shame
#SBATCH --partition=bioagri
#SBATCH --time=02-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
InFile=$1
Database=$2
OutDir=$3
OutFile=$4

cpu="${SLURM_CPUS_PER_TASK:-12}"

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo Input:
echo $InFile
echo Database:
echo $Database
echo _
echo _

mkdir -p $WorkDir
ln -s $InFile $WorkDir/InFile.fa

cd $WorkDir

module load apptainer/1.4.1-gcc-13.3.0-3coysxn
apptainer exec --bind /data:/data --bind /home/clusterusers/theaven:/home/clusterusers/theaven /data/users/theaven/kraken2_2.17.1--pl5321h077b44d_0 kraken2 \
--db $Database \
--threads $cpu \
--output $WorkDir/${OutFile}_output.txt \
--unclassified-out $WorkDir/${OutFile}_unclassified-out.txt \
--classified-out $WorkDir/${OutFile}_classified-out.txt \
--report $WorkDir/${OutFile}_report.txt \
--use-names \
$WorkDir/InFile.fa

#mkdir ${OutDir}
cp ${OutFile}* ${OutDir}/.
echo DONE
rm -r $WorkDir
