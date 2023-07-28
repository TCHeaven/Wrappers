#!/bin/bash
#SBATCH --job-name=create_sample_sequence_files_array
#SBATCH -o logs/create_sample_sequence_files_array/slurm.%A_%a.out
#SBATCH -e logs/create_sample_sequence_files_array/slurm.%A_%a.err
#SBATCH --mem 8G
#SBATCH -c 1
#SBATCH --ntasks-per-node=1
#SBATCH -p jic-medium,nbi-medium
#SBATCH --time=2-00:00:00
#SBATCH --array=1-50000%100  # Adjust the range based on the number of VCF files and tasks per job

# Define the list of VCF files as an array
VCF_FILES=(
    $(find $1 -name "*.vcf" -exec readlink -f {} \;)
)
gene_info_file=$2
reference_fasta=$3
OutDir=$4
logs=$5

# Check if the array index is within the bounds
if [[ $SLURM_ARRAY_TASK_ID -le ${#VCF_FILES[@]} ]]; then
    vcf_file=${VCF_FILES[$SLURM_ARRAY_TASK_ID - 1]}
    GeneName=$(echo $vcf_file| rev | cut -d '/' -f1 | rev | sed 's@dedup_@@g'| sed 's@_snps.vcf@@g')
    if [ -n "$GeneName" ]; then
        echo $GeneName
        echo "$GeneName" >> ${logs}
        OutFile=${GeneName}.fa
        echo $vcf_file >> ${logs}
        echo $OutFile >> ${logs}

        # Task execution begins here
        CurPath=$PWD
        WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}_${SLURM_ARRAY_TASK_ID}
        echo ${SLURM_JOB_ID}_${SLURM_ARRAY_TASK_ID} >> ${logs}
        echo CurPth:
        echo $CurPath
        echo WorkDir:
        echo $WorkDir
        echo vcfFile:
        echo $vcf_file
        echo OutDir:
        echo $OutDir
        echo OutFile:
        echo $OutFile
        echo fastaFile:
        echo $reference_fasta
        echo GeneInfoFile:
        echo $gene_info_file
        echo GeneName:
        echo $GeneName
        echo Logs:
        echo $logs
        echo _
        echo _

        mkdir -p $WorkDir

        cp $vcf_file $WorkDir/vcf.vcf
        grep -A 1 "$GeneName" $reference_fasta | cut -d ':' -f1 > $WorkDir/fasta.fa
        grep "$GeneName" $gene_info_file > $WorkDir/geneinfo.txt
        cd $WorkDir

        ls -lh $WorkDir

        singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif python3 /hpc-home/did23faz/git_repos/Scripts/NBI/create_sample_sequence_files.py geneinfo.txt vcf.vcf fasta.fa .

        touch hom_${OutFile}
        for file in $(ls *_REFERENCE.fasta); do
            echo $file
            header=$(echo $file | rev | cut -d '.' --complement -f1 | rev)
            echo $header
            #echo '>'${header} >> $OutFile
            cat $file >> hom_${OutFile}
            #echo >> $OutFile
        done

        for file in $(ls *_SAMPLE.fasta); do
            echo $file
            header=$(echo $file | rev | cut -d '_' --complement -f1 | rev)
            echo $header
            #echo '>'${header} >> $OutFile
            cat $file >> hom_$OutFile
            #echo >> $OutFile
        done

	pwd
	ls -lh *

        cp *${OutFile} $OutDir/.
        echo DONE
        rm -r $WorkDir
    fi
fi

