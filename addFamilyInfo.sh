TEANNOTPATH=$1 # E.g: //////RepetTEannotMCv4/COR1523EucMCv4/
TEANOTPROJECT=$2 # E.g: COR1523EucMCv4
SAMPLENAME=$3 # Eg: COR1523

# Add Classification Info to Annotated TEs.
python addInfoToBED.py ManualCurationConsensusInfov4B.txt $TEANNOTPATH/$TEANOTPROJECT.match.bed.Join500_larger100.NoHsp.bed > $TEANNOTPATH/$TEANOTPROJECT.match.bed.Join500_larger100.NoHsp.Info.txt

# BED file with unique ID as name and subfamily, including info about TE family, class, order, etc...:
cat $TEANNOTPATH/$TEANOTPROJECT.match.bed.Join500_larger100.NoHsp.Info.txt | grep -v "TELenRatio" | awk -F '\t' -v var=$SAMPLENAME '{print $1"\t"$2"\t"$3"\t"var"_"NR"_"$13"\t"$8"\t"$6"\t"$13"\t"$12"\t"$10"\t"$9"\t"$14"\t"$15}' > $TEANNOTPATH/$TEANOTPROJECT.match.bed.Join500_larger100.NoHsp.InfoExtended.bed

# GFF3 file with unique ID and Name=Subfamily:
cat $TEANNOTPATH/$TEANOTPROJECT.match.bed.Join500_larger100.NoHsp.Info.txt | grep -v "TELenRatio" | awk -F '\t' -v var=$SAMPLENAME '{print $1"\tREPET\tTE\t"$2"\t"$3"\t"$8"\t"$6"\t.\tID="var"_"NR"_"$13";Name="$13}' > $TEANNOTPATH/$TEANOTPROJECT.match.bed.Join500_larger100.NoHsp.Info.gff3
