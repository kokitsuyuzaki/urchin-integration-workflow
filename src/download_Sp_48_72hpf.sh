#!/bin/bash
#$ -l nc=4
#$ -p -50
#$ -r yes
#$ -q node.q

#SBATCH -n 4
#SBATCH --nice=50
#SBATCH --requeue
#SBATCH -p node03-06
SLURM_RESTART_COUNT=2

wget https://ftp.ncbi.nlm.nih.gov/geo/series/GSE155nnn/GSE155427/suppl/GSE155427%5FSp48and72%2Erds%2Egz -P data/Sp_48_72hpf/

cd data/Sp_48_72hpf/
gunzip GSE155427_Sp48and72.rds.gz
touch DOWNLOADED