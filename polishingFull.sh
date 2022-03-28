#!/usr/bin/bash

# This script performe polishing of draft genome assemblies using long and short reads.
# Run after obtaining the contig sequences from your favourite assembler (canu, flye, etc.)
# The script will run 4 rounds of Racon using long reads and 1 round of Pilon using Illumina short-reads.
# After polishing, the script gives basic assembly information and runs BUSCO.

set -o nounset
set -o errexit 

#Parameters:
WRKDIR=$1 # working dir where is the raw assembly to be polished. 
RAWASS=$2 # file name of the raw assembly
ONTFASTQPATH=$3 # full path to ONT fastq file (.gz)
FASTQ1=$4 # Full path to fastq raw illumina sequence read 1
FASTQ2=$5 # Full path to fastq raw illumina sequence read 2

DATE=`date '+%Y-%m-%d %H:%M:%S'`

echo $DATE "Staring raconX4..."

cd $WRKDIR
mkdir raconX4
cd raconX4/
ln -s $WRKDIR/$RAWASS .
zcat $ONTFASTQPATH > rawONT.fastq &&

# Racon X1
minimap2 -d $RAWASS.mmi $RAWASS &&
minimap2 -t 24 -x map-ont $RAWASS rawONT.fastq > $RAWASS.minimap2.paf &&
racon -m 8 -x -6 -g -8 -w 500 -t 24 rawONT.fastq $RAWASS.minimap2.paf $RAWASS > $RAWASS.raconX1.fasta &&

DATE=`date '+%Y-%m-%d %H:%M:%S'`
echo $DATE "Done RaconX1"

# Racon X2
minimap2 -d $RAWASS.raconX1.fasta.mmi $RAWASS.raconX1.fasta &&
minimap2 -t 24 -x map-ont $RAWASS.raconX1.fasta rawONT.fastq > $RAWASS.raconX1.minimap2.paf &&
racon -m 8 -x -6 -g -8 -w 500 -t 24 rawONT.fastq $RAWASS.raconX1.minimap2.paf $RAWASS.raconX1.fasta > $RAWASS.raconX2.fasta &&

DATE=`date '+%Y-%m-%d %H:%M:%S'`
echo $DATE "Done RaconX2"

# Racon X3
minimap2 -d $RAWASS.raconX2.fasta.mmi $RAWASS.raconX2.fasta &&
minimap2 -t 24 -x map-ont $RAWASS.raconX2.fasta rawONT.fastq > $RAWASS.raconX2.minimap2.paf &&
racon -m 8 -x -6 -g -8 -w 500 -t 24 rawONT.fastq $RAWASS.raconX2.minimap2.paf $RAWASS.raconX2.fasta > $RAWASS.raconX3.fasta &&

DATE=`date '+%Y-%m-%d %H:%M:%S'`
echo $DATE  "Done RaconX3"


# Racon X4
minimap2 -d $RAWASS.raconX3.fasta.mmi $RAWASS.raconX3.fasta &&
minimap2 -t 24 -x map-ont $RAWASS.raconX3.fasta rawONT.fastq > $RAWASS.raconX3.minimap2.paf &&
racon -m 8 -x -6 -g -8 -w 500 -t 24 rawONT.fastq $RAWASS.raconX3.minimap2.paf $RAWASS.raconX3.fasta > $RAWASS.raconX4.fasta &&

DATE=`date '+%Y-%m-%d %H:%M:%S'`
echo $DATE  "Done RaconX4"


#Pilon:
DATE=`date '+%Y-%m-%d %H:%M:%S'`
echo $DATE  "Starting Pilon script"

./pilonBash.sh $WRKDIR/raconX4/ $FASTQ1 $FASTQ2 $WRKDIR/raconX4/$RAWASS.raconX4.fasta  &&
DATE=`date '+%Y-%m-%d %H:%M:%S'`
echo $DATE  "Finished Pilon script"
echo "Polished genome stats:"
perl assemblystats.pl $WRKDIR/raconX4/pilon/$RAWASS.raconX4.fasta.pilon.fasta

DATE=`date '+%Y-%m-%d %H:%M:%S'`
echo $DATE  "Starting BUSCO"

./buscoBash.sh $WRKDIR/raconX4/pilon/$RAWASS.raconX4.fasta.pilon.fasta $RAWASS.raconX4.fasta.pilon $WRKDIR/raconX4/pilon/ > $WRKDIR/raconX4/pilon/busco.log &&

cat $WRKDIR/raconX4/pilon/BUSCO/"run_"$RAWASS.raconX4.fasta.pilon/"short_summary_"$RAWASS.raconX4.fasta.pilon.txt
