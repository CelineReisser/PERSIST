#!/usr/bin/env bash
#PBS -q
#PBS -l walltime=24:00:00
##PBS -l ncpus=4
#PBS -l mem=40g
#PBS -N vcftools_stat

WORKDIR="/PERSIST"
INDIR="05_freebayes"
VCFTOOLSENV=""
VCF1=PERSIST_noComplex_Collector.recode.vcf
VCF2=PERSIST_noComplex_Exploited.recode.vcf
VCF3=PERSIST_noComplex_Natural.recode.vcf
$VCFTOOLSENV

cd $WORKDIR

mkdir -p $INDIR/popgen_stats_popVCF

cd $INDIR

vcftools --site-pi --vcf $INDIR/$VCF1
mv $INDIR/out.sites.pi $INDIR/stats_popVCF/Collector_sites_pi.txt
vcftools --site-pi --vcf $INDIR/$VCF2
mv $INDIR/out.sites.pi $INDIR/stats_popVCF/Exploited_sites_pi.txt
vcftools --site-pi --vcf $INDIR/$VCF3
mv $INDIR/out.sites.pi $INDIR/stats_popVCF/Naturalsites_pi.txt
vcftools --het --vcf $INDIR/$VCF1
mv $INDIR/out.het $INDIR/stats_popVCF/Collector_het.txt
vcftools --het --vcf $INDIR/$VCF2
mv $INDIR/out.het $INDIR/stats_popVCF/Exploited_het.txt
vcftools --het --vcf $INDIR/$VCF3
mv $INDIR/out.het $INDIR/stats_popVCF/Natural_het.txt
