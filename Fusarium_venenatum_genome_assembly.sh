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


for RawData in $(ls raw_dna/paired/*/*/*/*.fastq.gz); do
    echo $RawData;
    ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/dna_qc;
    qsub $ProgDir/run_fastqc.sh $RawData;
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
    sbatch $ProgDir/slurm_spades.sh $F_Read $R_Read $OutDir correct 10
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
   


