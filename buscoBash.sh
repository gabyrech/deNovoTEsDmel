#!/usr/bin/bash

INGENOME=$1 #Inout genome in fasta format
PREFIX=$2 # Prefix for output
OUTPATH=$3 # Path to output
BUSCOPATH= # Full path to BUSCO installation dir (e.g. /usr/local/bin/soft/busco/)


cd $OUTPATH
mkdir BUSCO

sed -e s!INGENOME!$INGENOME!g -e s!PREFIX!$PREFIX!g -e s!OUTPATH!$OUTPATH/BUSCO!g $BUSCOPATH/config.ini > $OUTPATH/BUSCO/config.ini

export  BUSCO_CONFIG_FILE=$OUTPATH/BUSCO/config.ini
export AUGUSTUS_CONFIG_PATH=$BUSCOPATH/augustus/config

cd $OUTPATH/BUSCO
python $EBROOTBUSCO/scripts/run_BUSCO.py



module load pigz/2.3.3-foss-2016b

cd $OUTPATH/BUSCO/run_$PREFIX

tar cf - hmmer_output/ | pigz -p 24 > hmmer_output.tar.gz
tar cf - single_copy_busco_sequences/ | pigz -p 24 > single_copy_busco_sequences.tar.gz

rm -rf hmmer_output/
rm -rf single_copy_busco_sequences/

cd $OUTPATH/BUSCO/run_$PREFIX/augustus_output

tar cf - extracted_proteins/ | pigz -p 24 > extracted_proteins.tar.gz
tar cf - gb/ | pigz -p 24 > gb.tar.gz
tar cf - gffs/ | pigz -p 24 > gffs.tar.gz
tar cf - predicted_genes/ | pigz -p 24 > predicted_genes.tar.gz

rm -rf extracted_proteins/
rm -rf gb/
rm -rf gffs/
rm -rf predicted_genes/
