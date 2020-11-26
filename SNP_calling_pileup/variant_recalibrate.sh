#!/usr/bin/env bash
#SBATCH -J variantrecalibrate
#SBATCH --partition=himem
#SBATCH --mem-per-cpu=12G
#SBATCH --cpus-per-task=30


##########################################################################
#PreRequsites 
#wget -c ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/hapmap_3.3.b37.vcf.gz
#wget -c ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/1000G_omni2.5.b37.vcf.gz
#wget -c ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/1000G_phase3_v4_20130502.sites.vcf.gz
#wget -c ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/dbsnp_138.b37.vcf.gz


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
     -input WT_contigs_unmaskedSNPs_filtered_annotated.vcf \
     -resource:hapmap,known=false,training=true,truth=true,prior=15.0 hapmap_3.3.b37.sites.vcf \
     -resource:omni,known=false,training=true,truth=false,prior=12.0 omni2.5.b37.sites.vcf \
     -resource:1000G,known=false,training=true,truth=false,prior=10.0 1000G.b37.sites.vcf \
     -resource:dbsnp,known=true,training=false,truth=false,prior=2.0 dbsnp_137.b37.vcf \
     -an QD -an MQ -an MQRankSum -an ReadPosRankSum -an FS -an SOR \
     -mode SNP \
     -recalFile raw.SNPs.recal \
     -tranchesFile output.tranches \
     -rscriptFile output.plots.R


cp $WorkDir/raw.SNPs.recal $outdir
cp $WorkDir/output.tranches $outdir
cp $WorkDir/output.plots.R $outdir
#cp $WorkDir/INDEL.recal $outdir
#cp $WorkDir/INDEL.tranches $outdir
#cp $WorkDir/INDEL.plots $outdir
rm -r $WorkDir