# deNovoTEsDmel
Scripts for genome assembly and TE annotation in D. melanogaster genomes.

After obtaining the contig sequences from your favourite assembler (canu, flye, etc.), run assembly polishing get some information about the genomes:

```
$ polishingFull.sh WRKDIR RAWASS ONTFASTQPATH FASTQ1 FASTQ2
```
WRKDIR: Working dir where is the raw assembly to be polished.

RAWASS: File name of the raw assembly.

ONTFASTQPATH: Full path to ONT fastq file (.gz).

FASTQ1: Full path to fastq raw illumina sequence read 1.

FASTQ2: Full path to fastq raw illumina sequence read 2.
