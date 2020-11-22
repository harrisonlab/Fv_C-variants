#!/usr/bin/env bash
#SBATCH -J haplotype_caller
#SBATCH --partition=long 
#SBATCH --mem-per-cpu=12G
#SBATCH --cpus-per-task=30


##########################################################################
#INPUT:
# 1st argument: Refrence fasta 
# 2nd argument: sample name (prefix) to be used to identify it in the future
# 3nd argument: Input BAM 
#OUTPUT:
# VCF out


reference=$1
strain=$2
input_bam=$3
outdir=$4


WorkDir=/projects/fusarium_venenatum_miseq/${SLURM_JOB_USER}_${SLURM_JOBID}
mkdir -p $WorkDir


cp $reference $WorkDir
cp $input_bam $WorkDir
cd $WorkDir


samtools faidx WT_contigs_unmasked.fa
samtools index "$strain"_recal.bam


picard=/home/connellj/miniconda2/share/picard-2.18.29-0/picard.jar
java -jar $picard CreateSequenceDictionary \
	R=WT_contigs_unmasked.fa \
	O=WT_contigs_unmasked.dict 


gatk=/scratch/software/GenomeAnalysisTK-3.6
java -jar $gatk/GenomeAnalysisTK.jar \
     -T HaplotypeCaller \
     -R WT_contigs_unmasked.fa \
     -I "$strain"_recal.bam \
     -o "$strain"_SNP_calls.g.vcf \
     -ERC GVCF \
     -variant_index_type LINEAR \
     -variant_index_parameter 128000

 

cp $WorkDir/"$strain"_SNP_calls.g.vcf $outdir
rm -r $WorkDir