WORKDIR="/PERSIST"
SCRIPT="00_scripts/01_process_radtag"
HEADER="00_scripts/header.txt"
STACKSENV=""
INDIR="02_data"
OUTDIR="03_demultiplexed"
BARCODE1="01_info_files/barcodes_plate1.txt"
BARCODE2="01_info_files/barcodes_plate2.txt"
BARCODE3="01_info_files/barcodes_plate3.txt"

cd $WORKDIR
mkdir -p $SCRIPT
mkdir -p $OUTDIR

cp $HEADER $SCRIPT/process_radtag_plate1.qsub ;
echo "#PBS -o 98_log_files/process_radtag_plate1.txt" >> $SCRIPT/process_radtag_plate1.qsub ;
echo "#PBS -N process_radtag_plate1" >> $SCRIPT/process_radtag_plate1.qsub ;
echo "$STACKSENV " >> $SCRIPT/process_radtag_plate1.qsub ;
echo "process_radtags -p $INDIR/plate1/ -i 'gzfastq' -b $BARCODE1 -o $OUTDIR --renz_1 'pstI' --renz_2 'mspI' -c -q -r" >> $SCRIPT/process_radtag_plate1.qsub ;
qsub $SCRIPT/process_radtag_plate1.qsub


cp $HEADER $SCRIPT/process_radtag_plate2.qsub ;
echo "#PBS -o 98_log_files/process_radtag_plate2.txt" >> $SCRIPT/process_radtag_plate2.qsub ;
echo "#PBS -N process_radtag_plate2" >> $SCRIPT/process_radtag_plate2.qsub ;
echo "$STACKSENV " >> $SCRIPT/process_radtag_plate2.qsub ;
echo "process_radtags -p $INDIR/plate2/ -i 'gzfastq' -b $BARCODE2 -o $OUTDIR --renz_1 'pstI' --renz_2 'mspI' -c -q -r" >> $SCRIPT/process_radtag_plate2.qsub ;

qsub $SCRIPT/process_radtag_plate2.qsub


cp $HEADER $SCRIPT/process_radtag_plate3.qsub ;
echo "#PBS -o 98_log_files/process_radtag_plate3.txt" >> $SCRIPT/process_radtag_plate3.qsub ;
echo "#PBS -N process_radtag_plate3" >> $SCRIPT/process_radtag_plate3.qsub ;
echo "$STACKSENV " >> $SCRIPT/process_radtag_plate3.qsub ;
echo "process_radtags -p $INDIR/plate3/ -i 'gzfastq' -b $BARCODE3 -o $OUTDIR --renz_1 'pstI' --renz_2 'mspI' -c -q -r" >> $SCRIPT/process_radtag_plate3.qsub ;
qsub $SCRIPT/process_radtag_plate3.qsub

