#!/bin/bash
#SBATCH --job-name=vcf_stats
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 4G
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --ntasks-per-node=1
#SBATCH -p jic-medium
#SBATCH --time=0-10:00:00

CurPath=$PWD
#WorkDir=${TMPDIR}/${SLURM_JOB_ID}
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

mkdir -p $WorkDir

if [[ $InFile == *.gz ]]; then
  # File is already compressed, copy it to the destination directory
  cp "$InFile" "$WorkDir/vcf.vcf.gz"
else
  # File is uncompressed, compress it
  source package 01ef5a53-c149-4c9e-b07d-0b9a46176cc0
  bgzip -c "$InFile" > "${InFile}.gz"
  # Move the compressed file to the destination directory
  mv "${InFile}.gz" "$WorkDir/vcf.vcf.gz"
fi

cp $Exclusion_list $WorkDir/exclusion.txt
cd $WorkDir

if [ -f "exclusion.txt" ]; then
    echo "There are exclusions:"
    cat exclusion.txt
    echo _
    echo _
    source package 01ef5a53-c149-4c9e-b07d-0b9a46176cc0
    bgzip -cd vcf.vcf.gz > vcf.vcf
    cut -f$(paste -s -d, <(awk 'BEGIN{ while((getline<"exclusion.txt")>0) entries[$1]=1 } { for(i=1;i<=NF;i++) { if($i in entries) { printf("%d,", i) } } }' vcf.vcf | sed 's/,$//')) --complement vcf.vcf > tempvcf.vcf && cp tempvcf.vcf vcf.vcf
    bgzip -c vcf.vcf > vcf.vcf.gz
else
    echo "No exclusions"
    echo _
    echo _
fi

## vcftools 0.1.16
source package d37013e7-5691-40b6-8885-f029fe5fad54

vcftools --gzvcf vcf.vcf.gz --depth --out ${OutFile}_depth
vcftools --gzvcf vcf.vcf.gz --site-mean-depth --out ${OutFile}_site-mean-depth
vcftools --gzvcf vcf.vcf.gz --freq2 --out ${OutFile}_allele_freq --max-alleles 2
vcftools --gzvcf vcf.vcf.gz --counts2 --out ${OutFile}_allele_count
vcftools --gzvcf vcf.vcf.gz --site-quality --out ${OutFile}_site_qual
vcftools --gzvcf vcf.vcf.gz --missing-indv --out ${OutFile}_missing_ind
vcftools --gzvcf vcf.vcf.gz --missing-site --out ${OutFile}_missing_sites
vcftools --gzvcf vcf.vcf.gz --het --out ${OutFile}_het

cp ${OutFile}* $OutDir/.
echo DONE
rm -r $WorkDir
