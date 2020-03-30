#!/usr/bin/env bash
#PBS -q
#PBS -l walltime=24:00:00
#PBS -l mem=115g
#PBS -N vcffilter

WORKDIR="/PERSIST"
INDIR=/05_freebayes
VCFLIBENV=""

$VCFLIBENV
cd $WORKDIR

vcffilter -g "DP > 10" -f "TYPE = snp" $INDIR/PERSIST_freebayes_stringent.vcf > $INDIR/DP10_SNP_PERSIST_freebayes_stringent.vcf &> 98_log_files/06_vcffilter_out.txt

