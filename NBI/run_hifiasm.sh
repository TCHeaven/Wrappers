#!/bin/bash
#SBATCH --job-name=hifiasm
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 50G
#SBATCH -c 32
#SBATCH -p jic-long,nbi-long
#SBATCH --time=2-00:00:00

CurPath=$PWD
#WorkDir=${TMPDIR}/${SLURM_JOB_ID}
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
OutDir=$1
OutFile=$2
Genomesize=$3
Homozygous_coverage=$4
Min_contig=$5
Purge_haplotigs=$6
Kmer_cuttoff=$7
Overlap_iterations=$8
Kmer_size=$9
Similarity_threshold=${10}

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir
echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile

echo Genomesize:
echo $Genomesize
echo Homozygous_coverage:
echo $Homozygous_coverage
echo Min_contig:
echo $Min_contig
echo Purge_haplotigs:
echo $Purge_haplotigs
echo Kmer_cuttoff:
echo $Kmer_cuttoff
echo Overlap_iterations:
echo $Overlap_iterations
echo Kmer_size:
echo $Kmer_size
echo Similarity_threshold:
echo $Similarity_threshold

echo ReadFiles:
echo 1:
echo ${11}
echo 2:
echo ${12}
echo 3:
echo ${13}
echo 4:
echo ${14}
echo 5:
echo ${15}
echo 6:
echo ${16}
echo 7:
echo ${17}
echo 8:
echo ${18}
echo 9:
echo ${19}
echo 10:
echo ${20}
echo 11:
echo ${21}
echo 12:
echo ${22}
echo 13:
echo ${23}
echo 14:
echo ${24}
echo 15:
echo ${25}

echo _
echo _

mkdir -p $WorkDir

cp ${11} $WorkDir/fasta1.fq.gz
cp ${12} $WorkDir/fasta2.fq.gz
cp ${13} $WorkDir/fasta3.fq.gz
cp ${14} $WorkDir/fasta4.fq.gz
cp ${15} $WorkDir/fasta5.fq.gz
cp ${16} $WorkDir/fasta6.fq.gz
cp ${17} $WorkDir/fasta7.fq.gz
cp ${18} $WorkDir/fasta8.fq.gz
cp ${19} $WorkDir/fasta9.fq.gz
cp ${20} $WorkDir/fasta10.fq.gz
cp ${21} $WorkDir/fasta11.fq.gz
cp ${22} $WorkDir/fasta12.fq.gz
cp ${23} $WorkDir/fasta13.fq.gz
cp ${24} $WorkDir/fasta14.fq.gz
cp ${25} $WorkDir/fasta15.fq.gz

cd $WorkDir

#source hifiasm-0.16.1_CBG
#source package /tgac/software/testing/bin/hifiasm-0.19.4
source package /tgac/software/production/bin/abyss-1.3.5

if [[ -e fasta15.fq.gz ]]; then
    echo Running with 15
#hifiasm -t 32 -l $Purge_haplotigs --hg-size $Genomesize --hom-cov $Homozygous_coverage -c $Min_contig -D $Kmer_cuttoff -N $Overlap_iterations -k $Kmer_size -s $Similarity_threshold -o $OutFile fasta1.fq.gz fasta2.fq.gz fasta3.fq.gz fasta4.fq.gz fasta5.fq.gz fasta6.fq.gz fasta7.fq.gz fasta8.fq.gz fasta9.fq.gz fasta10.fq.gz fasta11.fq.gz fasta12.fq.gz fasta13.fq.gz fasta14.fq.gz fasta15.fq.gz
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/hifiasm_19.5.2.sif hifiasm -t 32 -l $Purge_haplotigs --hg-size $Genomesize --hom-cov $Homozygous_coverage -c $Min_contig -D $Kmer_cuttoff -N $Overlap_iterations -k $Kmer_size -s $Similarity_threshold -o $OutFile fasta1.fq.gz fasta2.fq.gz fasta3.fq.gz fasta4.fq.gz fasta5.fq.gz fasta6.fq.gz fasta7.fq.gz fasta8.fq.gz fasta9.fq.gz fasta10.fq.gz fasta11.fq.gz fasta12.fq.gz fasta13.fq.gz fasta14.fq.gz fasta15.fq.gz
elif [[ -e fasta14.fq.gz ]]; then
    echo Running with 14
#hifiasm -t 32 -l $Purge_haplotigs --hg-size $Genomesize --hom-cov $Homozygous_coverage -c $Min_contig -D $Kmer_cuttoff -N $Overlap_iterations -k $Kmer_size -s $Similarity_threshold -o $OutFile fasta1.fq.gz fasta2.fq.gz fasta3.fq.gz fasta4.fq.gz fasta5.fq.gz fasta6.fq.gz fasta7.fq.gz fasta8.fq.gz fasta9.fq.gz fasta10.fq.gz fasta11.fq.gz fasta12.fq.gz fasta13.fq.gz fasta14.fq.gz    
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/hifiasm_19.5.2.sif hifiasm -t 32 -l $Purge_haplotigs --hg-size $Genomesize --hom-cov $Homozygous_coverage -c $Min_contig -D $Kmer_cuttoff -N $Overlap_iterations -k $Kmer_size -s $Similarity_threshold -o $OutFile fasta1.fq.gz fasta2.fq.gz fasta3.fq.gz fasta4.fq.gz fasta5.fq.gz fasta6.fq.gz fasta7.fq.gz fasta8.fq.gz fasta9.fq.gz fasta10.fq.gz fasta11.fq.gz fasta12.fq.gz fasta13.fq.gz fasta14.fq.gz    
elif [[ -e fasta13.fq.gz ]]; then
    echo Running with 13
#hifiasm -t 32 -l $Purge_haplotigs --hg-size $Genomesize --hom-cov $Homozygous_coverage -c $Min_contig -D $Kmer_cuttoff -N $Overlap_iterations -k $Kmer_size -s $Similarity_threshold -o $OutFile fasta1.fq.gz fasta2.fq.gz fasta3.fq.gz fasta4.fq.gz fasta5.fq.gz fasta6.fq.gz fasta7.fq.gz fasta8.fq.gz fasta9.fq.gz fasta10.fq.gz fasta11.fq.gz fasta12.fq.gz fasta13.fq.gz    
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/hifiasm_19.5.2.sif hifiasm -t 32 -l $Purge_haplotigs --hg-size $Genomesize --hom-cov $Homozygous_coverage -c $Min_contig -D $Kmer_cuttoff -N $Overlap_iterations -k $Kmer_size -s $Similarity_threshold -o $OutFile fasta1.fq.gz fasta2.fq.gz fasta3.fq.gz fasta4.fq.gz fasta5.fq.gz fasta6.fq.gz fasta7.fq.gz fasta8.fq.gz fasta9.fq.gz fasta10.fq.gz fasta11.fq.gz fasta12.fq.gz fasta13.fq.gz    
elif [[ -e fasta12.fq.gz ]]; then
    echo Running with 12
#hifiasm -t 32 -l $Purge_haplotigs --hg-size $Genomesize --hom-cov $Homozygous_coverage -c $Min_contig -D $Kmer_cuttoff -N $Overlap_iterations -k $Kmer_size -s $Similarity_threshold -o $OutFile fasta1.fq.gz fasta2.fq.gz fasta3.fq.gz fasta4.fq.gz fasta5.fq.gz fasta6.fq.gz fasta7.fq.gz fasta8.fq.gz fasta9.fq.gz fasta10.fq.gz fasta11.fq.gz fasta12.fq.gz    
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/hifiasm_19.5.2.sif hifiasm -t 32 -l $Purge_haplotigs --hg-size $Genomesize --hom-cov $Homozygous_coverage -c $Min_contig -D $Kmer_cuttoff -N $Overlap_iterations -k $Kmer_size -s $Similarity_threshold -o $OutFile fasta1.fq.gz fasta2.fq.gz fasta3.fq.gz fasta4.fq.gz fasta5.fq.gz fasta6.fq.gz fasta7.fq.gz fasta8.fq.gz fasta9.fq.gz fasta10.fq.gz fasta11.fq.gz fasta12.fq.gz    
elif [[ -e fasta11.fq.gz ]]; then
    echo Running with 11
#hifiasm -t 32 -l $Purge_haplotigs --hg-size $Genomesize --hom-cov $Homozygous_coverage -c $Min_contig -D $Kmer_cuttoff -N $Overlap_iterations -k $Kmer_size -s $Similarity_threshold -o $OutFile fasta1.fq.gz fasta2.fq.gz fasta3.fq.gz fasta4.fq.gz fasta5.fq.gz fasta6.fq.gz fasta7.fq.gz fasta8.fq.gz fasta9.fq.gz fasta10.fq.gz fasta11.fq.gz    
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/hifiasm_19.5.2.sif hifiasm -t 32 -l $Purge_haplotigs --hg-size $Genomesize --hom-cov $Homozygous_coverage -c $Min_contig -D $Kmer_cuttoff -N $Overlap_iterations -k $Kmer_size -s $Similarity_threshold -o $OutFile fasta1.fq.gz fasta2.fq.gz fasta3.fq.gz fasta4.fq.gz fasta5.fq.gz fasta6.fq.gz fasta7.fq.gz fasta8.fq.gz fasta9.fq.gz fasta10.fq.gz fasta11.fq.gz    
elif [[ -e fasta10.fq.gz ]]; then
    echo Running with 10
#hifiasm -t 32 -l $Purge_haplotigs --hg-size $Genomesize --hom-cov $Homozygous_coverage -c $Min_contig -D $Kmer_cuttoff -N $Overlap_iterations -k $Kmer_size -s $Similarity_threshold -o $OutFile fasta1.fq.gz fasta2.fq.gz fasta3.fq.gz fasta4.fq.gz fasta5.fq.gz fasta6.fq.gz fasta7.fq.gz fasta8.fq.gz fasta9.fq.gz fasta10.fq.gz
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/hifiasm_19.5.2.sif hifiasm -t 32 -l $Purge_haplotigs --hg-size $Genomesize --hom-cov $Homozygous_coverage -c $Min_contig -D $Kmer_cuttoff -N $Overlap_iterations -k $Kmer_size -s $Similarity_threshold -o $OutFile fasta1.fq.gz fasta2.fq.gz fasta3.fq.gz fasta4.fq.gz fasta5.fq.gz fasta6.fq.gz fasta7.fq.gz fasta8.fq.gz fasta9.fq.gz fasta10.fq.gz
elif [[ -e fasta9.fq.gz ]]; then
    echo Running with 9
#hifiasm -t 32 -l $Purge_haplotigs --hg-size $Genomesize --hom-cov $Homozygous_coverage -c $Min_contig -D $Kmer_cuttoff -N $Overlap_iterations -k $Kmer_size -s $Similarity_threshold -o $OutFile fasta1.fq.gz fasta2.fq.gz fasta3.fq.gz fasta4.fq.gz fasta5.fq.gz fasta6.fq.gz fasta7.fq.gz fasta8.fq.gz fasta9.fq.gz
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/hifiasm_19.5.2.sif hifiasm -t 32 -l $Purge_haplotigs --hg-size $Genomesize --hom-cov $Homozygous_coverage -c $Min_contig -D $Kmer_cuttoff -N $Overlap_iterations -k $Kmer_size -s $Similarity_threshold -o $OutFile fasta1.fq.gz fasta2.fq.gz fasta3.fq.gz fasta4.fq.gz fasta5.fq.gz fasta6.fq.gz fasta7.fq.gz fasta8.fq.gz fasta9.fq.gz
elif [[ -e fasta8.fq.gz ]]; then
    echo Running with 8
#hifiasm -t 32 -l $Purge_haplotigs --hg-size $Genomesize --hom-cov $Homozygous_coverage -c $Min_contig -D $Kmer_cuttoff -N $Overlap_iterations -k $Kmer_size -s $Similarity_threshold -o $OutFile fasta1.fq.gz fasta2.fq.gz fasta3.fq.gz fasta4.fq.gz fasta5.fq.gz fasta6.fq.gz fasta7.fq.gz fasta8.fq.gz
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/hifiasm_19.5.2.sif hifiasm -t 32 -l $Purge_haplotigs --hg-size $Genomesize --hom-cov $Homozygous_coverage -c $Min_contig -D $Kmer_cuttoff -N $Overlap_iterations -k $Kmer_size -s $Similarity_threshold -o $OutFile fasta1.fq.gz fasta2.fq.gz fasta3.fq.gz fasta4.fq.gz fasta5.fq.gz fasta6.fq.gz fasta7.fq.gz fasta8.fq.gz
elif [[ -e fasta7.fq.gz ]]; then
    echo Running with 7
#hifiasm -t 32 -l $Purge_haplotigs --hg-size $Genomesize --hom-cov $Homozygous_coverage -c $Min_contig -D $Kmer_cuttoff -N $Overlap_iterations -k $Kmer_size -s $Similarity_threshold -o $OutFile fasta1.fq.gz fasta2.fq.gz fasta3.fq.gz fasta4.fq.gz fasta5.fq.gz fasta6.fq.gz fasta7.fq.gz
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/hifiasm_19.5.2.sif hifiasm -t 32 -l $Purge_haplotigs --hg-size $Genomesize --hom-cov $Homozygous_coverage -c $Min_contig -D $Kmer_cuttoff -N $Overlap_iterations -k $Kmer_size -s $Similarity_threshold -o $OutFile fasta1.fq.gz fasta2.fq.gz fasta3.fq.gz fasta4.fq.gz fasta5.fq.gz fasta6.fq.gz fasta7.fq.gz
elif [[ -e fasta6.fq.gz ]]; then
    echo Running with 6
#hifiasm -t 32 -l $Purge_haplotigs --hg-size $Genomesize --hom-cov $Homozygous_coverage -c $Min_contig -D $Kmer_cuttoff -N $Overlap_iterations -k $Kmer_size -s $Similarity_threshold -o $OutFile fasta1.fq.gz fasta2.fq.gz fasta3.fq.gz fasta4.fq.gz fasta5.fq.gz fasta6.fq.gz
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/hifiasm_19.5.2.sif hifiasm -t 32 -l $Purge_haplotigs --hg-size $Genomesize --hom-cov $Homozygous_coverage -c $Min_contig -D $Kmer_cuttoff -N $Overlap_iterations -k $Kmer_size -s $Similarity_threshold -o $OutFile fasta1.fq.gz fasta2.fq.gz fasta3.fq.gz fasta4.fq.gz fasta5.fq.gz fasta6.fq.gz
elif [[ -e fasta5.fq.gz ]]; then
    echo Running with 5
#hifiasm -t 32 -l $Purge_haplotigs --hg-size $Genomesize --hom-cov $Homozygous_coverage -c $Min_contig -D $Kmer_cuttoff -N $Overlap_iterations -k $Kmer_size -s $Similarity_threshold -o $OutFile fasta1.fq.gz fasta2.fq.gz fasta3.fq.gz fasta4.fq.gz fasta5.fq.gz
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/hifiasm_19.5.2.sif hifiasm -t 32 -l $Purge_haplotigs --hg-size $Genomesize --hom-cov $Homozygous_coverage -c $Min_contig -D $Kmer_cuttoff -N $Overlap_iterations -k $Kmer_size -s $Similarity_threshold -o $OutFile fasta1.fq.gz fasta2.fq.gz fasta3.fq.gz fasta4.fq.gz fasta5.fq.gz
elif [[ -e fasta4.fq.gz ]]; then
    echo Running with 4
#hifiasm -t 32 -l $Purge_haplotigs --hg-size $Genomesize --hom-cov $Homozygous_coverage -c $Min_contig -D $Kmer_cuttoff -N $Overlap_iterations -k $Kmer_size -s $Similarity_threshold -o $OutFile fasta1.fq.gz fasta2.fq.gz fasta3.fq.gz fasta4.fq.gz
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/hifiasm_19.5.2.sif hifiasm -t 32 -l $Purge_haplotigs --hg-size $Genomesize --hom-cov $Homozygous_coverage -c $Min_contig -D $Kmer_cuttoff -N $Overlap_iterations -k $Kmer_size -s $Similarity_threshold -o $OutFile fasta1.fq.gz fasta2.fq.gz fasta3.fq.gz fasta4.fq.gz
elif [[ -e fasta3.fq.gz ]]; then
    echo Running with 3
#hifiasm -t 32 -l $Purge_haplotigs --hg-size $Genomesize --hom-cov $Homozygous_coverage -c $Min_contig -D $Kmer_cuttoff -N $Overlap_iterations -k $Kmer_size -s $Similarity_threshold -o $OutFile fasta1.fq.gz fasta2.fq.gz fasta3.fq.gz
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/hifiasm_19.5.2.sif hifiasm -t 32 -l $Purge_haplotigs --hg-size $Genomesize --hom-cov $Homozygous_coverage -c $Min_contig -D $Kmer_cuttoff -N $Overlap_iterations -k $Kmer_size -s $Similarity_threshold -o $OutFile fasta1.fq.gz fasta2.fq.gz fasta3.fq.gz
elif [[ -e fasta2.fq.gz ]]; then
    echo Running with 2
#hifiasm -t 32 -l $Purge_haplotigs --hg-size $Genomesize --hom-cov $Homozygous_coverage -c $Min_contig -D $Kmer_cuttoff -N $Overlap_iterations -k $Kmer_size -s $Similarity_threshold -o $OutFile fasta1.fq.gz fasta2.fq.gz
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/hifiasm_19.5.2.sif hifiasm -t 32 -l $Purge_haplotigs --hg-size $Genomesize --hom-cov $Homozygous_coverage -c $Min_contig -D $Kmer_cuttoff -N $Overlap_iterations -k $Kmer_size -s $Similarity_threshold -o $OutFile fasta1.fq.gz fasta2.fq.gz
elif [[ -e fasta1.fq.gz ]]; then
    echo Running with 1
#hifiasm -t 32 -l $Purge_haplotigs --hg-size $Genomesize --hom-cov $Homozygous_coverage -c $Min_contig -D $Kmer_cuttoff -N $Overlap_iterations -k $Kmer_size -s $Similarity_threshold -o $OutFile fasta1.fq.gz
singularity exec /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/hifiasm_19.5.2.sif hifiasm -t 32 -l $Purge_haplotigs --hg-size $Genomesize --hom-cov $Homozygous_coverage -c $Min_contig -D $Kmer_cuttoff -N $Overlap_iterations -k $Kmer_size -s $Similarity_threshold -o $OutFile fasta1.fq.gz
else
    echo "No read files were provided"
fi

cp ${OutFile}.bp.p_ctg.gfa $OutDir/.
awk '/^S/{print ">"$2;print $3}' ${OutFile}.bp.p_ctg.gfa > ${OutFile}.bp.p_ctg.fa
abyss-fac ${OutFile}.bp.p_ctg.fa > $OutDir/abyss_report.txt


cp ${OutFile}* $OutDir/.
echo DONE
rm -r $WorkDir

