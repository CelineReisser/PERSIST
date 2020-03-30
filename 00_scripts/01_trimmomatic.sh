WORKDIR="/PERSIST"
DATADIRECTORY=02_data/raw
DATAOUTPUT=02_data
SCRIPT=00_scripts/01_trimmomatic_se
HEADER=00_scripts/header_cpus.txt
TRIMMOMATICENV=""
ADAPTERFILE=00_scripts/adapters.txt

mkdir -p $WORKDIR/$DATAOUTPUT/plate1
mkdir -p $WORKDIR/$DATAOUTPUT/plate2
mkdir -p $WORKDIR/$DATAOUTPUT/plate3
mkdir -p $WORKDIR/98_log_files

cd $WORKDIR/$DATADIRECTORY
LS="ls *fastq.gz"
$LS > $WORKDIR/00_scripts/name_raw.txt
NAME="cat $WORKDIR/00_scripts/name_raw.txt"

NCPU=16

cd $WORKDIR

for FILE in $($NAME) ; do
        cp $HEADER $SCRIPT/trimmomatic_${FILE##*/}.qsub ;
        echo "#PBS -o 98_log_files/trimmomatic_${FILE##*/}.txt" >> $SCRIPT/trimmomatic_${FILE##*/}.qsub ;
        echo "#PBS -N trimmomatic_${FILE##*/}"  >> $SCRIPT/trimmomatic_${FILE##*/}.qsub ;
        echo "cd $DATADIRECTORY" >> $SCRIPT/trimmomatic_${FILE##*/}.qsub ;
        echo "TRIMMOMATICENV" >> $SCRIPT/trimmomatic_${FILE##*/}.qsub ;
        echo "trimmomatic SE -Xmx115G -threads $NCPU -phred33 $DATADIRECTORY/"$FILE" $DATAOUTPUT/"$FILE".fq.gz MINLEN:100 CROP:100 ILLUMINACLIP:"$ADAPTERFILE":2:30:10 SLIDINGWINDOW:4:10" >> $SCRIPT/trimmomatic_${FILE##*/}.qsub ;
        qsub $SCRIPT/trimmomatic_${FILE##*/}.qsub ;

done ;
