#$ -S /bin/bash
#$ -cwd
#$ -pe smp 12
#$ -l virtual_free=1.25G
#$ -l h=blacklace01.blacklace|blacklace09.blacklace

# Testing parallelisation of GATk HaplotypeCaller - may crash. (It did not! Resulted in 2x speedup)
# NOTE: this is a haploid organism. For diploid organism, change "ploidy" argument to 2.
# Changes required in the script:
# VARIABLES
# Reference - the genome reference used in read mapping.
# INSIDE THE GATK command:
# To specify which BAM mapping files (Out1 from pre_SNP_calling_cleanup.sh, RefName ending with "_rg" -> that is, with
# read group added) are to be used in SNP calling, use the -I argument with full path to each file following after that.
# Each new BAM file has to be specified after a separate -I

Project=/data/scratch/connellj/Fusarium_venenatum/Illumina_indel_calling/indel_calling/sorted_c_variant
OutDir=/data/scratch/connellj/Fusarium_venenatum/Illumina_indel_calling/indel_calling/sorted_c_variant
Reference=$(ls /data/scratch/connellj/Fusarium_venenatum/Illumina_indel_calling/indel_calling/sorted_c_variant/WT_contigs_unmasked.fa)

RefName=$(basename "$Reference")
Out1="${RefName%.*}_temp.vcf"
Out2="${RefName%.*}.vcf"
 

ProgDir=/home/sobczm/bin/GenomeAnalysisTK-3.6

java -jar $ProgDir/GenomeAnalysisTK.jar \
     -R $Reference \
     -T HaplotypeCaller \
     -ploidy 1 \
     -nct 24 \
     --allow_potentially_misencoded_quality_scores \
     -I $Project/C1_sorted.bam\
     -I $Project/C2_sorted.bam\
     -I $Project/C3_sorted.bam\
     -I $Project/C4_sorted.bam\
     -I $Project/C5_sorted.bam\
     -I $Project/C6_sorted.bam\
     -I $Project/C9_sorted.bam\
     -I $Project/C15_sorted.bam\
     -o $Out1

#Break down complex SNPs into primitive ones with VariantsToAllelicPrimitives
#This tool will take an MNP (e.g. ACCCA -> TCCCG) and break it up into separate records for each component part (A-T and A->G).
#This tool modifies only bi-allelic variants.

java -jar $ProgDir/GenomeAnalysisTK.jar \
   -T VariantsToAllelicPrimitives \
   -R $Reference \
   -V $Out1 \
   -o $Out2 \


#####################################
# Notes on GATK parallelisation
#####################################
# http://gatkforums.broadinstitute.org/gatk/discussion/1975/how-can-i-use-parallelism-to-make-gatk-tools-run-faster
