#!/bin/bash
#SBATCH --job-name=haplomerger2
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 50G
#SBATCH -c 4
#SBATCH -p jic-medium,jic-long
#SBATCH --time=2-00:00:00

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

Assembly=$1

OutDir=${11}
OutFile=${12}

echo CurPth:
echo $CurPath
echo WorkDir:
echo $WorkDir

echo OutDir:
echo $OutDir
echo OutFile:
echo $OutFile
echo _
echo _

mkdir -p $WorkDir
cp /hpc-home/did23faz/git_repos/Scripts/NBI/Haplomerger2/all_lastz.ctl $WorkDir/.
cp /hpc-home/did23faz/git_repos/Scripts/NBI/Haplomerger2/scoreMatrix.q $WorkDir/.
cp /hpc-home/did23faz/git_repos/Scripts/NBI/Haplomerger2/hm.batchA1.initiation_and_all_lastz $WorkDir/.
cp /hpc-home/did23faz/git_repos/Scripts/NBI/Haplomerger2/hm.batchA2.chainNet_and_netToMaf $WorkDir/.
cp /hpc-home/did23faz/git_repos/Scripts/NBI/Haplomerger2/hm.batchA3.misjoin_processing $WorkDir/.
cp /hpc-home/did23faz/git_repos/Scripts/NBI/Haplomerger2/hm.batchB1.initiation_and_all_lastz $WorkDir/.
cp /hpc-home/did23faz/git_repos/Scripts/NBI/Haplomerger2/hm.batchB2.chainNet_and_netToMaf $WorkDir/.
cp /hpc-home/did23faz/git_repos/Scripts/NBI/Haplomerger2/hm.batchB3.haplomerger $WorkDir/.
cp /hpc-home/did23faz/git_repos/Scripts/NBI/Haplomerger2/hm.batchB4.refine_unpaired_sequences $WorkDir/.
cp /hpc-home/did23faz/git_repos/Scripts/NBI/Haplomerger2/hm.batchB5.merge_paired_and_unpaired_sequences $WorkDir/.
cp /hpc-home/did23faz/git_repos/Scripts/NBI/Haplomerger2/hm.batchC1.hierarchical_scaffolding $WorkDir/.
cp /hpc-home/did23faz/git_repos/Scripts/NBI/Haplomerger2/hm.batchC2.update_reference_and_alternative_assemblies $WorkDir/.
cp /hpc-home/did23faz/git_repos/Scripts/NBI/Haplomerger2/hm.batchD1.initiation_and_all_lastz $WorkDir/.
cp /hpc-home/did23faz/git_repos/Scripts/NBI/Haplomerger2/hm.batchD2.chainNet_and_netToMaf $WorkDir/.
cp /hpc-home/did23faz/git_repos/Scripts/NBI/Haplomerger2/hm.batchD3.remove_tandem_assemblies $WorkDir/.
cp /hpc-home/did23faz/git_repos/Scripts/NBI/Haplomerger2/hm.batchE1.wrapper_for_gapCloser_v1.12 $WorkDir/.

cd $WorkDir
source package 37f0ffda-9f66-4391-87e2-38ccd398861d
source package /tgac/software/production/bin/sspace-2.0
source package /tgac/software/production/bin/gapcloser-1.12

windowmasker

./hm.batchA1.initiation_and_all_lastz genome
./hm.batchA2.chainNet_and_netToMaf genome
./hm.batchA3.misjoin_processing genome

./hm.batchB1.initiation_and_all_lastz genome_A
./hm.batchB2.chainNet_and_netToMaf genome_A
./hm.batchB3.haplomerger genome_A
./hm.batchB4.refine_unpaired_sequences genome_A
./hm.batchB5.merge_paired_and_unpaired_sequences genome_A

./hm.batchC1.hierarchical_scaffolding genome_A_ref
./hm.batchC2.update_reference_and_alternative_assemblies genome_A_ref

./hm.batchD1.initiation_and_all_lastz genome_A_ref
./hm.batchD2.chainNet_and_netToMaf genome_A_ref
./hm.batchD3.remove_tandem_assemblies genome_A_ref

./hm.batchE1.wrapper_for_gapCloser_v1.12 genome_A_ref_C_D

echo DONE
#rm -r $WorkDir
