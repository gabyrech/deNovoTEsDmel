# deNovoTEsDmel
Scripts for genome assembly and TE annotation in D. melanogaster genomes.

## Genome Polishing
After obtaining the contig sequences from your favourite assembler (canu, flye, etc.), run assembly polishing get some information about the genomes:

```
$ polishingFull.sh WRKDIR RAWASS ONTFASTQPATH FASTQ1 FASTQ2
```
WRKDIR: Working dir where the raw assembly to be polished is located.

RAWASS: File name of the raw assembly.

ONTFASTQPATH: Full path to ONT fastq file (.gz).

FASTQ1: Full path to fastq raw illumina sequence read 1.

FASTQ2: Full path to fastq raw illumina sequence read 2.

## TE Annotation using REPET

After genome assembly, polishing and scaffolding we run REPET (TEAnnot pipeline) using the Manually Curated library of Transposable Elements (MCTE.fasta): Note this script was prepared to be run in our HPC cluster under the Slurm Workload Manager. 
```
$ sbatch launch_TEannotByStep.sh WRKDIR PROJECT LIBPATH GENOMEPATH 
```
WRKDIR: Working Directory where all Repet files will be created.

PROJECT: Repet project name.

LIBPATH: Full Path to TE library used for annotate TEs (MCTE.fasta)

GENOMEPATH: Full path to the genome that will be annotated.

## Post TE annotation processing: 
In this step, we joining fragments at < 500bp, remove TE < 100bp, reomove copies from some families that are annotated only with the satelite region of the consensus and remove TEs overlapping with Hsp Genes.

```
$ ./postTEAnnot.sh WORKDIR TEANNPROJECT DIRNAME 500
```

WORKDIR: Project Directory where all files/folder are created.

TEANNPROJECT: Original name of the TEannot project.

DIRNAME: Name of the directory that is created in WORKDIR. This contains one bed file per "family".

JOINDIST: Bedtools merge option: Maximum distance between features allowed for features to be merged.


## Create BED and GFF3 files with TE annotations including Family information
```
$ addFamilyInfo.sh TEANNOTPATH TEANOTPROJECT SAMPLENAME
```
TEANNOTPATH: Full path to TEAnnot output project.

TEANOTPROJECT: Name of TEAnnot Project. 

SAMPLENAME: Sample/Genome ID.

## Other Files:
### MCTE.tsv
Summary information for the 165 consensus TE sequences in the MCTE.fasta library. Source: BDGP: after performing MSA of all members of the family, the most representative sequence was the sequence present in the BDGP set, so that is the sequence in the MCTE library; FLFtoBDGP: The sequence present in the MCTE library is the result of the consesus sequence from the MSA generated using all the FLF from all genomes. The family name was assigned based on BLAT result agains the BDGP; noBDGPmclCluster: Consensus sequence created by the clustering, MSA and consensus calling of unknown FLF and good no-FLF; noBDGPunClustered: Consensus sequences created by the denovoTE pipeline showing no similarities with the BDGP nor any other sequence in the de novo predictions but that survived after manual inspection (see Material and Methods). Sequences in cluster: number of sequences clustering together by identity. Sequences in Consensus: number of sequences in the clustering used for building the consensus sequences.
