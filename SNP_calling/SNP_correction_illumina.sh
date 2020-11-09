Alignment of three isolates runs 
In this script i am using C variants sequenced using Illumina run against the Minion WT Genome and then aligning them with WT Illumina reads ran agains the Illumina Genome to identify errors.   


bash
  Reference=$(ls ../../../home/groups/harrisonlab/project_files/fusarium_venenatum/repeat_masked/F.venenatum/WT/illumina_assembly_ncbi/WT_contigs_unmasked.fa)
  for StrainPath in $(ls -d ../../../home/groups/harrisonlab/project_files/fusarium_venenatum/qc_dna/paired/F.venenatum/WT); do
    echo $StrainPath
    ProgDir=../../../home/armita/git_repos/emr_repos/tools/seq_tools/assemblers/spades/multiple_libraries
    Strain=$(echo $StrainPath | rev | cut -f1 -d '/' | rev)
    Organism=$(echo $StrainPath | rev | cut -f2 -d '/' | rev)
    echo $Strain
    echo $Organism
    F1_Read=$(ls $StrainPath/F/*_trim.fq.gz | head -n1 | tail -n1);
    R1_Read=$(ls $StrainPath/R/*_trim.fq.gz | head -n1 | tail -n1);
    F2_Read=$(ls $StrainPath/F/*_trim.fq.gz | head -n2 | tail -n1);
    R2_Read=$(ls $StrainPath/R/*_trim.fq.gz | head -n2 | tail -n1);
    F3_Read=$(ls $StrainPath/F/*_trim.fq.gz | head -n3 | tail -n1);
    R3_Read=$(ls $StrainPath/R/*_trim.fq.gz | head -n3 | tail -n1);
    echo $F1_Read
    echo $R1_Read
    echo $F2_Read
    echo $R2_Read
    echo $F3_Read
    echo $R3_Read
    OutDir=/Fusarium_venenatum/F.venenatum/WT/illumina_reference_check/reference_check
    ProgDir=../../../home/armita/git_repos/emr_repos/tools/seq_tools/genome_alignment
    qsub $ProgDir/bowtie/sub_bowtie_3lib.sh $Reference $F1_Read $R1_Read $F2_Read $R2_Read $F3_Read $R3_Read $OutDir
  done


# 2.0 Rename input mapping files in each folder by prefixing with the strain ID

```bash
  for File in $(ls Fusarium_venenatum/*/*/*/reference_check/WT_contigs_unmasked.fa_aligned_sorted.bam); do
    Strain=$(echo $File | rev | cut -f3 -d '/' | rev)
    Organism=$(echo $File | rev | cut -f4 -d '/' | rev)
    echo $Strain
    echo $Organism
    OutDir=Fusarium_venenatum/F.venenatum/WT/illumina_reference_check/reference_check
    CurDir=$PWD
    mkdir -p $OutDir
    cd $OutDir
    cp -s $CurDir/$File "$Strain"_contigs_unmasked.fa_aligned_sorted.bam
    cd $CurDir
  done
```

#3.0 Remove multimapping reads, discordant reads. PCR and optical duplicates, and add read group and sample name to each mapped read (preferably, the shortest ID possible)

Convention used:
qsub $ProgDir/sub_pre_snp_calling.sh <INPUT SAM FILE> <SAMPLE_ID>

```bash
 for bam in $(ls ../../../data/scratch/connellj/Fusarium_venenatum/F.venenatum/WT/illumina_reference_check/reference_check/WT_contigs_unmasked.fa_aligned_sorted.bam); do
    Strain=$(echo $bam | rev | cut -f3 -d '/' | rev)
    Organism=$(echo $bam | rev | cut -f4 -d '/' | rev)
    ProgDir=../../../home/armita/git_repos/emr_repos/scripts/phytophthora/Pcac_popgen
    qsub $ProgDir/sub_pre_snp_calling.sh $bam $Strain
  done
 ``` 

# 4.0 Run SNP calling 

#Runs a SNP calling script from Maria in order to be able to draw up a phylogeny

##Prepare genome reference indexes required by GATK

Firstly, a local version of the assembly was made in this project directory:

```bash
Reference=$(ls ../../../home/groups/harrisonlab/project_files/fusarium_venenatum/repeat_masked/F.venenatum/WT/illumina_assembly_ncbi/WT_contigs_unmasked.fa)
OutDir=/data/scratch/connellj/Fusarium_venenatum/F.venenatum/WT/illumina_reference_check/reference_check/snp_calling_out
mkdir -p $OutDir
cp $Reference $OutDir/.
Reference=$(ls /data/scratch/connellj/Fusarium_venenatum/F.venenatum/WT/illumina_reference_check/reference_check/snp_calling_out/WT_contigs_unmasked.fa)
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

```bash                     (We are here 16/3/18)
CurDir=$PWD
OutDir=$PWD
mkdir -p $OutDir
cd $OutDir
ProgDir=/home/connellj/git_repos/scripts/Fv_C-variants/SNP_calling
qsub $ProgDir/sub_SNP_calling_ref_check.sh
cd $CurDir
```

## Filter SNPs based on this region being present in all isolates

Only retain biallelic high-quality SNPS with no missing data (for any individual) for genetic analyses below (in some cases, may allow some missing data in order to retain more SNPs, or first remove poorly sequenced individuals with too much missing data and then filter the SNPs).

```bash
cp Fusarium_venenatum/MINion_SNP_Calling/WT_albacore_v2_contigs_unmasked.vcf Fusarium_venenatum/MINion_SNP_Calling/WT_albacore_v2_contigs_unmasked.vcf
Vcf=$(ls Fusarium_venenatum/MINion_SNP_Calling/WT_albacore_v2_contigs_unmasked.vcf)
ProgDir=/home/armita/git_repos/emr_repos/scripts/popgen/snp
# mq=40
# qual=30
# dp=10
# gq=30
# na=0.95
# removeindel=Y
qsub $ProgDir/sub_vcf_parser.sh $Vcf 40 30 10 30 1 Y
```

```bash
mv WT_contigs_unmasked_filtered.vcf analysis/popgen/SNP_calling/WT_contigs_unmasked_filtered.vcf
```

<!--
-- 
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
```


 -->

<!--
In some organisms, may want to thin (subsample) SNPs in high linkage diseqilibrium down to
1 SNP  per e.g. 10 kbp just for the population structure analyses.
```bash
VcfTools=/home/sobczm/bin/vcftools/bin
$VcfTools/vcftools --vcf $input_vcf --thin 10000 --recode --out ${input_vcf%.vcf}_thinned
```
-->
<!--
## Collect VCF stats

General VCF stats (remember that vcftools needs to have the PERL library exported)

```bash
  VcfTools=/home/sobczm/bin/vcftools/bin
  export PERL5LIB="$VcfTools:$PERL5LIB"
  VcfFiltered=$(ls analysis/popgen/SNP_calling_illumina/WT_contigs_unmasked_filtered_gene.vcf)
  Stats=$(echo $VcfFiltered | sed 's/.vcf/.stat/g')
  perl $VcfTools/vcf-stats $VcfFiltered > $Stats
```

Calculate the index for percentage of shared SNP alleles between the individuals.

```bash
  for Vcf in $(ls analysis/popgen/SNP_calling/*_unmasked_filtered_no_errors.vcf); do
      ProgDir=/home/armita/git_repos/emr_repos/scripts/popgen/snp
      $ProgDir/similarity_percentage.py $Vcf
  done
```
<!-- 
# Visualise the output as heatmap and clustering dendrogram
```bash
for Log in $(ls analysis/popgen/SNP_calling/*distance.log); do
  ProgDir=/home/armita/git_repos/emr_repos/scripts/popgen/snp
  Rscript --vanilla $ProgDir/distance_matrix.R $Log
  mv Rplots.pdf analysis/popgen/SNP_calling/.
done
```


## Carry out PCA and plot the results

This step could not be carried out due to problems installing dependancies

```bash
for Vcf in $(ls analysis/popgen/SNP_calling/*_unmasked_filtered_no_errors.vcf); do
    echo $Vcf
    ProgDir=/home/armita/git_repos/emr_repos/scripts/popgen/snp
    Out=analysis/popgen/SNP_calling
    echo $Out
    Rscript --vanilla $ProgDir/pca.R $Vcf $Out/PCA.pdf
done
```


## Calculate a NJ tree

These commands didnt work as P. idaei is too distant for sufficient sites to be shared
between isolates

based on all the SNPs. Outputs a basic display of the tree, plus a Newick file to be used for displaying the tree in FigTree and beautifying it.

Remove all missing data for nj tree construction

```bash
  for Vcf in $(ls analysis/popgen/SNP_calling/*_unmasked_filtered_no_errors.vcf); do
    echo $Vcf
    Out=$(basename $Vcf .vcf)
    echo $Out
    VcfTools=/home/sobczm/bin/vcftools/bin
    $VcfTools/vcftools --vcf $Vcf --mac 1 --max-missing 1.0 --recode --out analysis/popgen/SNP_calling/"$Out"_no_missing
  done
```

```bash
for Vcf in $(ls analysis/popgen/SNP_calling/*_no_missing.recode.vcf); do
    echo $Vcf
    Ploidy=2
    ProgDir=/home/armita/git_repos/emr_repos/scripts/popgen/snp
    $ProgDir/nj_tree.sh $Vcf $Ploidy
    mv Rplots.pdf analysis/popgen/SNP_calling/NJ_tree.pdf
done
```

 -->

# Identify SNPs in gene models: (We are here)

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
# Fv MINion genome
Fv_v2.0.genome : Fv_minion
```



Collect input files

```bash
Reference=$(ls /home/groups/harrisonlab/project_files/fusarium_venenatum/repeat_masked/F.venenatum/WT_minion/minion_submission/WT_albacore_v2_contigs_unmasked.fa)
Gff=$(ls /data/scratch/armita/fusarium_venenatum/data/gene_pred/final/F.venenatum/WT_minion/final/final_genes_appended_renamed.gff3)
SnpEff=/home/sobczm/bin/snpEff
mkdir $SnpEff/data/Fv_v2.0
cp $Reference $SnpEff/data/Fv_v2.0/sequences.fa
cp $Gff $SnpEff/data/Fv_v2.0/genes.gff

#Build database using GFF3 annotation
java -jar $SnpEff/snpEff.jar build -gff3 -v Fv_v2.0
```


## Annotate VCF files
```bash
CurDir=/data/scratch/connellj
cd $CurDir
for a in $(ls /home/groups/harrisonlab/project_files/Fusarium_venenatum/MINion_SNP_Calling/Filtered/WT_albacore_v2_contigs_unmasked_filtered.vcf); do
    echo $a
    filename=$(basename "$a")
    Prefix=${filename%.vcf}
    OutDir=$(ls -d Fusarium_venenatum/MINion_SNP_Calling/Filtered/anotated)
    SnpEff=/home/sobczm/bin/snpEff
    java -Xmx4g -jar $SnpEff/snpEff.jar -v -ud 0 Fv_v2.0 $a > $OutDir/"$Prefix"_annotated.vcf
    mv snpEff_genes.txt $OutDir/snpEff_genes_"$Prefix".txt
    mv snpEff_summary.html $OutDir/snpEff_summary_"$Prefix".html
    # mv WT_albacore_v2_contigs_unmasked_filtered* $OutDir/.
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
 -->

