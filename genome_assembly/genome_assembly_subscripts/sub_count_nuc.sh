#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -pe smp 1
#$ -l virtual_free=1G
#$ -l h=blacklace02.blacklace|blacklace03.blacklace|blacklace04.blacklace|blacklace05.blacklace|blacklace06.blacklace|blacklace07.blacklace|blacklace08.blacklace|blacklace09.blacklace|blacklace10.blacklace


# Script to count nucleotides in a fastq file
# and estimate genome coverage

#######  Step 1	 ########
# Initialise values	#
#########################


CurPath=$PWD
WorkDir=$TMPDIR/count_nuc

GenomeSize=$1
InFile=$CurPath/$2
OutDir=$3


FileName=$(basename $InFile)

OutName=$(echo "$FileName" | sed "s/.fastq.*//g" | sed "s/.fq.*//g")


#######  Step 2	 ########
# 	unzip reads			#
#########################

mkdir -p "$WorkDir"
cd "$WorkDir"

cp $InFile seqreads.fastq.gz
cat seqreads.fastq.gz | gunzip -fc > "$OutName".fastq

#######  Step 3	 ########
# 	Quality trim		#
#########################

count_nucl.pl -i "$OutName".fastq -g $GenomeSize > "$OutName"_cov.txt


#######  Step 8  ########
#       Cleanup         #
#########################

mkdir -p $CurPath/$OutDir
cp "$OutName"_cov.txt $CurPath/$OutDir/.
