WORKDIR="/PERSIST"
ASSEMBLY="01_info_files/****.fasta"
BWA_ENV=""
INDIR="03_demultiplexed"
OUTDIR="04_mapped"
NAME='cat 00_scripts/base.txt'
SCRIPT="00_scripts/02_bwa"
HEADER="00_scripts/header.txt"

cd $WORKDIR

mkdir -p $SCRIPT
mkdir -p $OUTDIR

cd $WORKDIR

for FILE in $($NAME)
do
        cp $HEADER $SCRIPT/bwa_${FILE##*/}.qsub ;
        echo "#PBS -N bwa_mem_"$FILE" " >> $SCRIPT/bwa_${FILE##*/}.qsub ;
        echo "#PBS -o 98_log_files/bwa_mem_"$FILE".txt" >> $SCRIPT/bwa_${FILE##*/}.qsub ;
        echo "cd $WORKDIR/" >> $SCRIPT/bwa_${FILE##*/}.qsub ;
        echo "$BWA_ENV" >> $SCRIPT/bwa_${FILE##*/}.qsub ;
        echo "bwa mem -t 12 -M -R '@RG\tID:$FILE\tSM:$FILE\tPL:illumina\tLB:lib1\tPU:unit1' ${ASSEMBLY} $INDIR/"$FILE".fq.gz > $OUTDIR/"$FILE".sam" >> $SCRIPT/bwa_${FILE##*/}.qsub ;
        qsub $SCRIPT/bwa_${FILE##*/}.qsub ;
done ;


