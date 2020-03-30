#!/usr/bin/env bash
#PBS -q
#PBS -l walltime=24:00:00
#PBS -l mem=20g
#PBS -o 98_log_files
#PBS -N vcftools

WORKDIR="/PERSIST"
INDIR="05_freebayes"
VCF=DP10_SNP_MAF0.01_miss0.1_PERSIST_freebayes_stringent_biallelic_IndFiltered.recode.vcf

cd $WORKDIR/$INDIR

grep "^#" $VCF > header.txt
awk '$4=="A"' $VCF > A.txt
awk '$4=="C"' $VCF > C.txt
awk '$4=="G"' $VCF > G.txt
awk '$4=="T"' $VCF > T.txt

cat A.txt C.txt G.txt T.txt > temp_$VCF
sort -k2 -n temp_$VCF | sort -k1 > sorted_temp_$VCF
cat header.txt sorted_temp_$VCF > DP10_SNP_MAF0.01_miss0.1_PERSIST_freebayes_stringent_biallelic_IndFiltered.recode_noComplex.vcf

rm temp_$VCF
rm sorted_temp_$VCF
rm header.txt
rm A.txt
rm C.txt
rm G.txt
rm T.txt
