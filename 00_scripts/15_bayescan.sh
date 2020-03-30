#!/usr/bin/env bash
#PBS -q
#PBS -l walltime=700:00:00
#PBS -l mem=115g
#PBS -l ncpus=56

WORKDIR="/PERSIST"
BAYESCAN=""
INDIR="06_bayescan"
NCPU=56

module load anaconda-py2.7/4.3.13

#conda create -n bayescan python=2.7 anaconda
#source activate bayescan
#conda install -c bioconda bayescan
#source deactivate bayescan

cd $WORKDIR

source activate bayescan

bayescan2 $INDIR/Bayescan_input.txt -snp -threads $NCPU -pr_odds 80 -n 50000 -od $INDIR -o Bayescan_out

