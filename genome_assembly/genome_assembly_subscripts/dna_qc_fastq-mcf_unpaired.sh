#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -pe smp 1
#$ -l virtual_free=1G


# Script to prepare dna for downstream applications.
# Will filter poor quality reads, perform trimming and
# remove illumina adapters.
# To be run from the project directory.
# This script is designed to work on a single unpaired fastq or fastq.gz file
# Usage:
# dna_qc_fastq-mcf_unpaired.sh <UNPAIRED.fastq.gz> <IlluminaAdapters.fa> [DNA/RNA]

#######  Step 1	 ########
# Initialise values	#
#########################


CurPath=$PWD
WorkDir=$TMPDIR/rna_qc

InFile=$CurPath/$1
IlluminaAdapters=$2
SeqType=$3

LibType=$(echo $InFile | rev | cut -d "/" -f5 | rev)
Organism=$(echo $InFile | rev | cut -d "/" -f4 | rev)
Strain=$(echo $InFile | rev | cut -d "/" -f3 | rev)

FileName=$(echo $InFile | rev | cut -d "/" -f1 | rev | sed 's/.gz//')

OutName=$(echo "$FileName" | sed 's/.fq/_trim.fq/g' | sed 's/.fastq/_trim.fq/g')


echo "your compressed forward read is: $InFile"
	echo ""
echo "your forward read is: $FileName"
	echo ""
echo "illumina adapters are stored in the file: $IlluminaAdapters"
	echo ""
echo "you are providing Sequence data as (DNA/RNA): $SeqType"


#######  Step 2	 ########
# 	unzip reads			#
#########################

mkdir -p "$WorkDir"/unpaired
cd "$WorkDir"

cat "$InFile" | gunzip -fc > "$FileName"

#######  Step 4	 ########
# 	Quality trim		#
#########################

fastq-mcf $IlluminaAdapters $FileName -o unpaired/"$OutName" -C 1000000 -u -k 20 -t 0.01 -q 30 -p 5

SeqType=$(echo "$SeqType" | tr "[:upper:]" "[:lower:]")
OutDir="$CurPath"/qc_"$SeqType"/"$LibType"/"$Organism"/"$Strain"
gzip unpaired/"$OutName"
mkdir -p "$OutDir"/unpaired
cp -r unpaired/"$OutName".gz "$OutDir"/unpaired/"$OutName".gz


#######  Step 8  ########
#       Cleanup         #
#########################

rm -r $WorkDir/
