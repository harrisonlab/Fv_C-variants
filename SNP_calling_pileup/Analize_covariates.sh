#!/usr/bin/env bash
#SBATCH -J analize_covariates
#SBATCH --partition=himem
#SBATCH --mem-per-cpu=12G
#SBATCH --cpus-per-task=30

#GATK Analyze covariats requires the following R dependencies: ggplot2, gplots, gsalib, reshape. 
#conda install -c r r-ggplot2
#conda install -c r r-gplots
#conda install -c bioconda r-gsalib
#conda install -c r r-reshape
#MISSING PACKAGE libreadline.so.6 WONT RUN 

##########################################################################
#INPUT:
# 1st argument: Refrence fasta 
# 2nd argument: sample name (prefix) to be used to identify it in the future
# 3rd argument: input recal table generated from primary base recalibation
# 4th argument: input recal table generated from secondary base recalibration 
#OUTPUT:
# covariate plots  


reference=$1
strain=$2
primary_recal_table=$3
secondary_recal_table=$4
outdir=$5


WorkDir=/projects/fusarium_venenatum_miseq/${SLURM_JOB_USER}_${SLURM_JOBID}
mkdir -p $WorkDir


cp $reference $WorkDir
cp $primary_recal_table $WorkDir   
cp $secondary_recal_table $WorkDir
cd $WorkDir


samtools faidx WT_contigs_unmasked.fa


picard=/home/connellj/miniconda2/share/picard-2.18.29-0/picard.jar
java -jar $picard CreateSequenceDictionary \
	R=WT_contigs_unmasked.fa \
	O=WT_contigs_unmasked.dict 

gatk=/home/connellj/gatk4/gatk-4.1.9.0/gatk
     $gatk AnalyzeCovariates \
     -before "$strain"_recal.table \
     -after "$strain"_secondary_recal.table \
     -plots "$strain"_recal_plots.pdf 

#gatk=/scratch/software/GenomeAnalysisTK-3.6
#java -jar $gatk/GenomeAnalysisTK.jar \
#     -T AnalyzeCovariates \
#     -R WT_contigs_unmasked.fa \
#     -before "$strain"_recal.table \
#     -after "$strain"_secondary_recal.table \
#     -plots "$strain"_recal_plots.pdf



cp $WorkDir/"$strain"_recal_plots.pdf $outdir
#rm -r $WorkDir