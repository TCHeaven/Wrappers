#!/bin/bash
#SBATCH --job-name=structure
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 4G
#SBATCH --nodes=1
#SBATCH -c 1
#SBATCH -p nbi-long,jic-long
#SBATCH --time=30-00:00:00

#First argument: input STRUCTURE file
#Second argument: ploidy (value: 1|2)
#Third argument: K being tested (value: integer)
#Fourth argument: number of replicate runs (value: integer)
#Can change the number of burn-in and run replicates in the mainparams file
#Assumes that number of individuals = max number of populations (can change it below)
#Example usage: sh ./execute_structure.sh test.struc 1 1 3

CurPath=$PWD
WorkDir=$PWD${TMPDIR}_${SLURM_JOB_ID}

InFile=$1
ploidy=$2
k=$3
n=$4
burn=$5
r=$6
OutDir=$7
OutFile=$8

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
echo Ploidy:
echo $ploidy
echo K being tested:
echo $k
echo Number of replicate runs:
echo $n
echo reps:
echo $r
echo Burn in reps:
echo $b
echo _
echo _

### Prep
mkdir -p ${WorkDir}/structure_$k\_$n
cp ~/git_repos/Scripts/NBI/mainparams.txt ${WorkDir}/structure_${k}\_${n}/.
cp ~/git_repos/Scripts/NBI/extraparams.txt ${WorkDir}/structure_${k}\_${n}/.
cp $InFile ${WorkDir}/structure_${k}\_${n}/.
cd ${WorkDir}/structure_${k}\_${n}

# Substitute in the config file for the current run:
#input file name
sed -i 's,^\(#define INFILE \).*,\1'"$InFile"',' mainparams.txt
#output
#sed -i 's,^\(#define OUTFILE \).*,\1'"$cdir/$outfile"',' mainparams.txt
#ploidy
sed -i 's,^\(#define PLOIDY \).*,\1'"$ploidy"',' mainparams.txt
#number of loci
a=`awk '{print $NF}' $InFile | head -1 | sed 's/SNP_//'`
sed -i 's,^\(#define NUMLOCI \).*,\1'"$a"',' mainparams.txt
#number of inds
b=`wc -l <$InFile`
c=$(( (b - 1) / ploidy ))
sed -i 's,^\(#define NUMINDS \).*,\1'"$c"',' mainparams.txt
#number of pops = number of inds
sed -i 's,^\(#define MAXPOPS \).*,\1'"$c"',' mainparams.txt
sed -i 's,^\(#define BURNIN \).*,\1'"$burn"',' mainparams.txt
sed -i 's,^\(#define NUMREPS \).*,\1'"$r"',' mainparams.txt

source package /nbi/software/testing/bin/structure-2.3.4
for ((i=1;i<=$n;i++))
do
    structure -K $k -o ${OutFile}_k${k}_${i} -m mainparams.txt -e extraparams.txt 
done

cp -r ${WorkDir}/structure_${k}\_${n} $OutDir

echo DONE
