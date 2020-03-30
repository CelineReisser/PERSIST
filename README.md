# PERSIST
Labex Corail Project to study the impact of the aquaculture of *P. margaritifera* on the genetic structuring of natural, exploited and collected individuals.

## WARNING

The codes are provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or the use or other dealings in the software.


## Documentation

The goal of this pipeline is to extract and analyse SNP loci from three types of populations within an exploited lagoon of French Polynesia: exploited populations, natural populations, and "collected" populations (spats that fixed themselves on plastic structures called "collectors"). 

DNA was extracted from all individuals and double digested with enzyme pstI and mspI. individuals were then barcoded and multiplexed into 4 libraries, and sequenced on an Ion Proton following a "Genotyping by Sequencing" protocol (sequencing facility: Université Laval, Québec, Canada).

Our present dataset is composed of fastq.gz files containing single ended DNA fragments of various sizes from the multiplexed individuals.



### Pre-requisites

before starting the analysis, a few files should be generated:
* two files called `header.txt` and `header_cpus.txt` that contain the heading of your jobs usually submitted to your cluster (cluster and run specificities).

For example:
```
#!usr/bin/sh
#PBS -q xxx
#PBS -l mem=XXg
#PBS -N script_name
```

* A file calles `base.txt`and containing the names of your samples (for some, it will be the file names of your fastq sequences received from your sequencing facility).

* All the programs that are listed below:
  1. fastqc
  2. trimmomatic
  3. Stacks
  4. bwa
  5. samtools
  6. freebayes
  7. vcftools, bcftools and vcflib
  8. SNPEff
  9. Bayescan
  10. R libraries: listed in all Rcodes


Once set up for the types of programs and files to have, you can start populate the directories with your own datasets.
Place all raw sequences in the directory `02_data/raw`. Place your reference genome, the GFF3, and the genome index (bwa index and samtools index) in the `01_info_files`directory.
