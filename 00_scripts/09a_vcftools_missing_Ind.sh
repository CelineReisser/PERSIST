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

vcftools --vcf $INDIR/DP10_SNP_MAF0.O1_miss0.1_PERSIST_freebayes_stringent_biallelic.vcf --missing-indv &> 98_log_files/10a_vcftools_missInd.txt ;

sort -k 5 -nr $INDIR/out.miss > $INDIR/sorted_out.miss ;
rm $INDIR/out.miss ;

