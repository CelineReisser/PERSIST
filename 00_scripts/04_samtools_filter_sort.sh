WORKING_DIRECTORY="/PERSIST"
SAMTOOLSENV=""
INDIR="04_mapped"
NAME='cat 00_scripts/base.txt'
SCRIPT="00_scripts/03_samtools_filter"
HEADER="00_scripts/header.txt"

mkdir -p $SCRIPT
mkdir -p $OUTDIR

cd $WORKDIR

for FILE in $($NAME)
do
        cp $HEADER $SCRIPT/samtools_${FILE##*/}.qsub ;
        echo "cd $WORKDIR/$INDIR" >> $SCRIPT/samtools_${FILE##*/}.qsub ;
        echo "$SAMTOOLSENV"  >> $SCRIPT/samtools_${FILE##*/}.qsub ;
        echo "samtools view -b -F4 -F 256 -q5 "$FILE".sam -o "$FILE".bam"  >> $SCRIPT/samtools_${FILE##*/}.qsub ;
        echo "samtools sort -@ 8 "$FILE".bam -o "$FILE".sorted.bam"  >> $SCRIPT/samtools_${FILE##*/}.qsub ;
        echo "samtools index -b "$FILE".sorted.bam" >> $SCRIPT/samtools_${FILE##*/}.qsub ;
        echo "rm "$FILE".bam" >> $SCRIPT/samtools_${FILE##*/}.qsub ;
        qsub $SCRIPT/samtools_${FILE##*/}.qsub ;
done ;

