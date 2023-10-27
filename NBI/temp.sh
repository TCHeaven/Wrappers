#!/bin/bash
#SBATCH --job-name=bash
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err
#SBATCH --mem 50G
#SBATCH -c 16
#SBATCH -p jic-long
#SBATCH --time=30-00:00

source /nbi/software/staging/RCSUPPORT-2452/stagingloader

for Reads in $(ls /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_*/*/*.fastq.gz); do
OutDir=$(dirname $Reads)/meryl
mkdir $OutDir
meryl k=21 count output ${OutDir}/$(basename $Reads | sed 's@.fastq.gz@@g').meryl $Reads 
done

for Reads in $(ls /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/dna_qc/T_*/TellSeq/longranger/*.fastq.gz); do
OutDir=$(dirname $Reads)/meryl
mkdir $OutDir
meryl k=21 count output ${OutDir}/$(basename $Reads | sed 's@.fastq.gz@@g').meryl $Reads 
done

Assembly=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_urticae/hifiasm_19.5/715m/12/2/3.0/0.5/T_urticae_715m_12_2_3.0_0.5.bp.p_ctg.fa
mkdir -p $(dirname $Assembly)/meryl/Tellseq_trimmed
meryl union-sum output $(dirname $Assembly)/meryl/Tellseq_trimmed/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/dna_qc/T_urticae/TellSeq/longranger/meryl/*.meryl

mkdir -p $(dirname $Assembly)/merqury/Tellseq_trimmed
cd $(dirname $Assembly)/merqury/Tellseq_trimmed
ln -s $(dirname $Assembly)/meryl/Tellseq_trimmed/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl
ln -s $Assembly
meryl histogram $(dirname $Assembly)/meryl/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl > $(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl.hist
merqury.sh $(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl/ $(basename $Assembly) $(basename $Assembly | sed 's@.bp.p_ctg.fa@@g')
rm -r $(dirname $Assembly)/meryl/Tellseq_trimmed/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl

spectra_cn=$(ls *.spectra-cn.hist)
cn_only_hist=$(ls *.only.hist)
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_cn -o $(echo $spectra_cn | sed 's@.hist@@g')_1000 -z $cn_only_hist -m 1000 -n 6000000 
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_cn -o $(echo $spectra_cn | sed 's@.hist@@g')_300 -z $cn_only_hist -m 300 -n 6000000 
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_cn -o $(echo $spectra_cn | sed 's@.hist@@g')_100 -z $cn_only_hist -m 100 -n 6000000 
spectra_asm=$(ls *.spectra-asm.hist)
asm_only_host=$(ls *.dist_only.hist)
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_asm -o $(echo $spectra_asm | sed 's@.hist@@g')_1000 -z $asm_only_host -m 1000 -n 10000000 
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_asm -o $(echo $spectra_asm | sed 's@.hist@@g')_300 -z $asm_only_host -m 300 -n 10000000 
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_asm -o $(echo $spectra_asm | sed 's@.hist@@g')_100 -z $asm_only_host -m 100 -n 10000000 

cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae
mkdir temp
ln -s /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_urticae/HiFi temp/.
ln -s /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_urticae/HiC temp/.
ln -s /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/dna_qc/T_urticae/TellSeq/longranger temp/.
mkdir -p $(dirname $Assembly)/meryl/All_Tellseq_trimmed
meryl union-sum output $(dirname $Assembly)/meryl/All_Tellseq_trimmed/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl temp/*/meryl/*.meryl
rm -r temp

mkdir -p $(dirname $Assembly)/merqury/All_Tellseq_trimmed
cd $(dirname $Assembly)/merqury/All_Tellseq_trimmed
ln -s $(dirname $Assembly)/meryl/All_Tellseq_trimmed/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl
ln -s $Assembly
meryl histogram $(dirname $Assembly)/meryl/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl > $(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl.hist
merqury.sh $(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl/ $(basename $Assembly) $(basename $Assembly | sed 's@.bp.p_ctg.fa@@g')
rm -r $(dirname $Assembly)/meryl/All_Tellseq_trimmed/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl

spectra_cn=$(ls *.spectra-cn.hist)
cn_only_hist=$(ls *.only.hist)
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_cn -o $(echo $spectra_cn | sed 's@.hist@@g')_1000 -z $cn_only_hist -m 1000 -n 4000000 
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_cn -o $(echo $spectra_cn | sed 's@.hist@@g')_300 -z $cn_only_hist -m 300 -n 4000000 
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_cn -o $(echo $spectra_cn | sed 's@.hist@@g')_100 -z $cn_only_hist -m 100 -n 4000000 
spectra_asm=$(ls *.spectra-asm.hist)
asm_only_host=$(ls *.dist_only.hist)
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_asm -o $(echo $spectra_asm | sed 's@.hist@@g')_1000 -z $asm_only_host -m 1000 -n 6000000 
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_asm -o $(echo $spectra_asm | sed 's@.hist@@g')_300 -z $asm_only_host -m 300 -n 6000000 
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_asm -o $(echo $spectra_asm | sed 's@.hist@@g')_100 -z $asm_only_host -m 100 -n 6000000 




Assembly=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_apicales/hifiasm_19.5/880m/29/3/3.0/0.75/T_apicales_880m_29_3_3.0_0.75.bp.p_ctg.fa
mkdir -p $(dirname $Assembly)/meryl/Tellseq_trimmed
meryl union-sum output $(dirname $Assembly)/meryl/Tellseq_trimmed/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/dna_qc/T_apicales/TellSeq/longranger/meryl/*.meryl

mkdir -p $(dirname $Assembly)/merqury/Tellseq_trimmed
cd $(dirname $Assembly)/merqury/Tellseq_trimmed
ln -s $(dirname $Assembly)/meryl/Tellseq_trimmed/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl
ln -s $Assembly
meryl histogram $(dirname $Assembly)/meryl/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl > $(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl.hist
merqury.sh $(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl/ $(basename $Assembly) $(basename $Assembly | sed 's@.bp.p_ctg.fa@@g')
rm -r $(dirname $Assembly)/meryl/Tellseq_trimmed/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl

spectra_cn=$(ls *.spectra-cn.hist)
cn_only_hist=$(ls *.only.hist)
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_cn -o $(echo $spectra_cn | sed 's@.hist@@g')_1000 -z $cn_only_hist -m 1000 -n 6000000 
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_cn -o $(echo $spectra_cn | sed 's@.hist@@g')_300 -z $cn_only_hist -m 300 -n 6000000 
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_cn -o $(echo $spectra_cn | sed 's@.hist@@g')_100 -z $cn_only_hist -m 100 -n 6000000 
spectra_asm=$(ls *.spectra-asm.hist)
asm_only_host=$(ls *.dist_only.hist)
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_asm -o $(echo $spectra_asm | sed 's@.hist@@g')_1000 -z $asm_only_host -m 1000 -n 10000000 
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_asm -o $(echo $spectra_asm | sed 's@.hist@@g')_300 -z $asm_only_host -m 300 -n 10000000 
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_asm -o $(echo $spectra_asm | sed 's@.hist@@g')_100 -z $asm_only_host -m 100 -n 10000000 

cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae
mkdir temp
ln -s /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_apicales/HiFi temp/.
ln -s /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_apicales/HiC temp/.
ln -s /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/dna_qc/T_apicales/TellSeq/longranger temp/.
mkdir -p $(dirname $Assembly)/meryl/All_Tellseq_trimmed
meryl union-sum output $(dirname $Assembly)/meryl/All_Tellseq_trimmed/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl temp/*/meryl/*.meryl
rm -r temp

mkdir -p $(dirname $Assembly)/merqury/All_Tellseq_trimmed
cd $(dirname $Assembly)/merqury/All_Tellseq_trimmed
ln -s $(dirname $Assembly)/meryl/All_Tellseq_trimmed/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl
ln -s $Assembly
meryl histogram $(dirname $Assembly)/meryl/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl > $(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl.hist
merqury.sh $(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl/ $(basename $Assembly) $(basename $Assembly | sed 's@.bp.p_ctg.fa@@g')
rm -r $(dirname $Assembly)/meryl/All_Tellseq_trimmed/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl

spectra_cn=$(ls *.spectra-cn.hist)
cn_only_hist=$(ls *.only.hist)
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_cn -o $(echo $spectra_cn | sed 's@.hist@@g')_1000 -z $cn_only_hist -m 1000 -n 4000000 
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_cn -o $(echo $spectra_cn | sed 's@.hist@@g')_300 -z $cn_only_hist -m 300 -n 4000000 
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_cn -o $(echo $spectra_cn | sed 's@.hist@@g')_100 -z $cn_only_hist -m 100 -n 4000000 
spectra_asm=$(ls *.spectra-asm.hist)
asm_only_host=$(ls *.dist_only.hist)
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_asm -o $(echo $spectra_asm | sed 's@.hist@@g')_1000 -z $asm_only_host -m 1000 -n 6000000 
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_asm -o $(echo $spectra_asm | sed 's@.hist@@g')_300 -z $asm_only_host -m 300 -n 6000000 
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_asm -o $(echo $spectra_asm | sed 's@.hist@@g')_100 -z $asm_only_host -m 100 -n 6000000 




Assembly=/jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/assembly/genome/T_anthrisci/hifiasm_19.5/820m/48/1/10.0/0.25/T_anthrisci_820m_48_1_10.0_0.25.bp.p_ctg.fa
mkdir -p $(dirname $Assembly)/meryl/Tellseq_trimmed
meryl union-sum output $(dirname $Assembly)/meryl/Tellseq_trimmed/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/dna_qc/T_anthrisci/TellSeq/longranger/meryl/*.meryl

mkdir -p $(dirname $Assembly)/merqury/Tellseq_trimmed
cd $(dirname $Assembly)/merqury/Tellseq_trimmed
ln -s $(dirname $Assembly)/meryl/Tellseq_trimmed/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl
ln -s $Assembly
meryl histogram $(dirname $Assembly)/meryl/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl > $(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl.hist
merqury.sh $(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl/ $(basename $Assembly) $(basename $Assembly | sed 's@.bp.p_ctg.fa@@g')
rm -r $(dirname $Assembly)/meryl/Tellseq_trimmed/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl

spectra_cn=$(ls *.spectra-cn.hist)
cn_only_hist=$(ls *.only.hist)
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_cn -o $(echo $spectra_cn | sed 's@.hist@@g')_1000 -z $cn_only_hist -m 1000 -n 6000000 
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_cn -o $(echo $spectra_cn | sed 's@.hist@@g')_300 -z $cn_only_hist -m 300 -n 6000000 
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_cn -o $(echo $spectra_cn | sed 's@.hist@@g')_100 -z $cn_only_hist -m 100 -n 6000000 
spectra_asm=$(ls *.spectra-asm.hist)
asm_only_host=$(ls *.dist_only.hist)
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_asm -o $(echo $spectra_asm | sed 's@.hist@@g')_1000 -z $asm_only_host -m 1000 -n 10000000 
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_asm -o $(echo $spectra_asm | sed 's@.hist@@g')_300 -z $asm_only_host -m 300 -n 10000000 
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_asm -o $(echo $spectra_asm | sed 's@.hist@@g')_100 -z $asm_only_host -m 100 -n 10000000 

cd /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae
mkdir temp
ln -s /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_anthrisci/HiFi temp/.
ln -s /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/raw_data/T_anthrisci/HiC temp/.
ln -s /jic/scratch/groups/Saskia-Hogenhout/tom_heaven/Psyllidae/dna_qc/T_anthrisci/TellSeq/longranger temp/.
mkdir -p $(dirname $Assembly)/meryl/All_Tellseq_trimmed
meryl union-sum output $(dirname $Assembly)/meryl/All_Tellseq_trimmed/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl temp/*/meryl/*.meryl
rm -r temp

mkdir -p $(dirname $Assembly)/merqury/All_Tellseq_trimmed
cd $(dirname $Assembly)/merqury/All_Tellseq_trimmed
ln -s $(dirname $Assembly)/meryl/All_Tellseq_trimmed/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl
ln -s $Assembly
meryl histogram $(dirname $Assembly)/meryl/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl > $(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl.hist
merqury.sh $(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl/ $(basename $Assembly) $(basename $Assembly | sed 's@.bp.p_ctg.fa@@g')
rm -r $(dirname $Assembly)/meryl/All_Tellseq_trimmed/$(basename $Assembly | sed 's@.bp.p_ctg.fa@@g').meryl

spectra_cn=$(ls *.spectra-cn.hist)
cn_only_hist=$(ls *.only.hist)
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_cn -o $(echo $spectra_cn | sed 's@.hist@@g')_1000 -z $cn_only_hist -m 1000 -n 4000000 
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_cn -o $(echo $spectra_cn | sed 's@.hist@@g')_300 -z $cn_only_hist -m 300 -n 4000000 
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_cn -o $(echo $spectra_cn | sed 's@.hist@@g')_100 -z $cn_only_hist -m 100 -n 4000000 
spectra_asm=$(ls *.spectra-asm.hist)
asm_only_host=$(ls *.dist_only.hist)
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_asm -o $(echo $spectra_asm | sed 's@.hist@@g')_1000 -z $asm_only_host -m 1000 -n 6000000 
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_asm -o $(echo $spectra_asm | sed 's@.hist@@g')_300 -z $asm_only_host -m 300 -n 6000000 
Rscript /opt/software/merqury/plot/plot_spectra_cn.R -f $spectra_asm -o $(echo $spectra_asm | sed 's@.hist@@g')_100 -z $asm_only_host -m 100 -n 6000000 