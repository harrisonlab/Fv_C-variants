#!/usr/bin/env bash
#SBATCH -J variants_to_primatives
#SBATCH --partition=himem
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
input_bam=$2
outdir=$3


WorkDir=/projects/fusarium_venenatum_miseq/${SLURM_JOB_USER}_${SLURM_JOBID}
mkdir -p $WorkDir


cp $reference $WorkDir
cp $input_bam $WorkDir
cd $WorkDir


samtools faidx WT_contigs_unmasked.fa


picard=/home/connellj/miniconda2/share/picard-2.18.29-0/picard.jar
java -jar $picard CreateSequenceDictionary \
	R=WT_contigs_unmasked.fa \
	O=WT_contigs_unmasked.dict 


gatk=/scratch/software/GenomeAnalysisTK-3.6
java -jar $gatk/GenomeAnalysisTK.jar \
     -T VariantsToAllelicPrimitives \
     -R WT_contigs_unmasked.fa \
     -V WT_contigs_unmasked_temp.vcf \
     -o corrected_snp.bam 


cp $WorkDir/corrected_snp.bam $outdir
rm -r $WorkDir