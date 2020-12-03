#!/usr/bin/bash
#SBATCH --job-name=repet
#SBATCH --cpus-per-task=1 
#SBATCH --mem-per-cpu=2G 
#SBATCH -o launch_TEannotByStep_%j.out
#SBATCH -e launch_TEannotByStep_%j.err 

WRKDIR=$1
PROJECT=$2
LIBPATH=$3
GENOMEPATH=$4

mkdir $WRKDIR/$PROJECT
cd $WRKDIR/$PROJECT/
. setEnv.sh
ln -s $REPET_PATH/RepBase20.05_REPET.embl/repbase20.05_ntSeq_cleaned_TE.fa repbase20.05_ntSeq_cleaned_TE.fa
ln -s $REPET_PATH/RepBase20.05_REPET.embl/repbase20.05_aaSeq_cleaned_TE.fa repbase20.05_aaSeq_cleaned_TE.fa

ln -s $GENOMEPATH $PROJECT.fa
ln -s $LIBPATH "$PROJECT"_refTEs.fa

sed -e s!Template!$PROJECT!g -e s!PATH_TO_REPET!$WRKDIR/$PROJECT!g TEannotTemplate.cfg > TEannot.cfg

GiveInfoFasta.py -i $PROJECT.fa -v 1

launch_TEannotByStep.py -P $PROJECT -C TEannot.cfg -S 12378 -O GFF3 -v 3
