#!/usr/bin/env bash
#SBATCH -J base_recalibrator
#SBATCH --partition=short
#SBATCH --mem-per-cpu=12G
#SBATCH --cpus-per-task=30


##########################################################################
#INPUT:
# 1st argument: Refrence fasta 
# 2nd argument: SNP call vcf for variant masking 
# 3rd argument: indell call vcf for variant masking 
# 4th argument: sv call vcf for masking 
# 5nd argument: sample name (prefix) to be used to identify it in the future
# 6rd argument: input BAM file from pre_snp_calling file with your mappings with duplicates marked no multimapping sorted  
#OUTPUT:
# rearanged bam files prefixed with strain ID
reference=$1
strain=$2
input_bam=$3
recal_table=$4
outdir=$5


WorkDir=/projects/fusarium_venenatum_miseq/${SLURM_JOB_USER}_${SLURM_JOBID}
mkdir -p $WorkDir


cp $reference $WorkDir
cp $input_bam $WorkDir
cp $recal_table $WorkDir
cd $WorkDir


samtools faidx WT_contigs_unmasked.fa
samtools index *_realigned.bam


picard=/home/connellj/miniconda2/share/picard-2.18.29-0/picard.jar
java -jar $picard CreateSequenceDictionary \
	R=WT_contigs_unmasked.fa \
	O=WT_contigs_unmasked.dict 


gatk=/scratch/software/GenomeAnalysisTK-3.6
java -jar $gatk/GenomeAnalysisTK.jar \
     -T PrintReads \
     -R WT_contigs_unmasked.fa \
     -I "$strain"_realigned.bam \
     -BQSR "$strain"_recal.table
     -o "$strain"_recal.bam 


cp $WorkDir/"$strain"_recal.bam $outdir
rm -r $WorkDir