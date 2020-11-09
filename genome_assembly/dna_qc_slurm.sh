# QC tools for multi-platform sequence data

1. FastQC: Quality control checks on raw sequence data

2. fast-mcf: Remove adapters and low quality reads

3. FastQC: Quality  control checks on trimmed sequence data


### Requirements

```bash
conda activate qc_tools
conda install -c bioconda fastqc
conda install -c bioconda ea-utils
# Porechop is installed in /scratch/software/. Add this line to your profile.
PATH=${PATH}:/scratch/software/Porechop-0.2.3
. ~/.profile # Refresh profile
```

### Typical run

```bash
# Run fastqc
for Strain in Strain1 Strain2; do
    RawData=$(ls qc_dna/fusarium_venenatum_miseq/genomes/C7/*/*.fq.gz)
    echo $RawData;
    ProgDir=/home/gomeza/git_repos/scripts/bioinformatics_tools/SEQdata_qc
    sbatch $ProgDir/fastqc.sh $RawData
done
```

```bash
# Run fastq-mcf
for Strain in Strain1 Strain2; do
    Read_F=../../projects/fusarium_venenatum_miseq/genomes/C12/F/*.fastq.gz
    Read_R=../../projects/fusarium_venenatum_miseq/genomes/C12/R/*.fastq.gz
    echo $Read_F;
    echo $Read_R;
    IluminaAdapters=/home/connellj/git_repos/emr_repos/Fv_C-variants/genome_assembly/genome_assembly_subscripts/dna_qc/illumina_full_adapters.fa
    ProgDir=/home/connellj/git_repos/emr_repos/tools/seq_tools/dna_qc
    sbatch $ProgDir/fastq-mcf_long.sh $Read_F $Read_R $IluminaAdapters DNA
done
```

```bash
# Run fastqc
for Strain in Strain1 Strain2; do
    RawData=$(ls qc_dna/connellj/genomes/C18/F/*.fq.gz)
    echo $RawData;
    ProgDir=/home/connellj/git_repos/emr_repos/Fv_C-variants/genome_assembly/genome_assembly_subscripts/dna_qc/
    sbatch $ProgDir/fastqc.sh $RawData
done

for Strain in Strain1 Strain2; do
    RawData=$(ls qc_dna/connellj/genomes/C18/R/*.fq.gz)
    echo $RawData;
    ProgDir=/home/connellj/git_repos/emr_repos/Fv_C-variants/genome_assembly/genome_assembly_subscripts/dna_qc/
    sbatch $ProgDir/fastqc.sh $RawData
done
```

```bash
# Estimate coverage (optional)
for DataDir in $(ls -d raw_dna/paired/$Organism/$Strain); do
    F_Read=$(ls $DataDir/F/*.gz)
    R_Read=$(ls $DataDir/R/*.gz)
    echo $F_Read
    echo $R_Read
    ProgDir=/home/gomeza/git_repos/scripts/bioinformatics_tools/SEQdata_qc
    sbatch $ProgDir/count_nucl.sh $F_Read $R_Read 45 #Estimated genome size
done

# Estimate coverage long read data
for RawData in $(ls -d raw_dna/minion/$Organism/$Strain/*fq.gz); do
    echo $RawData
    GenomeSize=45 #Estimated genome size
    OutDir=$(dirname $RawData)
    ProgDir=/home/gomeza/git_repos/scripts/bioinformatics_tools/SEQdata_qc
    sbatch $ProgDir/count_nucl_single.sh $RawData $GenomeSize $OutDir
done
```


```bash
# Adapter removal ONT reads
    RawReads=path/to/ONT/raw/reads/*.fastq.gz
    OutDir=qc_dna/minion/$Organism/$Strain #e.g.
    ProgDir=/home/gomeza/git_repos/scripts/bioinformatics_tools/SEQdata_qc
    sbatch $ProgDir/porechop.sh $RawReads $OutDir 
```








-------------------------------------------------------------------trimming------------------------------------------------------------------------------------

Trimming was performed on data to trim adapters from sequences and remove poor quality data. This was done with fastq-mcf


  ProgDir=/home/connellj/git_repos/emr_repos/Fv_C-variants/genome_assembly/genome_assembly_subscripts
  IlluminaAdapters=/home/connellj/git_repos/emr_repos/Fv_C-variants/genome_assembly/genome_assembly_subscripts/ncbi_adapters.fa
  echo "strain7"
  StrainPath=/home/connellj/genomes/C7
  ReadsF=$(ls $StrainPath/F/c9_S1_L001_R1_001.fastq.gz)
  ReadsR=$(ls $StrainPath/R/c9_S1_L001_R2_001.fastq.gz)
  sbatch $ProgDir/rna_qc_fastq-mcf.sh $ReadsF $ReadsR $IlluminaAdapters DNA
  StrainPath=/home/connellj/genomes/C8
  ReadsF=$(ls $StrainPath/F/c15_S3_L001_R1_001.fastq.gz)
  ReadsR=$(ls $StrainPath/R/c15_S3_L001_R2_001.fastq.gz)
  sbatch $ProgDir/rna_qc_fastq-mcf.sh $ReadsF $ReadsR $IlluminaAdapters DNA
  echo "strain8"



-------------------------------------------------------------------Visualisation-------------------------------------------------------------------------------

Data qc 
programs: fastqc fastq-mcf kmc
Data quality was visualised using fastqc:


  for RawData in $(ls qc_dna/paired/*/*/*/*.fq.gz); do
    echo $RawData;
    ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/dna_qc;
    qsub $ProgDir/run_fastqc.sh $RawData;
  done