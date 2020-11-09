#!/bin/bash
#SBATCH --partition=unlimited
#SBATCH --time=24:00:00
#SBATCH --mem=200gb
#SBATCH --cpus-per-task=30


Usage="submit_SPAdes.sh <F_read.fa> <R_read.fa> <output_directory> <correct/only-assembler> [<coverage_cutoff>]"
echo "$Usage"

R1=$1
R2=$2
OutDir=$3
Correction=$4
Cutoff='auto'
if [ $5 ]; then
  Cutoff=$5
fi

CurPath=$PWD
WorkDir=${TMPDIR}/${SLURM_JOB_ID}
mkdir -p $WorkDir

# Testing parallelisation of GATk HaplotypeCaller - may crash. (It did not! Resulted in 2x speedup)
# NOTE: this is a haploid organism. For diploid organism, change "ploidy" argument to 2.
# Changes required in the script:
# VARIABLES
# Reference - the genome reference used in read mapping.
# INSIDE THE GATK command:
# To specify which BAM mapping files (Out1 from pre_SNP_calling_cleanup.sh, RefName ending with "_rg" -> that is, with
# read group added) are to be used in SNP calling, use the -I argument with full path to each file following after that.
# Each new BAM file has to be specified after a separate -I

Project=../../projects/oldhome/groups/harrisonlab/project_files/Fv_C-variants/analysis/SNP_calling/new_c_variants
OutDir=../../projects/oldhome/groups/harrisonlab/project_files/Fv_C-variants/analysis/SNP_calling/
Reference=$(ls ../../projects/oldhome/groups/harrisonlab/project_files/Fv_C-variants/analysis/SNP_calling/new_c_variants/C9/WT_contigs_unmasked.fa)

RefName=$(basename "$Reference")
Out1="${RefName%.*}_temp.vcf"
Out2="${RefName%.*}.vcf"
 

ProgDir=../../projects/oldhome/sobczm/bin/GenomeAnalysisTK-3.6

java -jar $ProgDir/GenomeAnalysisTK.jar \
     -R $Reference \
     -T HaplotypeCaller \
     -ploidy 1 \
     -nct 24 \
     --allow_potentially_misencoded_quality_scores \
     -I $Project/C9/C9_contigs_unmasked.fa_aligned_sorted_nomulti_proper_sorted_nodup_rg.bam \
     -I $Project/C15/C15_contigs_unmasked.fa_aligned_sorted_nomulti_proper_sorted_nodup_rg.bam \
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