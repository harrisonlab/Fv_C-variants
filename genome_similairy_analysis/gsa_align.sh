#!/usr/bin/env bash
#SBATCH -J genome_alignment 
#SBATCH --partition=himem
#SBATCH --mem-per-cpu=12G
#SBATCH --cpus-per-task=30


##########################################################################
#INPUT:
# 1st argument: Genome1
# 2nd argument: Genome2    
#OUTPUT:
#check slurm out file for quick stats on variants detected and genome similiary ANI%, outfiles are variants and corresponding data 


Genome1=$1
Genome2=$2
prefix=$3
Outdir=$4


WorkDir=/projects/fusarium_venenatum_miseq/${SLURM_JOB_USER}_${SLURM_JOBID}
mkdir -p $WorkDir


cp $Genome1 $WorkDir
cp $Genome2 $WorkDir
cd $WorkDir 



GSA=/home/connellj/miniconda2/pkgs/gsalign-1.0.22-hdb83ec4_0/bin/GSAlign
$GSA \
    -r $Genome1 \
    -q $Genome2 \
    -o $prefix


cp $WorkDir/$prefix.* $Outdir
rm -r $WorkDir 

