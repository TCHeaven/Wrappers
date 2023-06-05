#!/bin/bash
#SBATCH --job-name=SweeD
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem-per-cpu=1G
#SBATCH --cpus-per-task=32
#SBATCH -p nbi-long
#SBATCH --time=30-00:00

#Collect inputs
CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
InFile=$1
OutDir=$2
OutFile=$3
Exclusion_list=$4

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo vcfFile:
echo $InFile
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo Exclusion_list:
echo $Exclusion_list
echo _
echo _

mkdir $OutDir

#Move to working directory
mkdir -p $WorkDir
cp $Exclusion_list $WorkDir/exclusion.txt
if [[ $InFile == *.gz ]]; then
  # File is compressed, uncompress it
  source package 01ef5a53-c149-4c9e-b07d-0b9a46176cc0
  bgzip -cd "$InFile" > "$WorkDir/vcf.vcf"
else
  # File is uncompressed, copy it to the destination directory
  cp "$InFile" "$WorkDir/vcf.vcf"
fi

cd $WorkDir

#Execute program
if [ -f "exclusion.txt" ]; then
    echo "There are exclusions:"
    cat exclusion.txt
    echo _
    echo _
    cut -f$(paste -s -d, <(awk 'BEGIN{ while((getline<"exclusion.txt")>0) entries[$1]=1 } { for(i=1;i<=NF;i++) { if($i in entries) { printf("%d,", i) } } }' vcf.vcf | sed 's/,$//')) --complement vcf.vcf > tempvcf.vcf && cp tempvcf.vcf vcf.vcf
else
    echo "No exclusions"
    echo _
    echo _
fi

source package /tgac/software/testing/bin/sweed-3.3.2
SweeD-P -name $OutFile -input vcf.vcf -grid 100000 -folded -threads 32 

#Collect Outputs
cp *${OutFile} $OutDir/.
echo DONE
rm -r $WorkDir
