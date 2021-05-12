#Remove errors calls from VCF file based on SNP calls in the WT genome 
#To generate error SNPs call SNPs in the WT genome using WT reads


VCF_file=/home/connellj/error_detection_test/WT_contigs_unmaskedSNPs_filtered.vcf
Error_call_file=/home/connellj/error_detection_test/Minion_genome_SNPs.vcf
OutDir=/home/connellj/error_detection_test/no_error.vcf  
ProgDir=/home/connellj/git_repos/emr_repos/Fv_C-variants/SNP_calling_pileup
$ProgDir/python_remove_sequencing_errors.py --VCF_file $VCF_file --error_SNPs $Error_call_file --outfile $OutDir 
