#!/usr/bin/bash

OUTDIR=$1 # dir where all files will be created.
FASTQ1=$2 # Full path to fastq raw illumina sequence read 1
FASTQ2=$3 # Full path to fastq raw illumina sequence read 2
INGENOMEPATH=$4 # Full path to Input genome (genome we want to polish using the Illumina sequences)

cd $OUTDIR
mkdir pilon
cd $OUTDIR/pilon
#Cutadapt: TruSeq Universal Adapter
#If you have paired-end data, trim also read 2 with the reverse complement of the “TruSeq Universal Adapter”. The full command-line looks as follows:
DATE=`date '+%Y-%m-%d %H:%M:%S'`
echo $DATE  "Running Cutadapt..."
module load cutadapt/1.18-foss-2016b-Python-2.7.12
cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -o Illumina_trimmed.1.fastq.gz -p Illumina_trimmed.2.fastq.gz $FASTQ1 $FASTQ2 > cutadapt.log &&

##BWA alignment of reads to input genome:
module load BWA/0.7.15
module load SAMtools/1.6-foss-2016b
DATE=`date '+%Y-%m-%d %H:%M:%S'`
echo $DATE  "Running BWA..."
ln -s $INGENOMEPATH . 
INGENOME=$(basename "$INGENOMEPATH")
bwa index $INGENOME &&
bwa mem -t 24 $INGENOME Illumina_trimmed.1.fastq.gz Illumina_trimmed.2.fastq.gz | samtools view -Suh -q 20 -F 0x100 | samtools sort -@ 24 -o Illumina_vs_$INGENOME.sorted.bam -T tmp > $OUTDIR/bwamem.log &&
samtools index Illumina_vs_$INGENOME.sorted.bam &&
# Qualimap:
DATE=`date '+%Y-%m-%d %H:%M:%S'`
echo $DATE  "Running Qualimap..."
module load Qualimap/2.2
qualimap bamqc -bam Illumina_vs_$INGENOME.sorted.bam -outdir qualimap --java-mem-size=8G > $OUTDIR/pilon/qualimap.log &&

#Pilon:
DATE=`date '+%Y-%m-%d %H:%M:%S'`
echo $DATE  "Running Pilon..."
module load Pilon/1.22-Java-1.8.0_92
java -Xmx70G -jar $EBROOTPILON/pilon-1.22.jar --threads 24 --diploid --genome $INGENOME --bam Illumina_vs_$INGENOME.sorted.bam --output $INGENOME.pilon > $OUTDIR/pilon.log
