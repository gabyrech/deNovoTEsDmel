# deNovoTEsDmel
Scripts for genome assembly and TE annotation in D. melanogaster genomes.

## Genome Polishing
After obtaining the contig sequences from your favourite assembler (canu, flye, etc.), run assembly polishing get some information about the genomes:

```
$ polishingFull.sh WRKDIR RAWASS ONTFASTQPATH FASTQ1 FASTQ2
```
WRKDIR: Working dir where is the raw assembly to be polished.

RAWASS: File name of the raw assembly.

ONTFASTQPATH: Full path to ONT fastq file (.gz).

FASTQ1: Full path to fastq raw illumina sequence read 1.

FASTQ2: Full path to fastq raw illumina sequence read 2.

## TE Annotation using REPET

After genome assembly, polishing and scaffolding we run REPET (TEAnnot pipeline) using the Manually Curated library of Transposable Elements (MCTE):
```
grech@mr-login:/homes/users/grech/scratch/RepetOtherProjects$ sbatch ~/scripts/run_launch_TEannotByStep_v2.sh $PWD RAL91EucMCv4 /homes/users/grech/scratch/Repet2/denovolibs/ManualCuration/consensuses_curated_v4.fasta /homes/users/grech/scratch/Repet2/genomesRaGOO/RAL91.ChrEu.fa 
```
