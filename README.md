# 1. SNP Calling pileup 

#This document details commands used for SNP calling pileup in F. venenatum C-variants vs a reference wild-type assembly.



#1.) First the genome coverage of those variants intended to be used in the anlysis was analysed and those with <30x coverage are excluded. 


for Strain in C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19; do 
 for DataDir in $(ls -d ../../projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/$Strain); do
    F_Read=$(ls $DataDir/F/*.gz)
    R_Read=$(ls $DataDir/R/*.gz)
    Outdir=../../projects/fusarium_venenatum_miseq/genomes/$Strain/genome_coverage
    echo $F_Read
    echo $R_Read
    echo $Outdir
    mkdir -p $Outdir
    ProgDir=/home/gomeza/git_repos/scripts/bioinformatics_tools/SEQdata_qc
    sbatch $ProgDir/count_nucl.sh $F_Read $R_Read 37 $Outdir #Estimated genome size
 done
done


#2.) Carryout alignment of genomes using bowtie. 


for Cvarient in C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19; do 
  Reference=$(ls ../../projects/fusarium_venenatum_miseq/genomes/WT/WT_contigs_unmasked.fa)
  for StrainPath in $(ls -d ../../projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/"$Cvarient"); do
    Strain=$(echo $StrainPath | rev | cut -f1 -d '/' | rev)
    Organism=$(echo $StrainPath | rev | cut -f2 -d '/' | rev)
    F_Read=$(ls $StrainPath/F/*_trim.fq.gz)
    R_Read=$(ls $StrainPath/R/*_trim.fq.gz)
    echo "$Organism - $Strain"
    echo $F_Read
    echo $R_Read
    OutDir=$StrainPath/alignment 
    mkdir -p $OutDir
    ProgDir=/home/connellj/git_repos/emr_repos/tools/seq_tools/alignment_tools
    sbatch $ProgDir/bowtie.sh $Reference $F_Read $R_Read $OutDir
      Jobs=$(squeue -u ${USER} --noheader --array | wc -l)
         while [ $Jobs -gt 1 ]; do
             sleep 25m
             printf "."
             Jobs=$(squeue -u ${USER} --noheader --array | wc -l)
         done
     printf "\n"
    # OutDir=alignment/bwa/$Organism/$Strain/vs_Fv_illumina
    # ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/genome_alignment/bwa
    # qsub $ProgDir/sub_bwa.sh $Strain $Reference $F_Read $R_Read $OutDir
  done
done 


#3.) Rename input mapping files in each folder by prefixing with the strain ID. 


for Strain in C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19  ; do
  for filename in /projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/$Strain/alignment; do
   echo $Strain
     mv "$filename/WT_contigs_unmasked.fa_aligned.sam" "$filename/"$Strain"_unmasked.fa_aligned.sam"
     mv "$filename/WT_contigs_unmasked.fa_aligned.bam" "$filename/"$Strain"_unmasked.fa_aligned.bam"
     mv "$filename/WT_contigs_unmasked.fa_aligned_sorted.bam" "$filename/"$Strain"_unmasked.fa_aligned_sorted.bam"
     mv "$filename/WT_contigs_unmasked.fa.indexed.1.bt2" "$filename/"$Strain"_contigs_unmasked.fa.indexed.1.bt2"
     mv "$filename/WT_contigs_unmasked.fa.indexed.2.bt2" "$filename/"$Strain"_contigs_unmasked.fa.indexed.2.bt2"
     mv "$filename/WT_contigs_unmasked.fa.indexed.3.bt2" "$filename/"$Strain"_contigs_unmasked.fa.indexed.3.bt2"
     mv "$filename/WT_contigs_unmasked.fa.indexed.4.bt2" "$filename/"$Strain"_contigs_unmasked.fa.indexed.4.bt2"
     mv "$filename/WT_contigs_unmasked.fa.indexed.rev.1.bt2" "$filename/"$Strain"_contigs_unmasked.fa.indexed.rev.1.bt2"
     mv "$filename/WT_contigs_unmasked.fa.indexed.rev.2.bt2" "$filename/"$Strain"_contigs_unmasked.fa.indexed.rev.2.bt2"
     mv "$filename/WT_contigs_unmasked.fa_RPK.txt" "$filename/"$Strain"_contigs_unmasked.fa_RPK.txt"
     mv "$filename/WT_contigs_unmasked.fa_aligned_sorted.bam.index" "$filename/"$Strain"_unmasked.fa_aligned_sorted.bam.index"
  done 
done 


#4.) Remove multimapping reads, discordant reads. PCR and optical duplicates, and add read group and sample name to each mapped read. 


  for Strain in C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19; do # Replace with the strain name
    for input in ../../projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/$Strain/alignment/"$Strain"_unmasked.fa_aligned.sam; do
      Jobs=$(squeue -u ${USER} --noheader --array | wc -l)
         while [ $Jobs -gt 1 ]; do
             sleep 25m
             printf "."
             Jobs=$(squeue -u ${USER} --noheader --array | wc -l)
         done
     printf "\n"
    OutDir=/projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/$Strain/alignment/nomulti/compare
    mkdir -p $OutDir  
    ProgDir=/home/connellj/git_repos/emr_repos/tools/seq_tools/SNP_calling
    sbatch $ProgDir/pre_SNP_calling.sh $input $Strain $OutDir 
    done
  done


#5.) Run RealignerTargetCreator (gatk package) to get realigner.intervals used in the next step.


Reference=../../projects/fusarium_venenatum_miseq/genomes/WT/WT_contigs_unmasked.fa  
for Strain in C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19; do
  for input in ../../projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/$Strain/alignment/nomulti/"$Strain"_unmasked.fa_aligned_nomulti_proper_sorted_nodup_rg.bam; do
    echo $Strain
    Outdir=/projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/$Strain/alignment/nomulti/pre_indel_realignment
    mkdir -p $Outdir
    ProgDir=/home/connellj/git_repos/emr_repos/tools/seq_tools/SNP_calling
    sbatch $ProgDir/pre_indel_realignment.sh $Reference $input $Strain $Outdir
  done 
done     


#6.) Run IndelRealigner using realigner.intervals file from previous step.


Reference=../../projects/fusarium_venenatum_miseq/genomes/WT/WT_contigs_unmasked.fa  
for Strain in C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19; do
  for input in ../../projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/$Strain/alignment/nomulti/"$Strain"_unmasked.fa_aligned_nomulti_proper_sorted_nodup_rg.bam; do
    target_intervals=../../projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/$Strain/alignment/nomulti/pre_indel_realignment/realigner.intervals
    echo $Strain
    Outdir=/projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/$Strain/alignment/nomulti/corrected_bam
    mkdir -p $Outdir
    ProgDir=/home/connellj/git_repos/emr_repos/tools/seq_tools/SNP_calling
    sbatch $ProgDir/indel_realignment.sh $Reference $Strain $input $target_intervals $Outdir
  done 
done  


#7.) Base recalibration is required to prevent systematic errors influencing base call features of snp callers. 


Reference=../../projects/fusarium_venenatum_miseq/genomes/WT/WT_contigs_unmasked.fa  
for Strain in C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19; do
  for input in ../../projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/$Strain/alignment/nomulti/corrected_bam/"$Strain"_realigned.bam; do
    echo $Strain
    Outdir=/projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/$Strain/alignment/nomulti/base_recalibrate
    mkdir -p $Outdir
    ProgDir=/home/connellj/git_repos/emr_repos/tools/seq_tools/SNP_calling
    sbatch $ProgDir/base_recalibrator.sh $Reference $Strain $input $Outdir
  done 
done 











 





