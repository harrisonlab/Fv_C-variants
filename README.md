# Fv_C-variants


Detection SNPs leading to branching variants of Fv

All work was carried out in the directory:

```bash
  ProjectDirectory="/home/groups/harrisonlab/project_files/Fv_C-variants"
  mkdir -p $ProjectDirectory
  cd $ProjectDirectory
```

Preliminary work has already been carried out on Fven, including genome assembly
and annotation. key files can be located at:

```bash
  FvenDir=$(ls -d /home/groups/harrisonlab/project_files/fusarium_venenatum)
  IlluminaAssembly=$(ls $FvenDir/repeat_masked/F.venenatum/WT/illumina_assembly_ncbi/WT_contigs_unmasked.fa)
  IlluminaGeneGff=$(ls $FvenDir/gene_pred/final/F.venenatum/WT_ncbi/final/final_genes_appended.gff3)
  IlluminaGenePep=$(ls $FvenDir/gene_pred/final/F.venenatum/WT_ncbi/final/final_genes_combined.pep.fasta)
  IlluminaGeneNuc=$(ls $FvenDir/gene_pred/final/F.venenatum/WT_ncbi/final/final_genes_combined.gene.fasta)
```

# 0 Data organisation

Sequencing data was copied into the directory using:

```bash


```


# 1. Read Qc

Adapters were trimmed from reads and quality checked using the following commands:


```bash


```



# 2. SNP Calling

Commands for SNP calling are detailed in the directory SNP_calling.
