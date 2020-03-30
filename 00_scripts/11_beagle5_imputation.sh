#!/usr/bin/env bash
#PBS -q
#PBS -l walltime=24:00:00
#PBS -l mem=115g
#PBS -N beagle

WORKDIR="/PERSIST"
INDIR="05_freebayes"
BEAGLE=
VCF=DP10_SNP_MAF0.01_miss0.1_PERSIST_freebayes_stringent_biallelic_IndFiltered.recode_noComplex.vcf

cd $WORKDIR

cat $INDIR/$VCF | sed 's#.:.:.:.:.:.:.:.:.#./.:.:.:.:.:.:.:.:.#g' > $INDIR/vcf_input_beagle.vcf ;


java -Xmx115G -Djava.io.tmpdir=/home1/scratch/creisser/ -jar $BEAGLE gt=$INDIR/vcf_input_beagle.vcf out=$INDIR/DP10_SNP_MAF0.01_miss0.1_PERSIST_freebayes_stringent_biallelic_IndFiltered.recode_noComplex_imputed $> 98_log_files/11_beagle_out.txt;

rm $INDIR/vcf_input_beagle.vcf ;
gunzip $INDIR/DP10_SNP_MAF0.01_miss0.1_PERSIST_freebayes_stringent_biallelic_IndFiltered.recode_noComplex_imputed.vcf.gz ;

