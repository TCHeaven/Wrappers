#!/bin/bash
#SBATCH --job-name=vcftools
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem-per-cpu=24G
#SBATCH --cpus-per-task=4
#SBATCH -p jic-long
#SBATCH --time=30-00:00

#Collect inputs
CurPath=$PWD
WorkDir=$CurPath/${TMPDIR}_${SLURM_JOB_ID}
InFile=$1
OutDir=$PWD/$2
OutFile=$3

range_start=10
range_end=$(($4 + 9))

echo $CurPath
echo $WorkDir
echo $InFile
echo $OutDir
echo $OutFile
echo $range_start
echo $range_end

source package /nbi/software/testing/bin/vcftools-0.1.15

#Move to working directory
mkdir -p $WorkDir
cp $InFile $WorkDir/population.vcf
cd $WorkDir

#Execute program
while (( range_end >= range_start ))
do
  rand_num=$(( $RANDOM % ($range_end - $range_start + 1) + $range_start ))
  echo $rand_num
  vcftools --gzvcf population.vcf --mac 1 -c 2>out.log
  cat out.log | grep "Sites" | awk '{print $4}' >> $OutFile
  cut -f${rand_num} --complement population.vcf > temp.txt && mv temp.txt population.vcf
  (( range_end-- ))
done

#Collect results
cp $OutFile $OutDir/.
rm -r $WorkDir
echo DONE
