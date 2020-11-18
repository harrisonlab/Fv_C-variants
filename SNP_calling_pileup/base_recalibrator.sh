#!/usr/bin/env bash
#SBATCH -J base_recalibrator
#SBATCH --partition=short
#SBATCH --mem-per-cpu=12G
#SBATCH --cpus-per-task=30


##########################################################################
#INPUT:
# 1st argument: Refrence fasta 
# 2nd argument: sample name (prefix) to be used to identify it in the future
# 3rd argument: input BAM file from pre_snp_calling file with your mappings with duplicates marked no multimapping sorted  
#OUTPUT:
# rearanged bam files prefixed with strain ID
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
samtools index *_realigned.bam


picard=/home/connellj/miniconda2/share/picard-2.18.29-0/picard.jar
java -jar $picard CreateSequenceDictionary \
	R=WT_contigs_unmasked.fa \
	O=WT_contigs_unmasked.dict 


gatk=/scratch/software/GenomeAnalysisTK-3.6
java -jar $gatk/GenomeAnalysisTK.jar \
     -T BaseRecalibrator \
     -R WT_contigs_unmasked.fa \
     -I *_realigned.bam \
     -o "$strain"_recal.table 


cp $WorkDir/"$strain"_recal.table $outdir
rm -r $WorkDir