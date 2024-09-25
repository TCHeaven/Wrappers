#!/bin/bash
#SBATCH --job-name=cafe5
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 128G
#SBATCH -c 32
#SBATCH -p jic-long,nbi-long
#SBATCH --time=14-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}
OutDir=$1
OutFile=$2
Orthogroups=$3
Tree=$4
lamdaTree=$5
cpu=32

echo OutDir: $OutDir
echo OutFile: $OutFile
echo Orthogroups: $Orthogroups
echo Tree: $Tree
echo lamdaTree: $lamdaTree
echo __
echo __

mkdir $WorkDir
ln -s $Tree $WorkDir/tree.txt
ln -s $Orthogroups $WorkDir/counts.tsv
ln -s $lamdaTree $WorkDir/lamdatree.txt

cd $WorkDir
source /hpc-home/did23faz/mamba/bin/activate /hpc-home/did23faz/cafe5

cafe5 -i counts.tsv -t tree.txt -e
cp results/Base_error_model.txt error_model_047.txt

if [ -n "$lamdaTree" ] || [ "$lamdaTree" = "NA" ]; then
echo "Estimating a single λ for the whole tree"
cafe5 -i counts.tsv -t tree.txt -o ${OutDir}/${OutFile}_results -eerror_model_047.txt --cores $cpu 
cafe5 -i counts.tsv -t tree.txt -o ${OutDir}/${OutFile}_results_k3 -eerror_model_047.txt --cores $cpu -k 3 
cafe5 -i counts.tsv -t tree.txt -o ${OutDir}/${OutFile}_results_p_k3 -eerror_model_047.txt --cores $cpu -p -k 3 
else
echo "Estimating multiple λ for different parts of the tree"
cafe5 -i counts.tsv -t tree.txt -o ${OutDir}/${OutFile}_results -y lamdatree.txt -eerror_model_047.txt --cores $cpu 
cafe5 -i counts.tsv -t tree.txt -o ${OutDir}/${OutFile}_results_k3 -y lamdatree.txt -eerror_model_047.txt --cores $cpu -k 3 
cafe5 -i counts.tsv -t tree.txt -o ${OutDir}/${OutFile}_results_p_k3 -y lamdatree.txt -eerror_model_047.txt --cores $cpu -p -k 3 
fi

#singularity exec --overlay /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/overlays/cafe-plot.img:ro /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif cafeplotter -i ${OutDir}/${OutFile}_results -o ${OutDir}/${OutFile}_results
#singularity exec --overlay /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/overlays/cafe-plot.img:ro /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif cafeplotter -i ${OutDir}/${OutFile}_results_k3 -o ${OutDir}/${OutFile}_results_k3
#singularity exec --overlay /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/overlays/cafe-plot.img:ro /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/containers/python3.sif cafeplotter -i ${OutDir}/${OutFile}_results_p_k3 -o ${OutDir}/${OutFile}_results_p_k3

tree
rm -rf $WorkDir
