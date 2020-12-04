#!/usr/bin/env bash
#SBATCH -J busco
#SBATCH --partition=long
#SBATCH --mem-per-cpu=6G
#SBATCH --cpus-per-task=20


##########################################################################
#INPUT:
# 1st argument: Genome assembly
# 2nd argument: Database option  
#OUTPUT:
# Busco result


# NOTE to easily prepare a figure with a comparison of complete, fragmented, duplicated
# and missing BUSCO genes in each genome, use the script BUSCO_plot.py in the BUSCO folder.
# Instructions in the user guide BUSCO_v2.0_userguide.pdf
###



Assembly=$1
DatabaseOpt=$2
OutDir=$3


CurDir=$PWD
WorkDir=$PWD/${SLURM_JOB_USER}_${SLURM_JOBID}


mkdir -p $WorkDir
cp $Assembly $WorkDir
cp -r $DatabaseOpt	$WorkDir	
cd $WorkDir


busco=/home/connellj/miniconda2/bin/busco
$busco \
 -i $Assembly \
 -l $DatabaseOpt \
 -m genome \
 -c 8 \
 --augustus_species fusarium_venenatum \
 -o Busco_result 


cp $WorkDir/Busco_result $OutDir
rm -r $WorkDir
