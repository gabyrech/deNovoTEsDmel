WORKDIR=$1 # Directory where all files/folder are created.
BEDFILE=$2 # Bed file containing the annotations that need to be merge.
DIRNAME=$3 # name of the directory that is created in WORKDIR. This contains one bed file per "family"
JOINDIST=$4 # Bedtools merge option: Maximum distance between features allowed for features to be merged.
cd $WORKDIR
echo "Joining TE fragments by family and with a distance < " $JOINDIST "..."
mkdir $DIRNAME
for id in `cut -f4 $BEDFILE | sort | uniq`;
do
#  awk -vid=$id '$4==id' $BEDFILE | bedtools merge -d $JOINDIST -s -c 4 -o distinct -i stdin > $DIRNAME/merged.$id.bed;
  awk -vid=$id '$4==id' $BEDFILE | bedtools merge -d $JOINDIST -s -c 4,5,6,7,7 -o distinct,distinct,distinct,distinct,count -delim "//" -i stdin > $DIRNAME/merged.$id.bed;
done
echo "Initial TE fragments: "
cat $DIRNAME/* | awk -F "\t" '{sum += $9} END {print sum}'
echo "Final Joined TEs:"
cat $DIRNAME/* | wc -l
echo "Bed file containing joined TEs: "
cat $DIRNAME/* | cut -f4 --complement | sort -k1,1 -k2,2n > $BEDFILE.Join$JOINDIST.bed
echo $BEDFILE.Join$JOINDIST.bed
