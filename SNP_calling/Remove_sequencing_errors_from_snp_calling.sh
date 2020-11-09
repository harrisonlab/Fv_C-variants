Remove_sequencing_errors_from_snp_calling

bash
Vcf=$(ls analysis/popgen/SNP_calling/414_contigs_softmasked_repeatmasker_TPSI_appended_filtered.vcf)
OutDir=$(dirname $Vcf)
Errors=$OutDir/414_error_SNPs.tsv
FilteredVcf=$OutDir/414_contigs_softmasked_repeatmasker_TPSI_appended_filtered_no_errors.vcf
ProgDir=/home/armita/git_repos/emr_repos/scripts/phytophthora/Pcac_popgen
$ProgDir/flag_error_SNPs.py --ploidy 'diploid' --inp_vcf $Vcf --ref_isolate 414 --errors $Errors --filtered $FilteredVcf
echo "The number of probable errors from homozygous SNPs being called from reference illumina reads vs the reference assembly is:"
cat $Errors
# cat $Errors | wc -l
echo "These have been removed from the vcf file"



Vcf=$(ls /data/scratch/connellj/Fusarium_venenatum/MINion_SNP_Calling/C*/_unmasked_filtered_C*.vcf)
OutDir=$(/data/scratch/connellj/Fusarium_venenatum/MINion_SNP_Calling/C*/no_errors $Vcf)
Errors=$OutDir/414_error_SNPs.tsv
FilteredVcf=/data/scratch/connellj/Fusarium_venenatum/F.venenatum/WT/minion_reference_check/reference_check/snp_calling_out/Error_snp/Minion_genome_SNPs.vcf
ProgDir=/home/armita/git_repos/emr_repos/scripts/phytophthora/Pcac_popgen
$ProgDir/flag_error_SNPs.py --ploidy 'haploid' --inp_vcf $Vcf --ref_isolate 414 --errors $Errors --filtered $FilteredVcf
echo "The number of probable errors from homozygous SNPs being called from reference illumina reads vs the reference assembly is:"
cat $Errors
# cat $Errors | wc -l
echo "These have been removed from the vcf file"



