#!/usr/bin/env bash
#SBATCH -J genotype_gvcf
#SBATCH --partition=long 
#SBATCH --mem-per-cpu=12G
#SBATCH --cpus-per-task=30


##########################################################################
#SNP call files and WT genome should be collected into the same diretory, WT.dict and WT.fai must also be present. 


in_file=/projects/fusarium_venenatum_miseq/SNP_calling/pileup_calls
reference=/projects/fusarium_venenatum_miseq/SNP_calling/pileup_calls/WT_contigs_unmasked.fa


filename=$(basename "$reference")
output=/projects/fusarium_venenatum_miseq/SNP_calling/pileup_calls/"${filename%.*}_SNPs_unfiltered.vcf"
output2=/projects/fusarium_venenatum_miseq/SNP_calling/pileup_calls/"${filename%.*}SNPs_filtered.vcf"


gatk=/scratch/software/GenomeAnalysisTK-3.6
java -jar $gatk/GenomeAnalysisTK.jar \
     -T GenotypeGVCFs \
     -R $reference \
     -V $in_file/C1_SNP_calls.g.vcf \
	 -V $in_file/C2_SNP_calls.g.vcf \
	 -V $in_file/C3_SNP_calls.g.vcf \
	 -V $in_file/C4_SNP_calls.g.vcf \
	 -V $in_file/C5_SNP_calls.g.vcf \
	 -V $in_file/C6_SNP_calls.g.vcf \
	 -V $in_file/C7_SNP_calls.g.vcf \
	 -V $in_file/C8_SNP_calls.g.vcf \
	 -V $in_file/C9_SNP_calls.g.vcf \
	 -V $in_file/C10_SNP_calls.g.vcf \
	 -V $in_file/C11_SNP_calls.g.vcf \
	 -V $in_file/C12_SNP_calls.g.vcf \
	 -V $in_file/C13_SNP_calls.g.vcf \
	 -V $in_file/C14_SNP_calls.g.vcf \
	 -V $in_file/C15_SNP_calls.g.vcf \
     -V $in_file/C16_SNP_calls.g.vcf \
	 -V $in_file/C17_SNP_calls.g.vcf \
 	 -V $in_file/C18_SNP_calls.g.vcf \
 	 -V $in_file/C19_SNP_calls.g.vcf \
 	 -o $output	

java -jar $gatk/GenomeAnalysisTK.jar \
     -T VariantsToAllelicPrimitives \
     -R $reference \
     -V $output \
     -o $output2	 

 