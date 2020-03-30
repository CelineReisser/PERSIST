#!/bin/bash
#PBS -q
#PBS -l walltime=600:00:00
#PBS -l mem=115g
##PBS -l ncpus=50
#PBS -N freebayes

WORKDIR="/PERSIST"
DATADIRECTORY="04_mapped"
OUTDIR="05_freebayes"
FREEBAYESENV=""
REF="01_info_files/***.fasta"
INDEX="01_info_files/***.fasta.fai"

#$FREEBAYESENV
cd $WORKDIR
mkdir -p $OUTDIR

LS="ls $DATADIRECTORY/*.sorted.bam"
$LS > 00_scripts/bam_list_freebayes.txt
BAM=00_scripts/bam_list_freebayes.txt

nAlleles=4
minMapQ=30
minCOV=2000

$FREEBAYESENV
freebayes -f $REF --use-best-n-alleles $nAlleles --min-mapping-quality $minMapQ --min-coverage $minCOV --genotype-qualities --bam-list $BAM --vcf $OUTDIR/PERSIST_freebayes_stringent.vcf &> 98_log_files/05_freebayes_out.txt

