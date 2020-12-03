import sys

conClass = {}
conOrder = {}
conSource = {}
conFamily = {}
conSubFamily = {}
conFamSource = {}
conLength = {}

consensusInfo = open(sys.argv[1], "r").readlines()[1:] #ManualCurationConsensusInfov4B.txt
for line in consensusInfo:
    consensusId = line.split()[0]
    conClass[consensusId] = line.split()[2]
    conOrder[consensusId] = line.split()[3]
    conSource[consensusId] = line.split()[1]
    conFamily[consensusId] = line.split()[4]
    conSubFamily[consensusId] = line.split()[5]
    conFamSource[consensusId] = line.split()[6]
    conLength[consensusId] = line.split()[7]

print "Chr	Start	End	Consensus	Score	Strand	REPETInfo	Size	Class	Order	consensuSource	Family	SubFamily	FamSource	TELenRatio"


bedFile = open(sys.argv[2], "r").readlines() #E.g.: REFEucMCv3.match.bed.Join500_larger100.NoHsp.bed
for line in bedFile:
    consensus = line.split("\t")[3]
    length = float(line.split("\t")[7])
    teratio = round(length/float(conLength[consensus]),3)
    print line.rstrip("\n") +"\t"+conClass[consensus]+"\t"+conOrder[consensus]+"\t"+conSource[consensus]\
    +"\t"+conFamily[consensus]+"\t"+conSubFamily[consensus]+"\t"+conFamSource[consensus]+"\t"+str(teratio)
