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
    ProgDir=/home/connellj/git_repos/emr_repos/Fv_C-variants/SNP_calling_pileup
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
    ProgDir=/home/connellj/git_repos/emr_repos/Fv_C-variants/SNP_calling_pileup
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


for Strain in C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19; do
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


  for Strain in C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19; do 
    for input in ../../projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/$Strain/alignment/"$Strain"_unmasked.fa_aligned.sam; do
  #   Jobs=$(squeue -u ${USER} --noheader --array | wc -l)
  #      while [ $Jobs -gt 1 ]; do
  #          sleep 25m
  #          printf "."
  #          Jobs=$(squeue -u ${USER} --noheader --array | wc -l)
  #      done
  #  printf "\n"
    OutDir=/projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/$Strain/alignment/nomulti/compare
    mkdir -p $OutDir  
    ProgDir=/home/connellj/git_repos/emr_repos/Fv_C-variants/SNP_calling_pileup
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
    ProgDir=/home/connellj/git_repos/emr_repos/Fv_C-variants/SNP_calling_pileup
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
    ProgDir=/home/connellj/git_repos/emr_repos/Fv_C-variants/SNP_calling_pileup
    sbatch $ProgDir/indel_realignment.sh $Reference $Strain $input $target_intervals $Outdir
  done 
done  


#This is not a neccesary step in this pipeline only if VariantsToAllelicPrimatives wasnt run after haplotype caller 
# Correct SNP file from previous GATK run Run variants to primatives (gatk package) on temp.vcf output from haplotype caller 


Reference=../../projects/fusarium_venenatum_miseq/genomes/WT/WT_contigs_unmasked.fa 
for input in ../../projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/SNP_calling_out/WT_contigs_unmasked_temp.vcf; do
  Outdir=/projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/SNP_calling_out/corrected_variants
  mkdir -p $Outdir 
  ProgDir=/home/connellj/git_repos/emr_repos/Fv_C-variants/SNP_calling_pileup
  sbatch $ProgDir/variants_to_primatives.sh $Reference $input $Outdir
done 



#7.) Base recalibration is required to prevent systematic errors influencing base call features of snp callers. This step relies in having known snp and indel locations so these can be excluded from the scoring system


Reference=../../projects/fusarium_venenatum_miseq/genomes/WT/WT_contigs_unmasked.fa  
KnownSNP=../../projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/SNP_calling_out/corrected_variants/corrected_snp.bam
KnownINDEL=../../projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/combined_lumpy_alignment/svaba/Fven_svaba_sv.svaba.unfiltered.indel.vcf
KnownSV=../../projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/combined_lumpy_alignment/svaba/unfiltered_sv/Fven_svaba_sv.svaba.unfiltered.sv.vcf
for Strain in C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19; do
  for input in ../../projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/$Strain/alignment/nomulti/corrected_bam/"$Strain"_realigned.bam; do
    echo $Strain
    Outdir=/projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/$Strain/alignment/nomulti/base_recalibrate
    mkdir -p $Outdir
    ProgDir=/home/connellj/git_repos/emr_repos/Fv_C-variants/SNP_calling_pileup
    sbatch $ProgDir/base_recalibrator.sh $Reference $KnownSNP $KnownINDEL $KnownSV $Strain $input $Outdir
  done 
done 


#8.) Recalibrate bam files with recalibration table generated from previous step         


Reference=../../projects/fusarium_venenatum_miseq/genomes/WT/WT_contigs_unmasked.fa  
for Strain in C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19; do
  for input in ../../projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/$Strain/alignment/nomulti/corrected_bam/"$Strain"_realigned.bam; do
    recalibration_tables=/projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/$Strain/alignment/nomulti/base_recalibrate/"$Strain"_recal.table
    echo $Strain
    Outdir=/projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/$Strain/alignment/nomulti/recalibrated_bam
    mkdir -p $Outdir
    ProgDir=/home/connellj/git_repos/emr_repos/Fv_C-variants/SNP_calling_pileup
    sbatch $ProgDir/bam_recalibrate.sh $Reference $Strain $input $recalibration_tables $Outdir
  done 
done 


#9.) Next evaluate what data looks like after base recalibraton 


Reference=../../projects/fusarium_venenatum_miseq/genomes/WT/WT_contigs_unmasked.fa  
KnownSNP=../../projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/SNP_calling_out/corrected_variants/corrected_snp.bam
KnownINDEL=../../projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/combined_lumpy_alignment/svaba/Fven_svaba_sv.svaba.unfiltered.indel.vcf
KnownSV=../../projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/combined_lumpy_alignment/svaba/unfiltered_sv/Fven_svaba_sv.svaba.unfiltered.sv.vcf
for Strain in C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19; do
  for input in ../../projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/$Strain/alignment/nomulti/corrected_bam/"$Strain"_realigned.bam; do
    recalibration_tables=/projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/$Strain/alignment/nomulti/base_recalibrate/"$Strain"_recal.table
    echo $Strain
    Outdir=/projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/$Strain/alignment/nomulti/base_recalibrate_secondary
    mkdir -p $Outdir
    ProgDir=/home/connellj/git_repos/emr_repos/Fv_C-variants/SNP_calling_pileup
    sbatch $ProgDir/base_recalibrator_secondary.sh $Reference $KnownSNP $KnownINDEL $KnownSV $Strain $input $recalibration_tables $Outdir
  done 
done 


 #10.) Create recalibration plots for before and after recalibration tables to show improved root mean square error of bases         


Reference=../../projects/fusarium_venenatum_miseq/genomes/WT/WT_contigs_unmasked.fa  
for Strain in C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19; do
    primary_recalibration_table=/projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/$Strain/alignment/nomulti/base_recalibrate/"$Strain"_recal.table
    secondary_recalibration_table=/projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/$Strain/alignment/nomulti/base_recalibrate_secondary/"$Strain"_secondary_recal.table
    echo $Strain
    Outdir=/projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/$Strain/alignment/nomulti/recalibration_plots
    mkdir -p $Outdir
    ProgDir=/home/connellj/git_repos/emr_repos/Fv_C-variants/SNP_calling_pileup
    sbatch $ProgDir/Analize_covariates.sh $Reference $Strain $primary_recalibration_table $secondary_recalibration_table $Outdir
done 


#11.) Submit bam files for SNP calling with haplotype caller in gvcf module. Here Bam files are SNP called independantly. 


Reference=../../projects/fusarium_venenatum_miseq/genomes/WT/WT_contigs_unmasked.fa  
for Strain in C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19; do
  for input in ../../projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/$Strain/alignment/nomulti/recalibrated_bam/"$Strain"_recal.bam; do
    echo $Strain
    Outdir=/projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/$Strain/alignment/nomulti/SNP_call
    mkdir -p $Outdir
    ProgDir=/home/connellj/git_repos/emr_repos/Fv_C-variants/SNP_calling_pileup
    sbatch $ProgDir/haplotype_caller_gvcf.sh $Reference $Strain $input $Outdir
  done 
done  



#12. Copy vcf files to a single directory to make the GenotypeGVCF simpler.   


for Strain in C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19; do
  for filename in /projects/fusarium_venenatum_miseq/SNP_calling; do
   echo $Strain
     cp "$filename/F.venenatum/$Strain/alignment/nomulti/SNP_call/"$Strain"_SNP_calls.g.vcf" "$filename"/pileup_calls
     cp /projects/fusarium_venenatum_miseq/genomes/WT/WT_contigs_unmasked.dict /"$filename"/pileup_calls
     cp /projects/fusarium_venenatum_miseq/genomes/WT/WT_contigs_unmasked.fa /"$filename"/pileup_calls
     cp /projects/fusarium_venenatum_miseq/genomes/WT/WT_contigs_unmasked.fa.fai /"$filename"/pileup_calls
  done 
done 



#13.) Combine.vcf files from haplotype caller using GenogypeGVCF and filter only biallelic SNPs. 


ProgDir=/home/connellj/git_repos/emr_repos/Fv_C-variants/SNP_calling_pileup
sbatch $ProgDir/genotype_gvcf.sh 

   

#14.) Annotate VCF file 

# Create custom SnpEff genome database

```bash
SnpEff=/projects/oldhome/sobczm/bin/snpEff
nano $SnpEff/snpEff.config
```


# Add the following lines to the section with databases:

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

#C ollect input files

```bash
Reference=$(ls /projects/fusarium_venenatum_miseq/genomes/WT/WT_contigs_unmasked.fa)
Gff=$(ls /projects/fusarium_venenatum_miseq/gene_prediction/final_genes_appended_renamed.gff3)
SnpEff=/projects/oldhome/sobczm/bin/snpEff
mkdir $SnpEff/data/Fv_v1.0
cp $Reference $SnpEff/data/Fv_v1.0/sequences.fa
cp $Gff $SnpEff/data/Fv_v1.0/genes.gff

#Build database using GFF3 annotation
java -jar $SnpEff/snpEff.jar build -gff3 -v Fv_v1.0
```
 

## Annotate VCF files
```bash
CurDir=../../projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/SNP_calling_out
cd $CurDir
for a in $(ls /projects/fusarium_venenatum_miseq/SNP_calling/pileup_calls/WT_contigs_unmaskedSNPs_filtered.vcf); do
    echo $a
    filename=$(basename "$a")
    Prefix=${filename%.vcf}
    OutDir=$(ls -d /projects/fusarium_venenatum_miseq/SNP_calling/pileup_calls)
    SnpEff=/projects/oldhome/sobczm/bin/snpEff
    java -Xmx4g -jar $SnpEff/snpEff.jar -v -ud 0 Fv_v1.0 $a > $OutDir/"$Prefix"_annotated.vcf
    mv snpEff_genes.txt $OutDir/snpEff_genes_"$Prefix".txt
    mv snpEff_summary.html $OutDir/snpEff_summary_"$Prefix".html
done
   
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
    ProgDir=/projects/oldhome/sobczm/bin/popgen/summary_stats
    python $ProgDir/parse_snpeff_synonymous.py $OutDir/"$Prefix"_syn.vcf
    AllSnps=$(cat $OutDir/"$Prefix"_annotated.vcf | grep -v '#' | wc -l)
    GeneSnps=$(cat $OutDir/"$Prefix"_gene.vcf | grep -v '#' | wc -l)
    CdsSnps=$(cat $OutDir/"$Prefix"_coding.vcf | grep -v '#' | wc -l)
    NonsynSnps=$(cat $OutDir/"$Prefix"_nonsyn.vcf | grep -v '#' | wc -l)
    SynSnps=$(cat $OutDir/"$Prefix"_syn.vcf | grep -v '#' | wc -l)
    printf "Comparison\$AllSnps\tGeneSnps\tCdsSnps\tSynSnps\tNonsynSnps\n"
    printf "$Prefix\t$AllSnps\t$GeneSnps\t$CdsSnps\t$SynSnps\t$NonsynSnps\n"


# WT_contigs_unmaskedSNPs_filtered        385     0       96      43      53

#Pipeline complete 







































## Filter SNPs based on this region being present in all isolates

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
```





#<!--
#In some organisms, may want to thin (subsample) SNPs in high linkage diseqilibrium down to
#1 SNP  per e.g. 10 kbp just for the population structure analyses.
#```bash
#VcfTools=/home/sobczm/bin/vcftools/bin
#$VcfTools/vcftools --vcf $input_vcf --thin 10000 --recode --out ${input_vcf%.vcf}_thinned
#```
#-->
#<!--
## Collect VCF stats

#General VCF stats (remember that vcftools needs to have the PERL library exported)

#```bash
#  VcfTools=/home/sobczm/bin/vcftools/bin
#  export PERL5LIB="$VcfTools:$PERL5LIB"
#  VcfFiltered=$(ls analysis/popgen/SNP_calling_illumina/WT_contigs_unmasked_filtered_gene.vcf)
#  Stats=$(echo $VcfFiltered | sed 's/.vcf/.stat/g')
#  perl $VcfTools/vcf-stats $VcfFiltered > $Stats
#```

#Calculate the index for percentage of shared SNP alleles between the individuals.

#```bash
#  for Vcf in $(ls analysis/popgen/SNP_calling/*_unmasked_filtered_no_errors.vcf); do
#      ProgDir=/home/armita/git_repos/emr_repos/scripts/popgen/snp
#      $ProgDir/similarity_percentage.py $Vcf
#  done
#```
#<!-- 
# Visualise the output as heatmap and clustering dendrogram
#```bash
#for Log in $(ls analysis/popgen/SNP_calling/*distance.log); do
#  ProgDir=/home/armita/git_repos/emr_repos/scripts/popgen/snp
#  Rscript --vanilla $ProgDir/distance_matrix.R $Log
#  mv Rplots.pdf analysis/popgen/SNP_calling/.
#done
#```


## Carry out PCA and plot the results

#This step could not be carried out due to problems installing dependancies

#```bash
#for Vcf in $(ls analysis/popgen/SNP_calling/*_unmasked_filtered_no_errors.vcf); do
#    echo $Vcf
#    ProgDir=/home/armita/git_repos/emr_repos/scripts/popgen/snp
#    Out=analysis/popgen/SNP_calling
#    echo $Out
#    Rscript --vanilla $ProgDir/pca.R $Vcf $Out/PCA.pdf
#done
```


## Calculate a NJ tree

#These commands didnt work as P. idaei is too distant for sufficient sites to be shared
#between isolates

#based on all the SNPs. Outputs a basic display of the tree, plus a Newick file to be used for displaying the tree in FigTree and beautifying it.

#Remove all missing data for nj tree construction

#```bash
#  for Vcf in $(ls analysis/popgen/SNP_calling/*_unmasked_filtered_no_errors.vcf); do
#    echo $Vcf
#    Out=$(basename $Vcf .vcf)
#    echo $Out
#    VcfTools=/home/sobczm/bin/vcftools/bin
#    $VcfTools/vcftools --vcf $Vcf --mac 1 --max-missing 1.0 --recode --out analysis/popgen/SNP_calling/"$Out"_no_missing
#  done
#```

#```bash
# or Vcf in $(ls analysis/popgen/SNP_calling/*_no_missing.recode.vcf); do
#    echo $Vcf
#    Ploidy=2
#    ProgDir=/home/armita/git_repos/emr_repos/scripts/popgen/snp
#    $ProgDir/nj_tree.sh $Vcf $Ploidy
#    mv Rplots.pdf analysis/popgen/SNP_calling/NJ_tree.pdf
#done
```

 #-->

# Identify SNPs in gene models:




done
```
 ```bash
reference=/projects/fusarium_venenatum_miseq/genomes/WT
for Strain in C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19; do
  for filename in /projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/$Strain/alignment; do
   echo $Strain
    cp "$reference"/WT_contigs_unmasked.fa "$filename"/nomulti
    cp "$reference"/WT_contigs_unmasked.fa.fai "$filename"/nomulti
    cp "$reference"/WT_contigs_unmasked.dict "$filename"/nomulti
  done 
done 