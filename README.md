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

After genome assembly, polishing and scaffolding we run REPET (TEAnnot pipeline) using the Manually Curated library of Transposable Elements (MCTE): Note this script was prepared to be run in our HPC cluster under the Slurm Workload Manager. 
```
$ sbatch launch_TEannotByStep.sh WRKDIR PROJECT LIBPATH GENOMEPATH 
```
WRKDIR: Working Directory where all Repet files will be created.

PROJECT: Repet project name.

LIBPATH: Full Path to TE library used for annotate TEs (MCTE.fasta)

GENOMEPATH: Full path to the genome that will be annotated.
