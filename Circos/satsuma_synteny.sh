#!/usr/bin/env bash
#SBATCH -J satsumasynteny
#SBATCH --partition=himem
#SBATCH --mem-per-cpu=12G
#SBATCH --cpus-per-task=30

##########################################################################
#INPUT:
# 1st argument: Genome1
# 2nd argument: Genome2
#OUTPUT:
# File is synteny alignment between two input genomes

Genome1=$1
Genome2=$2
outdir$3

WorkDir=/projects/temp/${SLURM_JOB_USER}_${SLURM_JOBID}
mkdir -p $WorkDir

cp $Genome1 $WorkDir
cp $Genome2 $WorkDir
cd $WorkDir


SatsumaSynteny=/home/connellj/satsuma-code/SatsumaSynteny
$SatsumaSynteny \
 	-t WT_contigs_unmasked.fa \
 	-q WT_albacore_v2_contigs_unmasked.fa \
 	-o synteny_output


cp $WorkDir/synteny_output $outdir
rm -r $WorkDir