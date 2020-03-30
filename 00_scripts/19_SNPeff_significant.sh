#!/usr/bin/env bash
#PBS -q
#PBS -l walltime=24:00:00
#PBS -l mem=115g
#PBS -N snpeff_sig


SNPEFF=
DBNAME=
WORKDIR="/PERSIST"
INDIR="06_bayescan"
OUTDIR="07_SNPeff"
VCF=Bayescan_significant_vcf.vcf

cd $WORKDIR
mkdir -p $OUTDIR
cd $SNPEFF

java -Xmx115G -jar $SNPEFF/snpEff.jar $DBNAME $WORKDIR/$INDIR/$VCF > $WORKDIR/$OUTDIR/Bayescan_significant_vcf_annotated.vcf ;
mv $SNPEFF/snpEff_summary.html $WORKDIR/$OUTDIR/Bayescan_significant_vcf.html ;
mv $SNPEFF/snpEff_genes.txt $WORKDIR/$OUTDIR/Bayescan_significant_vcf.txt ;

