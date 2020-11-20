#!/usr/bin/env bash
#SBATCH -J Genome_coverage
#SBATCH --partition=short
#SBATCH --mem-per-cpu=4G
#SBATCH --cpus-per-task=2



##########################################################################
#INPUT:
# 1st argument: Forward read
# 2nd argument: Reverse read
# 3rd argument: Genome size 
#OUTPUT:
# x Genome coverage 


Read_F=$(basename $1)
Read_R=$(basename $2)
Genome_size=$3
OutDir=$4


CurDir=$PWD


WorkDir=$PWD/${SLURM_JOB_USER}_${SLURM_JOBID}
mkdir -p $WorkDir
cd $WorkDir

cp $CurDir/$1 $WorkDir
cp $CurDir/$2 $WorkDir

gunzip $Read_F
gunzip $Read_R


Sub1=*R1*.fq
Sub2=*R2*.fq

/data/scratch/gomeza/prog/count_nucl.pl -i $Sub1 -i $Sub2 -g $3 > estimated_coverage.log

cp -r $WorkDir/estimated_coverage.log $CurDir/$OutDir/.
rm -r $WorkDir

