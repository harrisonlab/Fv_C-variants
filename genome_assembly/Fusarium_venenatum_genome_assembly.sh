Fusarium venenatum genome assembly

This script for genome assemnbly contains:
#Preparing data
#Draft Genome assembly
#Data qc
#Genome assembly
#Repeatmasking
#Gene prediction
#Functional annotation
#Genome analysis 

-------------------------------------------------------------------create symbolic link----------------------------------------------------------------------

Data was copied from the raw_data repository to a local directory for assembly and annotation.

only used as an example of the directory structure required for subsequent scripts to run with ease, specifically symbolic links should be used rather then copying data. 

    mkdir -p /projects/verticillium_hops
    cd /projects/verticillium_hops
    RawDat=$(ls -d /archives/2019_niabemr_miseq/RAW/191010_M04465_0101_000000000-C6N3P/Data/Intensities/BaseCalls)
    # Isolate 11043
    Species=V.nonalfalfae
    Strain=11043
    OutDir=raw_dna/paired/$Species/$Strain
    mkdir -p $OutDir/F
    mkdir -p $OutDir/R
    cp -s $RawDat/${Strain}_*_R1_001.fastq.gz $PWD/$OutDir/F/.
    cp -s $RawDat/${Strain}_*_R2_001.fastq.gz $PWD/$OutDir/R/.
    # Isolate 11055
    Species=V.nonalfalfae
    Strain=11055
    OutDir=raw_dna/paired/$Species/$Strain
    mkdir -p $OutDir/F
    mkdir -p $OutDir/R
    cp -s $RawDat/${Strain}_*_R1_001.fastq.gz $PWD/$OutDir/F/.
    cp -s $RawDat/${Strain}_*_R2_001.fastq.gz $PWD/$OutDir/R/.
    # Isolate 11100
    Species=V.nonalfalfae
    Strain=11100  
    OutDir=raw_dna/paired/$Species/$Strain
    mkdir -p $OutDir/F
    mkdir -p $OutDir/R
    cp -s $RawDat/${Strain}_*_R1_001.fastq.gz $PWD/$OutDir/F/.
    cp -s $RawDat/${Strain}_*_R2_001.fastq.gz $PWD/$OutDir/R/.


-------------------------------------------------------------------Visualisation--------------------------------------------------------------------------------

Data qc 
programs: fastqc fastq-mcf kmc
Data quality was visualised using fastqc:


for RawData in $(ls miseq/c_variant_sequencing/2019/raw_dna/paired/fusarium_venenatum/c-varient/*/*.fastq.gz); do
    echo $RawData;
    ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/dna_qc;
    qsub $ProgDir/run_fastqc.sh $RawData; $OutDir
    
done

-------------------------------------------------------------------trimming------------------------------------------------------------------------------------

Trimming was performed on data to trim adapters from sequences and remove poor quality data. This was done with fastq-mcf


  ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/rna_qc
  IlluminaAdapters=/home/armita/git_repos/emr_repos/tools/seq_tools/ncbi_adapters.fa
  echo "strain1"
  StrainPath=raw_dna/paired/fusarium_venenatum/c-varient
  ReadsF=$(ls $StrainPath/F/c9_S1_L001_R1_001.fastq.gz)
  ReadsR=$(ls $StrainPath/R/c9_S1_L001_R2_001.fastq.gz)
  qsub $ProgDir/rna_qc_fastq-mcf.sh $ReadsF $ReadsR $IlluminaAdapters DNA
  StrainPath=raw_dna/paired/fusarium_venenatum/c-varient
  ReadsF=$(ls $StrainPath/F/c15_S3_L001_R1_001.fastq.gz)
  ReadsR=$(ls $StrainPath/R/c15_S3_L001_R2_001.fastq.gz)
  qsub $ProgDir/rna_qc_fastq-mcf.sh $ReadsF $ReadsR $IlluminaAdapters DNA
  echo "WT"



-------------------------------------------------------------------Visualisation-------------------------------------------------------------------------------

Data qc 
programs: fastqc fastq-mcf kmc
Data quality was visualised using fastqc:


  for RawData in $(ls qc_dna/paired/*/*/*/*.fq.gz); do
    echo $RawData;
    ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/dna_qc;
    qsub $ProgDir/run_fastqc.sh $RawData;
  done

-------------------------------------------------------------------Predict genome coverage---------------------------------------------------------------------

Find predicted coverage for these isolates:

for RawData in $(ls qc_dna/paired/*/*/*/*q.gz); do
echo $RawData;
ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/dna_qc;
qsub $ProgDir/run_fastqc.sh $RawData;
GenomeSz=38
OutDir=$(dirname $RawData)
qsub $ProgDir/sub_count_nuc.sh $GenomeSz $RawData $OutDir
done

Find predicted coverage for these isolates:

for StrainDir in $(ls -d qc_dna/paired/*/*); do
  Strain=$(basename $StrainDir)
  printf "$Strain\t"
  for File in $(ls qc_dna/paired/*/"$Strain"/*/*.txt); do
    echo $(basename $File);
    cat $File | tail -n1 | rev | cut -f2 -d ' ' | rev;
  done | grep -v '.txt' | awk '{ SUM += $1} END { print SUM }'
done

-------------------------------------------------------------------Kmer counting-------------------------------------------------------------------------------

kmer counting was performed using kmc This allowed estimation of sequencing depth and total genome size

for TrimPath in $(ls -d qc_dna/paired/fusarium_venenatum/c-varient); do
    ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/dna_qc
    TrimF1=$(ls $TrimPath/F/c9_S1_L001_R1_001_trim.fq.gz)
    TrimR1=$(ls $TrimPath/R/c9_S1_L001_R2_001_trim.fq.gz)
    echo $TrimF1
    echo $TrimR1
    TrimF2=$(ls $TrimPath/F/c15_S3_L001_R1_001_trim.fq.gz)
    TrimR2=$(ls $TrimPath/R/c15_S3_L001_R2_001_trim.fq.gz)
    echo $TrimF2
    echo $TrimR2
    qsub $ProgDir/kmc_kmer_counting.sh $TrimF1 $TrimR1 $TrimF2 $TrimR2
  done
  
-------------------------------------------------------------------Spased assembly------------------------------------------------------------------------------

Assembly was performed using: Velvet / Abyss / Spades

#######################################################################################################
##############################    Old Cluster    ######################################################
#######################################################################################################

  for StrainPath in $(ls -d qc_dna/paired/fusarium_venenatum/c-varient); do
   echo $StrainPath
   ProgDir=/home/connellj/genome_assembly_subscripts
   Strain=$(echo $StrainPath | rev | cut -f1 -d '/' | rev)
   Organism=$(echo $StrainPath | rev | cut -f2 -d '/' | rev)
   echo $Strain
   echo $Organism
   TrimF1=$(ls $TrimPath/F/c9_S1_L001_R1_001_trim.fq.gz)
   TrimR1=$(ls $TrimPath/R/c9_S1_L001_R2_001_trim.fq.gz)
   echo $TrimF1
   echo $TrimR1
   TrimF2=$(ls $TrimPath/F/c15_S3_L001_R1_001_trim.fq.gz)
   TrimR2=$(ls $TrimPath/R/c15_S3_L001_R2_001_trim.fq.gz)
   echo $TrimF2
   echo $TrimR2
   OutDir=qc_dna/paired/fusarium_venenatum/c-varient/assembly/spades/$Organism/$Strain
   qsub $ProgDir/subSpades_2lib.sh $TrimF1 $TrimR1 $TrimF2 $TrimR2 $OutDir correct 10
 done

#######################################################################################################
##############################    New Cluster    ######################################################
#######################################################################################################

Slurm 

   for StrainPath in $(ls -d ../../projects/oldhome/connellj/miseq/c_variant_sequencing/2019/qc_dna/paired/fusarium_venenatum/c-varient); do
    ProgDir=../../projects/oldhome/connellj/genome_assembly_subscripts
    Strain=$(echo $StrainPath | rev | cut -f1 -d '/' | rev)
    Organism=$(echo $StrainPath | rev | cut -f2 -d '/' | rev)
    F_Read=$(ls $StrainPath/F/c9_S1_L001_R1_001_trim.fq.gz)
    R_Read=$(ls $StrainPath/R/c9_S1_L001_R2_001_trim.fq.gz)
    OutDir=../../projects/oldhome/connellj/miseq/c_variant_sequencing/2019/qc_dna/paired/fusarium_venenatum/c-varient/assembly/spades/c9/$Organism/${Strain}
    echo $F_Read
    echo $R_Read
    sbatch $ProgDir/slurm_spades_30cpu.sh $F_Read $R_Read $OutDir correct 10
    # OutDir=assembly/spades/$Organism/${Strain}_2
    # sbatch $ProgDir/slurm_spades.sh $F_Read $R_Read $OutDir correct
  done
  

  for StrainPath in $(ls -d ../../projects/oldhome/connellj/miseq/c_variant_sequencing/2019/qc_dna/paired/fusarium_venenatum/c-varient); do
    ProgDir=../../projects/oldhome/connellj/genome_assembly_subscripts
    Strain=$(echo $StrainPath | rev | cut -f1 -d '/' | rev)
    Organism=$(echo $StrainPath | rev | cut -f2 -d '/' | rev)
    F_Read=$(ls $StrainPath/F/c15_S3_L001_R1_001_trim.fq.gz)
    R_Read=$(ls $StrainPath/R/c15_S3_L001_R2_001_trim.fq.gz)
    OutDir=../../projects/oldhome/connellj/miseq/c_variant_sequencing/2019/qc_dna/paired/fusarium_venenatum/c-varient/assembly/spades/c15/$Organism/${Strain}
    echo $F_Read
    echo $R_Read
    sbatch $ProgDir/slurm_spades.sh $F_Read $R_Read $OutDir correct 10
    # OutDir=assembly/spades/$Organism/${Strain}_2
    # sbatch $ProgDir/slurm_spades.sh $F_Read $R_Read $OutDir correct
  done
   
  
Quast - Evaluates genome assemblies: 

  ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/assemblers/assembly_qc/quast
  for Assembly in $(ls miseq/c_variant_sequencing/2019/qc_dna/paired/fusarium_venenatum/c-varient/assembly/spades/c9/fusarium_venenatum/c-varient/filtered_contigs/contigs_min_500bp.fasta); do
  Strain=$(echo $Assembly | rev | cut -f3 -d '/' | rev)
  Organism=$(echo $Assembly | rev | cut -f4 -d '/' | rev)  
  # OutDir=assembly/spades/$Organism/$Strain
  OutDir=miseq/c_variant_sequencing/2019/qc_dna/paired/fusarium_venenatum/c-varient/assembly/spades/c9/fusarium_venenatum/c-varient/filtered_contigs/quast
  qsub $ProgDir/sub_quast.sh $Assembly $OutDir
done

  ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/assemblers/assembly_qc/quast
  for Assembly in $(ls miseq/c_variant_sequencing/2019/qc_dna/paired/fusarium_venenatum/c-varient/assembly/spades/c15/fusarium_venenatum/c-varient/filtered_contigs/contigs_min_500bp.fasta); do
  Strain=$(echo $Assembly | rev | cut -f3 -d '/' | rev)
  Organism=$(echo $Assembly | rev | cut -f4 -d '/' | rev)  
  # OutDir=assembly/spades/$Organism/$Strain
  OutDir=miseq/c_variant_sequencing/2019/qc_dna/paired/fusarium_venenatum/c-varient/assembly/spades/c15/fusarium_venenatum/c-varient/filtered_contigs/quast
  qsub $ProgDir/sub_quast.sh $Assembly $OutDir
done



The results of quast were shown using the following commands:

  for Assembly in $(ls miseq/c_variant_sequencing/2019/qc_dna/paired/fusarium_venenatum/c-varient/assembly/spades/c9/fusarium_venenatum/c-varient/filtered_contigs/quast/transposed_report.tsv); do
    Strain=$(echo $Assembly | rev | cut -f3 -d '/' | rev);
    Organism=$(echo $Assembly | rev | cut -f4 -d '/' | rev);
    # echo;
    # echo $Organism;
    # echo $Strain;
    cat $Assembly | tail -n +2 | sed "s/contigs_min_500bp/${Organism}_${Strain}/g"
  done > miseq/c_variant_sequencing/2019/qc_dna/paired/fusarium_venenatum/c-varient/assembly/spades/c9/fusarium_venenatum/c-varient/filtered_contigs/quast/quast_results.txt

  for Assembly in $(ls miseq/c_variant_sequencing/2019/qc_dna/paired/fusarium_venenatum/c-varient/assembly/spades/c15/fusarium_venenatum/c-varient/filtered_contigs/quast/transposed_report.tsv); do
    Strain=$(echo $Assembly | rev | cut -f3 -d '/' | rev);
    Organism=$(echo $Assembly | rev | cut -f4 -d '/' | rev);
    # echo;
    # echo $Organism;
    # echo $Strain;
    cat $Assembly | tail -n +2 | sed "s/contigs_min_500bp/${Organism}_${Strain}/g"
  done > miseq/c_variant_sequencing/2019/qc_dna/paired/fusarium_venenatum/c-varient/assembly/spades/c15/fusarium_venenatum/c-varient/filtered_contigs/quast/quast_results.txt


Contigs were renamed in accordance with ncbi recomendations:


  ProgDir=$(ls -d /home/armita/git_repos/emr_repos/tools/seq_tools/assemblers/assembly_qc/remove_contaminants)
  touch tmp.csv
  for Assembly in $(ls miseq/c_variant_sequencing/2019/qc_dna/paired/fusarium_venenatum/c-varient/assembly/spades/c9/fusarium_venenatum/c-varient/filtered_contigs/contigs_min_500bp.fasta); do
    Strain=$(echo $Assembly | rev | cut -f3 -d '/' | rev)
    Organism=$(echo $Assembly | rev | cut -f4 -d '/' | rev)  
    OutDir=miseq/c_variant_sequencing/2019/qc_dna/paired/fusarium_venenatum/c-varient/assembly/spades/c9/fusarium_venenatum/c-varient/filtered_contigs/filtered
    $ProgDir/remove_contaminants.py --inp $Assembly --out $OutDir/contigs_min_500bp_renamed.fasta --coord_file tmp.csv
  done
  rm tmp.csv


  ProgDir=$(ls -d /home/armita/git_repos/emr_repos/tools/seq_tools/assemblers/assembly_qc/remove_contaminants)
  touch tmp.csv
  for Assembly in $(ls miseq/c_variant_sequencing/2019/qc_dna/paired/fusarium_venenatum/c-varient/assembly/spades/c15/fusarium_venenatum/c-varient/filtered_contigs/contigs_min_500bp.fasta); do
    Strain=$(echo $Assembly | rev | cut -f3 -d '/' | rev)
    Organism=$(echo $Assembly | rev | cut -f4 -d '/' | rev)  
    OutDir=miseq/c_variant_sequencing/2019/qc_dna/paired/fusarium_venenatum/c-varient/assembly/spades/c15/fusarium_venenatum/c-varient/filtered_contigs/filtered
    $ProgDir/remove_contaminants.py --inp $Assembly --out $OutDir/contigs_min_500bp_renamed.fasta --coord_file tmp.csv
  done
  rm tmp.csv



Repeat masking was performed and used the following programs: Repeatmasker Repeatmodeler
The renamed assembly was used to perform repeatmasking.


for Assembly in $(ls miseq/c_variant_sequencing/2019/qc_dna/paired/fusarium_venenatum/c-varient/assembly/spades/c9/fusarium_venenatum/c-varient/filtered_contigs/filtered/contigs_min_500bp_renamed.fasta); do
Strain=$(echo $Assembly | rev | cut -f3 -d '/' | rev)
Organism=$(echo $Assembly | rev | cut -f4 -d '/' | rev)
echo "$Organism"
echo "$Strain"
OutDir=miseq/c_variant_sequencing/2019/qc_dna/paired/fusarium_venenatum/c-varient/assembly/spades/c9/fusarium_venenatum/c-varient/filtered_contigs/filtered/repeat_masked
ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/repeat_masking
qsub $ProgDir/rep_modeling.sh $Assembly $OutDir
qsub $ProgDir/transposonPSI.sh $Assembly $OutDir
done



for Assembly in $(ls miseq/c_variant_sequencing/2019/qc_dna/paired/fusarium_venenatum/c-varient/assembly/spades/c15/fusarium_venenatum/c-varient/filtered_contigs/filtered/contigs_min_500bp_renamed.fasta); do
Strain=$(echo $Assembly | rev | cut -f3 -d '/' | rev)
Organism=$(echo $Assembly | rev | cut -f4 -d '/' | rev)
echo "$Organism"
echo "$Strain"
OutDir=miseq/c_variant_sequencing/2019/qc_dna/paired/fusarium_venenatum/c-varient/assembly/spades/c15/fusarium_venenatum/c-varient/filtered_contigs/filtered/repeat_masked
ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/repeat_masking
qsub $ProgDir/rep_modeling.sh $Assembly $OutDir
qsub $ProgDir/transposonPSI.sh $Assembly $OutDir
done


Busco was run to check gene space in assemblies


 for Assembly in $(ls miseq/c_variant_sequencing/2019/qc_dna/paired/fusarium_venenatum/c-varient/assembly/spades/c9/fusarium_venenatum/c-varient/filtered_contigs/filtered/repeat_masked/filtered_contigs_contigs_unmasked.fa); do
    Strain=$(echo $Assembly| rev | cut -d '/' -f3 | rev)
    Organism=$(echo $Assembly | rev | cut -d '/' -f4 | rev)
    echo "$Organism - $Strain"
    ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/assemblers/assembly_qc/quast
    OutDir=$(dirname $Assembly)
    qsub $ProgDir/sub_quast.sh $Assembly $OutDir
    ProgDir=/home/armita/git_repos/emr_repos/tools/gene_prediction/busco
    BuscoDB=$(ls -d /home/groups/harrisonlab/dbBusco/sordariomyceta_odb9)
    OutDir=gene_pred/busco/$Organism/$Strain/assembly
    qsub $ProgDir/sub_busco3.sh $Assembly $BuscoDB $OutDir
  done


  for Assembly in $(ls miseq/c_variant_sequencing/2019/qc_dna/paired/fusarium_venenatum/c-varient/assembly/spades/c15/fusarium_venenatum/c-varient/filtered_contigs/filtered/repeat_masked/filtered_contigs_contigs_unmasked.fa); do
    Strain=$(echo $Assembly| rev | cut -d '/' -f3 | rev)
    Organism=$(echo $Assembly | rev | cut -d '/' -f4 | rev)
    echo "$Organism - $Strain"
    ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/assemblers/assembly_qc/quast
    OutDir=$(dirname $Assembly)
    qsub $ProgDir/sub_quast.sh $Assembly $OutDir
    ProgDir=/home/armita/git_repos/emr_repos/tools/gene_prediction/busco
    BuscoDB=$(ls -d /home/groups/harrisonlab/dbBusco/sordariomyceta_odb9)
    OutDir=gene_pred/busco/$Organism/$Strain/assembly
    qsub $ProgDir/sub_busco3.sh $Assembly $BuscoDB $OutDir
  done



  sacct -j 8713 --format JobID,JobName,User,ReqMem,MaxVMSize,MaxRSS,NodeList,AllocCPUS,TotalCPU,State,Start,End

  sacct -j 8648


  --------------------------------------------
  --------     SNP CALL NEW GENOMES     ------
  --------------------------------------------

  # 1. Alignemt of C variant reads vs WT genome 

Alignment of reads from a single run:

 ```bash
  Reference=$(ls /home/groups/harrisonlab/project_files/fusarium_venenatum/repeat_masked/F.venenatum/WT/illumina_assembly_ncbi/WT_contigs_unmasked.fa)
  for StrainPath in $(ls -d /home/groups/harrisonlab/project_files/fusarium_venenatum/qc_dna/paired/F.venenatum/* | grep -v 'strain1'| grep -v 'WT'| grep -v 'C1' | grep -v 'C2'| grep -v 'C3' | grep -v 'C4' | grep -v 'C5' | grep -v 'C6' | grep -v 'C9'); do
    Strain=$(echo $StrainPath | rev | cut -f1 -d '/' | rev)
    Organism=$(echo $StrainPath | rev | cut -f2 -d '/' | rev)
    F_Read=$(ls $StrainPath/F/*_trim.fq.gz)
    R_Read=$(ls $StrainPath/R/*_trim.fq.gz)
    echo "$Organism - $Strain"
    echo $F_Read
    echo $R_Read
    OutDir=/home/groups/harrisonlab/project_files/fusarium_venenatum/qc_dna/paired/F.venenatum/C15/alignment/bowtie/$Organism/$Strain/vs_WT_illumina
    ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/genome_alignment
    qsub $ProgDir/bowtie/sub_bowtie.sh $Reference $F_Read $R_Read $OutDir
    # OutDir=alignment/bwa/$Organism/$Strain/vs_Fv_illumina
    # ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/genome_alignment/bwa
    # qsub $ProgDir/sub_bwa.sh $Strain $Reference $F_Read $R_Read $OutDir
  done
```

  Reference=$(ls repeat_masked/F.venenatum/WT/illumina_assembly_ncbi/WT_contigs_unmasked.fa)
  for StrainPath in $(ls -d qc_dna/paired/F.venenatum/C15); do
    Strain=$(echo $StrainPath | rev | cut -f1 -d '/' | rev)
    Organism=$(echo $StrainPath | rev | cut -f2 -d '/' | rev)
    F_Read=$(ls $StrainPath/F/*_trim.fq.gz)
    R_Read=$(ls $StrainPath/R/*_trim.fq.gz)
    echo "$Organism - $Strain"
    echo $F_Read
    echo $R_Read
    OutDir=qc_dna/paired/F.venenatum/C15/alignment/bowtie/$Organism/$Strain/vs_WT_illumina 
    ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/genome_alignment
    qsub $ProgDir/bowtie/sub_bowtie.sh $Reference $F_Read $R_Read $OutDir
    # OutDir=alignment/bwa/$Organism/$Strain/vs_Fv_illumina
    # ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/genome_alignment/sub_bwa 
    # qsub $ProgDir/sub_bwa.sh $Strain $Reference $F_Read $R_Read $OutDir
  done


# 2. Pre SNP calling cleanup


## 2.1 Rename input mapping files in each folder by prefixing with the strain ID

```bash
  for File in $(ls alignment/bowtie/*/*/vs_Fv_illumina/WT_contigs_unmasked.fa_aligned.sam); do
    Strain=$(echo $File | rev | cut -f3 -d '/' | rev)
    Organism=$(echo $File | rev | cut -f4 -d '/' | rev)
    echo $Strain
    echo $Organism
    OutDir=analysis/popgen/$Organism/$Strain
    CurDir=$PWD
    mkdir -p $OutDir
    cd $OutDir
    cp -s $CurDir/$File "$Strain"_vs_Fv_illumina_aligned.sam
    cd $CurDir
  done

  ## 2.2 Remove multimapping reads, discordant reads. PCR and optical duplicates, and add read group and sample name to each mapped read (preferably, the shortest ID possible)

Convention used:
qsub $ProgDir/sub_pre_snp_calling.sh <INPUT SAM FILE> <SAMPLE_ID>

```bash
 for Sam in $(ls analysis/popgen/*/*/*_vs_Fv_illumina_aligned.sam); do
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
Reference=$(ls ../fusarium_venenatum/repeat_masked/F.venenatum/WT/illumina_assembly_ncbi/WT_contigs_unmasked.fa)
OutDir=repeat_masked/F.venenatum/WT/illumina_assembly_ncbi
mkdir -p $OutDir
cp $Reference $OutDir/.
```
Then the local assembly was indexed:

```bash
Reference=$(ls repeat_masked/F.venenatum/WT/illumina_assembly_ncbi/WT_contigs_unmasked.fa)
OutDir=$(dirname $Reference)
mkdir -p $OutDir
ProgDir=/home/sobczm/bin/picard-tools-2.5.0
java -jar $ProgDir/picard.jar CreateSequenceDictionary R=$Reference O=$OutDir/WT_contigs_unmasked.dict
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
OutDir=analysis/popgen/SNP_calling
mkdir -p $OutDir
cd $OutDir
ProgDir=/home/connellj/git_repos/scripts/Fv_C-variants/SNP_calling
qsub $ProgDir/sub_SNP_calling_multithreaded.sh
cd $CurDir
```

Only retain biallelic high-quality SNPS with no missing data (for any individual) for genetic analyses below (in some cases, may allow some missing data in order to retain more SNPs, or first remove poorly sequenced individuals with too much missing data and then filter the SNPs).

```bash
cp analysis/popgen/SNP_calling/WT_contigs_unmasked_temp.vcf analysis/popgen/SNP_calling/WT_contigs_unmasked.vcf
Vcf=$(ls analysis/popgen/SNP_calling/WT_contigs_unmasked.vcf)
ProgDir=/home/armita/git_repos/emr_repos/scripts/popgen/snp
# mq=40
# qual=30
# dp=10
# gq=30
# na=0.95
# removeindel=Y
qsub $ProgDir/sub_vcf_parser.sh $Vcf 40 30 10 30 1 Y

## Remove sequencing errors from vcf files:

```bash
Vcf=$(ls analysis/popgen/SNP_calling_illumina/WT_contigs_unmasked_filtered.vcf)
OutDir=$(dirname $Vcf)
Errors=$OutDir/Fv_illumina_error_SNPs.tsv
FilteredVcf=$OutDir/WT_contigs_unmasked_filtered_no_errors.vcf
ProgDir=/home/armita/git_repos/emr_repos/scripts/phytophthora/Pcac_popgen
$ProgDir/flag_error_SNPs.py --inp_vcf $Vcf --ref_isolate 414 --errors $Errors --filtered $FilteredVcf
echo "The number of probable errors from homozygous SNPs being called from reference illumina reads vs the reference assembly is:"
cat $Errors | wc -l
echo "These have been removed from the vcf file"


# Identify SNPs in gene models:

Create custom SnpEff genome database

```bash
SnpEff=/home/sobczm/bin/snpEff
nano $SnpEff/snpEff.config
```


Add the following lines to the section with databases:

```
#---
# EMR Databases
#----
# Fus2 genome
Fus2v1.0.genome : Fus2
# Bc16 genome
Bc16v1.0.genome: BC-16
# P414 genome
P414v1.0.genome: 414
# Fv illumina genome
Fv_v1.0.genome : Fv_illumina
```

Collect input files

```bash
Reference=$(ls /home/groups/harrisonlab/project_files/fusarium_venenatum/repeat_masked/F.venenatum/WT/illumina_assembly_ncbi/WT_contigs_unmasked.fa)
Gff=$(ls /home/groups/harrisonlab/project_files/fusarium_venenatum/gene_pred/final/F.venenatum/WT/final/final_genes_appended_renamed.gff3)
SnpEff=/home/sobczm/bin/snpEff
mkdir $SnpEff/data/Fv_v1.0
cp $Reference $SnpEff/data/Fv_v1.0/sequences.fa
cp $Gff $SnpEff/data/Fv_v1.0/genes.gff

#Build database using GFF3 annotation
java -jar $SnpEff/snpEff.jar build -gff3 -v Fv_v1.0
```


## Annotate VCF files
```bash
CurDir=home/groups/harrisonlab/project_files/Fv_C-variants
cd $CurDir
for a in $(ls analysis/SNP_calling/analysis/popgen/SNP_calling/WT_contigs_unmasked_filtered.vcf); do
    echo $a
    filename=$(basename "$a")
    Prefix=${filename%.vcf}
    OutDir=$(ls -d /home/groups/harrisonlab/project_files/Fv_C-variants/analysis/SNP_calling/analysis/popgen/SNP_calling)
    SnpEff=/home/sobczm/bin/snpEff
    java -Xmx4g -jar $SnpEff/snpEff.jar -v -ud 0 Fv_v1.0 $a > $OutDir/"$Prefix"_annotated.vcf
    mv snpEff_genes.txt $OutDir/snpEff_genes_"$Prefix".txt
    mv snpEff_summary.html $OutDir/snpEff_summary_"$Prefix".html
    # mv WT_contigs_unmasked_filtered* $OutDir/.
    #-
    #Create subsamples of SNPs containing those in a given category
    #-
    #genic (includes 5', 3' UTRs)
    java -jar $SnpEff/SnpSift.jar filter "(ANN[*].EFFECT has 'missense_variant') || (ANN[*].EFFECT has 'nonsense_variant') || (ANN[*].EFFECT has 'synonymous_variant') || (ANN[*].EFFECT has 'intron_variant') || (ANN[*].EFFECT has '5_prime_UTR_variant') || (ANN[*].EFFECT has '3_prime_UTR_variant')" $OutDir/"$Prefix"_annotated.vcf > 
    #coding
    java -jar $SnpEff/SnpSift.jar filter "(ANN[0].EFFECT has 'missense_variant') || (ANN[0].EFFECT has 'nonsense_variant') || (ANN[0].EFFECT has 'synonymous_variant')" $OutDir/"$Prefix"_annotated.vcf > $OutDir/"$Prefix"_coding.vcf
    #non-synonymous
    java -jar $SnpEff/SnpSift.jar filter "(ANN[0].EFFECT has 'missense_variant') || (ANN[0].EFFECT has 'nonsense_variant')" $OutDir/"$Prefix"_annotated.vcf > $OutDir/"$Prefix"_nonsyn.vcf
    #synonymous
    java -jar $SnpEff/SnpSift.jar filter "(ANN[0].EFFECT has 'synonymous_variant')" $OutDir/"$Prefix"_annotated.vcf > $OutDir/"$Prefix"_syn.vcf
    #Four-fold degenrate sites (output file suffix: 4fd)
    ProgDir=/home/sobczm/bin/popgen/summary_stats
    python $ProgDir/parse_snpeff_synonymous.py $OutDir/"$Prefix"_syn.vcf
    AllSnps=$(cat $OutDir/"$Prefix"_annotated.vcf | grep -v '#' | wc -l)
    GeneSnps=$(cat $OutDir/"$Prefix"_gene.vcf | grep -v '#' | wc -l)
    CdsSnps=$(cat $OutDir/"$Prefix"_coding.vcf | grep -v '#' | wc -l)
    NonsynSnps=$(cat $OutDir/"$Prefix"_nonsyn.vcf | grep -v '#' | wc -l)
    SynSnps=$(cat $OutDir/"$Prefix"_syn.vcf | grep -v '#' | wc -l)
    printf "Comparison\$AllSnps\tGeneSnps\tCdsSnps\tSynSnps\tNonsynSnps\n"
    printf "$Prefix\t$AllSnps\t$GeneSnps\t$CdsSnps\t$SynSnps\t$NonsynSnps\n"


done
```

# Prepare isolates for SV calling 

```bash
CurDir=$PWD
Reference=$(ls ../../../../../../../home/groups/harrisonlab/project_files/fusarium_venenatum/repeat_masked/F.venenatum/WT/illumina_assembly_ncbi/WT_contigs_unmasked.fa)
for StrainPath in $(ls -d /home/groups/harrisonlab/project_files/fusarium_venenatum/qc_dna/paired/F.venenatum/* | grep -v 'strain1'| grep -v 'WT'); do
  Strain=$(echo $StrainPath | rev | cut -f1 -d '/' | rev)
  Organism=$(echo $StrainPath | rev | cut -f2 -d '/' | rev)
  echo $Strain
  echo $Organism
    ReadsF=$(ls $StrainPath/F/*fq.gz)
    ReadsR=$(ls $StrainPath/R/*fq.gz)
    ConcatTmpDir=tmp_concat_dir
    mkdir -p $ConcatTmpDir
    ConcatF=$ConcatTmpDir/"$Strain"_F_reads.fq.gz
    ConcatR=$ConcatTmpDir/"$Strain"_R_reads.fq.gz
    cat $ReadsF > $ConcatF
    cat $ReadsR > $ConcatR
    OutDir=../../../../../../../home/groups/harrisonlab/project_files/Fv_C-variants/analysis/SV_calling
    ProgDir=/home/armita/git_repos/emr_repos/scripts/phytophthora/Pcac_popgen
    qsub $ProgDir/sub_prep_lumpy.sh $Strain $CurDir/$Reference $ConcatF $ConcatR $OutDir
done
```

# Call SVs using .bam alignments with SVABA


Prefix=Fven_svaba
 Reference=$(ls /home/groups/harrisonlab/project_files/fusarium_venenatum/repeat_masked/F.venenatum/WT/illumina_assembly_ncbi/WT_contigs_unmasked.fa)
 AlignDir=/data/scratch/connellj/Fusarium_venenatum/Illumina_indel_calling/indel_calling/sorted_c_variant
 OutDir=/data/scratch/connellj/Fusarium_venenatum/Illumina_indel_calling/indel_calling/sorted_c_variant
 ProgDir=/home/armita/git_repos/emr_repos/scripts/phytophthora/Pcac_popgen
 qsub $ProgDir/sub_svaba.sh $Prefix $Reference $AlignDir $OutDir

# Filter out the low quality SV calls ------------
#################################NOT DONG THIS TO KEEP ALL CALLS 

# cp analysis/popgen/Fv_indel_calling/svaba/Fven_svaba_sv.svaba.unfiltered.indel.vcf analysis/popgen/Fv_indel_calling/svaba/Fven_svaba_sv.svaba.filtered.indel.vcf
for Vcf in $(ls analysis/popgen/Fv_indel_calling/svaba/Fven_svaba_sv.svaba.*.vcf | grep -v -e 'unfiltered' -e 'filtered' -e 'no_errors'); do
ProgDir=/home/armita/git_repos/emr_repos/scripts/phytophthora/Pcac_popgen
qsub $ProgDir/sub_vcf_parser_only_indels.sh $Vcf 40 30 10 30 1
done

###########################################################################################
#########################              ANNOTATE SV FILES             #####################
###########################################################################################
 
######################################Create custom SnpEff genome database

SnpEff=/home/sobczm/bin/snpEff
nano $SnpEff/snpEff.config
Collect input files

############################################Collect input files 

Reference=$(ls /home/groups/harrisonlab/project_files/fusarium_venenatum/repeat_masked/F.venenatum/WT/illumina_assembly_ncbi/WT_contigs_unmasked.fa)
Gff=$(ls /home/groups/harrisonlab/project_files/fusarium_venenatum/gene_pred/final/F.venenatum/WT/final/final_genes_appended_renamed.gff3)
SnpEff=/home/sobczm/bin/snpEff
mkdir $SnpEff/data/Fv_v1.0
cp $Reference $SnpEff/data/Fv_v1.0/sequences.fa
cp $Gff $SnpEff/data/Fv_v1.0/genes.gff

#####################################Build database using GFF3 annotation

java -jar $SnpEff/snpEff.jar build -gff3 -v Fv_v1.0

############################################## Annotate VCF files

CurDir=/data/scratch/connellj/Fusarium_venenatum/Illumina_indel_calling/indel_calling/sorted_c_variant/Structural_variant
cd $CurDir
for a in $(ls /data/scratch/connellj/Fusarium_venenatum/Illumina_indel_calling/indel_calling/sorted_c_variant/Structural_variant/SV_filtered.vcf); do
    echo $a
    filename=$(basename "$a")
    Prefix=${filename%.vcf}
    OutDir=$(ls -d /data/scratch/connellj/Fusarium_venenatum/Illumina_indel_calling/indel_calling/sorted_c_variant/Structural_variant)
    SnpEff=/home/sobczm/bin/snpEff
    java -Xmx4g -jar $SnpEff/snpEff.jar -v -ud 0 Fv_v1.0 $a > $OutDir/"$Prefix"_annotated.vcf
    mv snpEff_genes.txt $OutDir/snpEff_genes_"$Prefix".txt
    mv snpEff_summary.html $OutDir/snpEff_summary_"$Prefix".html
    # mv WT_contigs_unmasked_filtered* $OutDir/.
    #-
    #Create subsamples of SNPs containing those in a given category
    #-
    #genic (includes 5', 3' UTRs)
    java -jar $SnpEff/SnpSift.jar filter "(ANN[*].EFFECT has 'missense_variant') || (ANN[*].EFFECT has 'nonsense_variant') || (ANN[*].EFFECT has 'synonymous_variant') || (ANN[*].EFFECT has 'intron_variant') || (ANN[*].EFFECT has '5_prime_UTR_variant') || (ANN[*].EFFECT has '3_prime_UTR_variant')" $OutDir/"$Prefix"_annotated.vcf > 
    #coding
    java -jar $SnpEff/SnpSift.jar filter "(ANN[0].EFFECT has 'missense_variant') || (ANN[0].EFFECT has 'nonsense_variant') || (ANN[0].EFFECT has 'synonymous_variant')" $OutDir/"$Prefix"_annotated.vcf > $OutDir/"$Prefix"_coding.vcf
    #non-synonymous
    java -jar $SnpEff/SnpSift.jar filter "(ANN[0].EFFECT has 'missense_variant') || (ANN[0].EFFECT has 'nonsense_variant')" $OutDir/"$Prefix"_annotated.vcf > $OutDir/"$Prefix"_nonsyn.vcf
    #synonymous
    java -jar $SnpEff/SnpSift.jar filter "(ANN[0].EFFECT has 'synonymous_variant')" $OutDir/"$Prefix"_annotated.vcf > $OutDir/"$Prefix"_syn.vcf
    #Four-fold degenrate sites (output file suffix: 4fd)
    ProgDir=/home/sobczm/bin/popgen/summary_stats
    python $ProgDir/parse_snpeff_synonymous.py $OutDir/"$Prefix"_syn.vcf
    AllSnps=$(cat $OutDir/"$Prefix"_annotated.vcf | grep -v '#' | wc -l)
    GeneSnps=$(cat $OutDir/"$Prefix"_gene.vcf | grep -v '#' | wc -l)
    CdsSnps=$(cat $OutDir/"$Prefix"_coding.vcf | grep -v '#' | wc -l)
    NonsynSnps=$(cat $OutDir/"$Prefix"_nonsyn.vcf | grep -v '#' | wc -l)
    SynSnps=$(cat $OutDir/"$Prefix"_syn.vcf | grep -v '#' | wc -l)
    printf "Comparison\$AllSnps\tGeneSnps\tCdsSnps\tSynSnps\tNonsynSnps\n"
    printf "$Prefix\t$AllSnps\t$GeneSnps\t$CdsSnps\t$SynSnps\t$NonsynSnps\n"






awk -F '\t' '{if($0 ~ /\#/) print; else if($7 == "PASS") print}' SV_filtered_annotated.vcf > SV_filtered_annotated_pass.vcf

awk 'BEGIN {OFS ="," ; FS = "\t"};{print $8}' SV_filtered_annotated.vcf > SV_filtered_annotated_pass.vcf


cut SV_filtered_annotated.vcf -f 12,13
