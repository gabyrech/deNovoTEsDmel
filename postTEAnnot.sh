WORKDIR=$1 # Project Directory where all files/folder are created.
TEANNPROJECT=$2 # Original name of the TEannot project.
DIRNAME=$3 # name of the directory that is created in WORKDIR. This contains one bed file per "family"
JOINDIST=$4 # Bedtools merge option: Maximum distance between features allowed for features to be merged.
GFFDIR=$TEANNPROJECT"_GFF3chr"
echo ""
echo ""
echo "###~~~###"
echo "Parsing GFF3 for" $TEANNPROJECT ":"
cd $WORKDIR/$GFFDIR
echo "Total match_parts:"
cat 2L.gff3 2R.gff3 3L.gff3 3R.gff3 X.gff3 | grep -v "##\|blast" | grep -w "match_part" | wc -l
echo "Total matchs:"
cat 2L.gff3 2R.gff3 3L.gff3 3R.gff3 X.gff3 | grep -v "##\|blast" | grep -w "match" |  sort -k1,1 -k4,4n | wc -l
echo "GFF3 file containing only match features:"
echo $TEANNPROJECT.match.gff3
cat 2L.gff3 2R.gff3 3L.gff3 3R.gff3 X.gff3 | grep -v "##\|blast" | grep -w "match" |  sort -k1,1 -k4,4n > $TEANNPROJECT.match.gff3
echo "GFF3 file containing only match features, removing Wrong copies:"
python filterWrongCopies.py $TEANNPROJECT.match.gff3 > $TEANNPROJECT.match.FixWrongCopy.gff3
wc -l $TEANNPROJECT.match.FixWrongCopy.gff3
echo "BED file containing only match features:"
cat $TEANNPROJECT.match.FixWrongCopy.gff3 | awk -F "\t" -v OFS="\t" '{split($9,a," "); split(a[1],b,"="); print $1,$4,$5,b[3],$6,$7,$9}' > $TEANNPROJECT.match.bed
wc -l $TEANNPROJECT.match.bed

./TEAnnotJoiner.sh $WORKDIR/$GFFDIR $TEANNPROJECT.match.bed $DIRNAME $JOINDIST


echo "TEs larger than 100bp: "
cat $TEANNPROJECT.match.bed.Join$JOINDIST.bed | awk -F "\t" -v OFS='\t' '$8=$3-$2 {print $0}' | awk -F "\t" -v OFS='\t' '$8 >= 100 {print $0}' | wc -l
echo "BED file with TEs larger than 100bp: "
cat $TEANNPROJECT.match.bed.Join$JOINDIST.bed | awk -F "\t" -v OFS='\t' '$8=$3-$2 {print $0}' | awk -F "\t" -v OFS='\t' '$8 >= 100 {print $0}' > $TEANNPROJECT.match.bed.Join$JOINDIST"_larger100.bed"
echo $TEANNPROJECT.match.bed.Join$JOINDIST"_larger100.bed"
echo "Remove TEs overlapping with Hsp genes, Satellite and untrusted consensuses (v4) annotations..."
echo "Final TEs:"
bedtools intersect -a $TEANNPROJECT.match.bed.Join$JOINDIST"_larger100.bed" -b /media/gabriel/BariData/gabriel/Repet2/denovolibs/ManualCuration/HspGenesFull.bed -v | wc -l
echo "Final TEs bed file:"
bedtools intersect -a $TEANNPROJECT.match.bed.Join$JOINDIST"_larger100.bed" -b /media/gabriel/BariData/gabriel/Repet2/denovolibs/ManualCuration/HspGenesFull.bed -v > $TEANNPROJECT.match.bed.Join$JOINDIST"_larger100.NoHsp.bed"
ln -s $WORKDIR/$GFFDIR/$TEANNPROJECT.match.bed.Join$JOINDIST"_larger100.NoHsp.bed" $WORKDIR/$TEANNPROJECT.match.bed.Join$JOINDIST"_larger100.NoHsp.bed"
echo $WORKDIR/$TEANNPROJECT.match.bed.Join$JOINDIST"_larger100.NoHsp.bed"
echo "Per Family Counts:"
cat $WORKDIR/$TEANNPROJECT.match.bed.Join$JOINDIST"_larger100.NoHsp.bed" | cut -f4 | sort | uniq -c |  awk -v OFS="\t" '{print $2,$1}' > $WORKDIR/$TEANNPROJECT.match.bed.Join$JOINDIST"_larger100.NoHsp.counts.txt"
echo $WORKDIR/$TEANNPROJECT.match.bed.Join$JOINDIST"_larger100.NoHsp.counts.txt"
echo "Represented Families:"
cat $WORKDIR/$TEANNPROJECT.match.bed.Join$JOINDIST"_larger100.NoHsp.counts.txt" | wc -l
