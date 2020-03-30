#!/usr/bin/env bash
#PBS -q
#PBS -l walltime=24:00:00
#PBS -l mem=115g
#PBS -N BCFtools

WORKDIR="/PERSIST"
INDIR/="05_freebayes"
BCFLIBENV=""

$BCFLIBENV
cd $WORKDIR

# Goal: remove the multi allelic list
# Manual for bcftools : http://samtools.github.io/bcftools/bcftools.html#view
# Use -m2 -M2 -v snps to only view biallelic SNPs.

bcftools view -m2 -M2 -v snps $INDIR/DP10_SNP_MAF0.01_miss0.1_PERSIST_freebayes_stringent.recode.vcf -o $INDIR/DP10_SNP_MAF0.01_miss0.1_PERSIST_freebayes_stringent_biallelic.vcf &> 98_log_files/08_BCFtools.txt

