#!/bin/bash
#PBS -q
#PBS -l walltime=20:00:00
#PBS -l mem=60g
#PBS -N make_bayescan_input

WORKDIR="/PERSIST"
INDIR=06_bayescan
RCODE=00_scripts/make_bayescan_input.R

cd $WORKDIR

mkdir -p $INDIR

source activate vcfR

Rscript --vanilla $RCODE &> 00_scripts/make_bayescan_input_R.out ;

source deactivate vcfR

echo '[populations]=3' >> $INDIR/head.txt ;
sed -i '1 i\[loci]=6335' $INDIR/head.txt ;

sed -i '1 i\[pop]=1' $INDIR/Collector_bayescan_input.txt ;
sed -i '1 i\[pop]=2' $INDIR/Exploited_bayescan_input.txt ;
sed -i '1 i\[pop]=3' $INDIR/Natural_bayescan_input.txt ;

cat $INDIR/head.txt $INDIR/Collector_bayescan_input.txt $INDIR/Exploited_bayescan_input.txt $INDIR/Natural_bayescan_input.txt > $INDIR/Bayescan_input.txt ;

rm $INDIR/head.txt
rm $INDIR/Collector_bayescan_input.txt
rm $INDIR/Exploited_bayescan_input.txt
rm $INDIR/Natural_bayescan_input.txt



