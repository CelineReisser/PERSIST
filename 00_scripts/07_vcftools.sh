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

vcftools --maf 0.01 --max-missing 0.9 --vcf $INDIR/DP10_SNP_PERSIST_freebayes_stringent.vcf --recode --out $INDIR/DP10_SNP_MAF0.01_miss0.1_PERSIST_freebayes_stringent &> 98_log_files/07_vcftools_out.txt

