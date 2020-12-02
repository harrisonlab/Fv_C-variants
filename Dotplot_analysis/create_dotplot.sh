#!/usr/bin/env bash
#SBATCH -J minimap
#SBATCH --partition=short
#SBATCH --mem-per-cpu=12G
#SBATCH --cpus-per-task=30




##########################################################################
#INPUT:
# 1st argument: paf file 
#OUTPUT:
# dorplot

paf=$1
outdir=$2


CurDir=$PWD

WorkDir=$PWD/${SLURM_JOB_USER}_${SLURM_JOBID}
mkdir -p $WorkDir

cp $paf $WorkDir
cd $WorkDir


dotplot=/home/connellj/git_repos/emr_repos/Fv_C-variants/Dotplot_analysis/
$dotplot/pafCoordsDotPlotly.R \
	-i $paf \
	-o paf.plot \
	-m 2000 \
	-q 50000 \
	-k 10 \
	-s -t -i -p 12




cp $WorkDir/paf.plot $outdir
rm -r $WorkDir