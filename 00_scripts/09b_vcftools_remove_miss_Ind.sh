#!/usr/bin/env bash
#PBS -q
#PBS -l walltime=24:00:00
#PBS -l mem=115g
#PBS -N vcftools

WORKDIR="/PERSIST"
INDIR="05_freebayes"
VCFTOOLSENV=""

$VCFTOOLSENV
cd $WORKDIR

vcftools --remove-indv blanc2 --remove-indv blanc1 --remove-indv C1_3 --remove-indv C1_2 --remove-indv S6_6 --remove-indv C1_5 --remove-indv S2_5 --remove-indv S2_24.bis --remove-indv C4_4 --recode --vcf $INDIR/DP10_SNP_MAF0.01_miss0.1_PERSIST_freebayes_stringent_biallelic.vcf --out $INDIR/DP10_SNP_MAF0.01_miss0.1_PERSIST_freebayes_stringent_biallelic_IndFiltered &> 98_log_files/10b_vcftools_remove_missInd.txt
