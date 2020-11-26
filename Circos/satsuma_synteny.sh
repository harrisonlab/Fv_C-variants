#!/usr/bin/env bash
#SBATCH -J satsumasynteny
#SBATCH --partition=short
#SBATCH --mem-per-cpu=6G
#SBATCH --cpus-per-task=10

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
 	-t $Genome1 \
 	-q $Genome2 \
 	-o synteny_output.txt


cp $WorkDir/synteny_output.txt $outdir
rm -r $WorkDir