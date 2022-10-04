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

wget https://ftp.ncbi.nlm.nih.gov/geo/series/GSE149nnn/GSE149221/suppl/GSE149221%5FSpInteg%2Erds%2Egz -P data/Sp_2.75-28hpf/

cd data/Sp_2.75-28hpf/
gunzip GSE149221_SpInteg.rds.gz
touch DOWNLOADED