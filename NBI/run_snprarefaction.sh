#!/bin/bash
#SBATCH --job-name=rarefaction
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 60G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH -p jic-medium
#SBATCH --time=1-00:00:00

CurPath=$PWD
#WorkDir=${TMPDIR}/${SLURM_JOB_ID}
WorkDir=${PWD}${TMPDIR}_${SLURM_JOB_ID}
InFile=$1
OutDir=$2
OutFile=$3
Reference=$4
replicates=$(($5 + 1))
Steps=$6
Exclusion_list=$7

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
echo Reference:
echo $Reference
echo Exclusion_list
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

cp $Reference $WorkDir/reference.fa.gz
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


Samples=$(zcat vcf.vcf.gz | grep -m1 '#CHROM' | cut -f10- | tr '\t' ','| sed "s/\([^,]\+\)/'\1'/g"| sed "s@'@@g")
echo Samples:
echo $Samples

scaffold_names=$(zcat reference.fa.gz | awk '/^>/ { printf("%s,", substr($0, 2)) } END { printf("\n") }'| sed "s/\([^,]\+\)/'\1'/g"| sed "s@'@@g")
scaffold_names=${scaffold_names%,}  # Remove the trailing comma
scaffold_lengths=$(zcat reference.fa.gz | awk '/^>/ { if (seqlen) printf("%s: %d, ", scaffold_name, seqlen); scaffold_name = substr($0, 2); seqlen = 0; next } { seqlen += length($0) } END { if (seqlen) printf("%s: %d\n", scaffold_name, seqlen) }')
echo Scaffolds and lengths
echo $scaffold_lengths

y=$(echo "$Samples" | tr ',' ' ' | wc -w)
echo Number of samples
echo $y

z=$(($y / $Steps))
if (( $(bc <<< "$z < 1") )); then
  x=1
else
  x=$(printf "%.0f" "$z")
fi

echo Intervals:
echo $x

list=""
number=1
while ((number <= y)); do
    list+="$number,"
    ((number += x))
done
list=${list%?}  # Remove the trailing comma
list_array=($(echo "$list" | tr ',' '\n'))
last_number=${list_array[-1]}

if [[ $last_number != $y ]]; then
    list+=",$y"
fi
iterations=$list

echo Iterations
echo $iterations
echo Replicates
echo $replicates

source package /tgac/software/testing/bin/bcftools-1.12
bcftools index -t vcf.vcf.gz

singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 /hpc-home/did23faz/git_repos/Scripts/NBI/genomic-SNP-rarefaction.py vcf.vcf.gz $Samples $scaffold_names "$scaffold_lengths" $iterations $replicates $OutFile

cp ${OutFile}* $OutDir/.
echo DONE
rm -r $WorkDir
