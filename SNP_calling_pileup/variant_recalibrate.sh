#!/usr/bin/env bash
#SBATCH -J variant_recalibrate
#SBATCH --partition=long 
#SBATCH --mem-per-cpu=12G
#SBATCH --cpus-per-task=30


##########################################################################
#INPUT:
# 1st argument: Refrence fasta 
# 2nd argument: input_vcf with SNP and INDEL calls 
#OUTPUT:
# Recalibrated bam based on realibration table generated from previous step


reference=$1
input_vcf=$2
outdir=$3


WorkDir=/projects/fusarium_venenatum_miseq/${SLURM_JOB_USER}_${SLURM_JOBID}
mkdir -p $WorkDir


cp $reference $WorkDir
cp $input_vcf $WorkDir
cd $WorkDir


samtools faidx WT_contigs_unmasked.fa


picard=/home/connellj/miniconda2/share/picard-2.18.29-0/picard.jar
java -jar $picard CreateSequenceDictionary \
	R=WT_contigs_unmasked.fa \
	O=WT_contigs_unmasked.dict 


gatk=/scratch/software/GenomeAnalysisTK-3.6
java -jar $gatk/GenomeAnalysisTK.jar \
     -T VariantRecalibrator \
     -R WT_contigs_unmasked.fa \
     -input SNPFILEHERE \
     -resource hapmap,known=false,training=true,truth=true,prior=15.0:hapmap_3.3.b37.sites.vcf \
     -resource omni,known=false,training=true,truth=false,prior=12.0:omni2.5.b37.sites.vcf \
     -resource 1000G,known=false,training=true,truth=false,prior=10.0:1000G.b37.sites.vcf \
     -resource dbsnp,known=true,training=false,truth=false,prior=2.0:dbsnp_137.b37.vcf \
     -an DP -an QD -an FS -an MQRankSum {...} \
     -mode SNP \
     -O output.recal \
     -tranches-file output.tranches \
     -rscript-file output.plots.R



gatk=/scratch/software/GenomeAnalysisTK-3.6
java -jar $gatk/GenomeAnalysisTK.jar \
     -T VariantRecalibrator \
     -R WT_contigs_unmasked.fa \
     -input INDELFILEHERE \
     -resource hapmap,known=false,training=true,truth=true,prior=15.0:hapmap_3.3.b37.sites.vcf \
     -resource omni,known=false,training=true,truth=false,prior=12.0:omni2.5.b37.sites.vcf \
     -resource 1000G,known=false,training=true,truth=false,prior=10.0:1000G.b37.sites.vcf \
     -resource dbsnp,known=true,training=false,truth=false,prior=2.0:dbsnp_137.b37.vcf \
     -an DP -an QD -an FS -an MQRankSum {...} \
     -mode INDEL \
     -O output.recal \
     -tranches-file output.tranches \
     -rscript-file output.plots.R

cp $WorkDir/"$strain"_recal.bam $outdir
rm -r $WorkDir