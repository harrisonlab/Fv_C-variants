#!/usr/bin/env bash
#SBATCH -J minimap
#SBATCH --partition=short
#SBATCH --mem-per-cpu=12G
#SBATCH --cpus-per-task=30




##########################################################################
#INPUT:
# 1st argument: Genome1
# 2nd argument: Genome2
#OUTPUT:
# Commands to make dotplot in R 

Genome1=$1
Genome2=$2
outdir=$3


CurDir=$PWD

WorkDir=$PWD/${SLURM_JOB_USER}_${SLURM_JOBID}
mkdir -p $WorkDir

cp $Genome1 $WorkDir
cp $Genome2 $WorkDir
cd $WorkDir

query=$Genome1
target=$Genome2

minimap2=/home/connellj/miniconda2/bin/minimap2
query=$Genome1
target=$Genome2


$minimap2 -x asm5 -t 36 $target $query > minimap.paf

cp $WorkDir/minimap.paf $outdir
rm -r $WorkDir