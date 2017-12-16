# 1. Alignemt of C variant reads vs WT genome 

Alignment of reads from a single run:

 ```bash
  Reference=$(ls ../fusarium_venenatum/repeat_masked/F.venenatum/WT_minion/minion_submission/WT_albacore_v2_contigs_unmasked.fa)
  for StrainPath in $(ls -d ../fusarium_venenatum/qc_dna/paired/F.venenatum/* | grep -v 'strain1'| grep -v 'WT'); do
    Strain=$(echo $StrainPath | rev | cut -f1 -d '/' | rev)
    Organism=$(echo $StrainPath | rev | cut -f2 -d '/' | rev)
    F_Read=$(ls $StrainPath/F/*_trim.fq.gz)
    R_Read=$(ls $StrainPath/R/*_trim.fq.gz)
    echo "$Organism - $Strain"
    echo $F_Read
    echo $R_Read
    OutDir=alignment/bowtie/$Organism/$Strain/vs_Fv_MINion
    ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/genome_alignment
    qsub $ProgDir/bowtie/sub_bowtie.sh $Reference $F_Read $R_Read $OutDir
    # OutDir=alignment/bwa/$Organism/$Strain/vs_Fv_MINion
    # ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/genome_alignment/bwa
    # qsub $ProgDir/sub_bwa.sh $Strain $Reference $F_Read $R_Read $OutDir
  done

  ```
# 2. Pre SNP calling cleanup


## 2.1 Rename input mapping files in each folder by prefixing with the strain ID

```bash
  for File in $(ls alignment/bowtie/*/*/vs_Fv_MINion/WT_albacore_v2_contigs_unmasked.fa_aligned.sam); do
    Strain=$(echo $File | rev | cut -f3 -d '/' | rev)
    Organism=$(echo $File | rev | cut -f4 -d '/' | rev)
    echo $Strain
    echo $Organism
    OutDir=analysis/popgen/$Organism/$Strain
    CurDir=$PWD
    mkdir -p $OutDir
    cd $OutDir
    cp -s $CurDir/$File "$Strain"_v2_contigs_unmasked.fa_aligned.sam
    cd $CurDir
  done
```

## 2.2 Remove multimapping reads, discordant reads. PCR and optical duplicates, and add read group and sample name to each mapped read (preferably, the shortest ID possible)

Convention used:
qsub $ProgDir/sub_pre_snp_calling.sh <INPUT SAM FILE> <SAMPLE_ID>

```bash
 for Sam in $(ls analysis/popgen/*/*/*_v2_contigs_unmasked.fa_aligned.sam); do
    Strain=$(echo $Sam | rev | cut -f2 -d '/' | rev)
    Organism=$(echo $Sam | rev | cut -f3 -d '/' | rev)
    ProgDir=/home/armita/git_repos/emr_repos/scripts/phytophthora/Pcac_popgen
    qsub $ProgDir/sub_pre_snp_calling.sh $Sam $Strain
  done
 ``` 

 # 3. Run SNP calling

#Runs a SNP calling script from Maria in order to be able to draw up a phylogeny

##Prepare genome reference indexes required by GATK

Firstly, a local version of the assembly was made in this project directory:

```bash
Reference=$(ls ../fusarium_venenatum/repeat_masked/F.venenatum/WT_minion/minion_submission/WT_albacore_v2_contigs_unmasked.fa)
OutDir=repeat_masked/F.venenatum/WT_minion/minion_submission
mkdir -p $OutDir
cp $Reference $OutDir/.
```
Then the local assembly was indexed:

```bash
Reference=$(ls repeat_masked/F.venenatum/WT_minion/minion_submission/WT_albacore_v2_contigs_unmasked.fa)
OutDir=$(dirname $Reference)
mkdir -p $OutDir
ProgDir=/home/sobczm/bin/picard-tools-2.5.0
java -jar $ProgDir/picard.jar CreateSequenceDictionary R=$Reference O=$OutDir/WT_albacore_v2_contigs_unmasked.dict
samtools faidx $Reference
```

###Submit SNP calling 

Move to the directory where the output of SNP calling should be placed. Then
Start SNP calling with GATK.
The submission script required need to be custom-prepared for each analysis,
depending on what samples are being analysed. See inside the submission script
below:

```bash
CurDir=$PWD
OutDir=analysis/popgen/SNP_calling_MINion
mkdir -p $OutDir
cd $OutDir
ProgDir=/home/connellj/git_repos/scripts/Fv_C-variants/SNP_calling
qsub $ProgDir/sub_SNP_calling_multithreaded_MINion.sh
cd $CurDir
```