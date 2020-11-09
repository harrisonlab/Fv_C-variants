#!/bin/bash

#Assemble contigs using SPAdes

#$ -S /bin/bash
#$ -cwd
#$ -pe smp 8
#$ -l virtual_free=22G
#$ -l h=blacklace09.blacklace|blacklace01.blacklace


Usage="submit_SPAdes.sh <F1_read.fa> <R1_read.fa> <F2_read.fa> <R2_read.fa> <F3_read.fa> <R3_read.fa> <output_directory> <correct/only-assembler> [<coverage_cutoff>]"
echo "$Usage"

F1=$1
R1=$2
F2=$3
R2=$4
OutDir=$5
Correction=$6
Cutoff='auto'
if [ $7 ]; then
  Cutoff=$7
fi

CurPath=$PWD
WorkDir="$TMPDIR"

F1_Read=$(basename $F1)
R1_Read=$(basename $R1)
F2_Read=$(basename $F2)
R2_Read=$(basename $R2)

cp $CurPath/$F1 $WorkDir/$F1_Read
cp $CurPath/$R1 $WorkDir/$R1_Read
cp $CurPath/$F2 $WorkDir/$F2_Read
cp $CurPath/$R2 $WorkDir/$R2_Read

echo  "Running SPADES with the following in='$F1 $R1 $F2 $R2' $OutDir "
echo "You have set read correction to: $Correction"
echo "Coverage cutoff set to $Cutoff"
SpadesDir=/home/armita/prog/spades/SPAdes-3.6.2-Linux/bin

if [[ "$Correction" == 'correct' ]]; then
  $SpadesDir/spades.py \
      -k 21,33,55,77,99,127 \
      -m 176 \
      --phred-offset 33 \
      --careful \
      --pe1-1 $WorkDir/$F1_Read \
      --pe1-2 $WorkDir/$R1_Read \
      --pe2-1 $WorkDir/$F2_Read \
      --pe2-2 $WorkDir/$R2_Read \
      -t 8  \
      -o $WorkDir/. \
      --cov-cutoff "$Cutoff"
elif [[ "$Correction" == 'only-assembler' ]]; then
  $SpadesDir/spades.py \
      -k 21,33,55,77,99,127 \
      -m 176 \
      --phred-offset 33 \
      --careful \
      --only-assembler \
      --pe1-1 $WorkDir/$F1_Read \
      --pe1-2 $WorkDir/$R1_Read \
      --pe2-1 $WorkDir/$F2_Read \
      --pe2-2 $WorkDir/$R2_Read \
      -t 8  \
      -o $WorkDir/. \
      --cov-cutoff "$Cutoff"
else
  echo "Please set sixth option - whether you require read correction [correct / only-assembler]"
  exit
fi

echo "Filtering contigs smaller than 500bp"
mkdir -p $WorkDir/filtered_contigs
FilterDir=/home/armita/git_repos/emr_repos/tools/seq_tools/assemblers/abyss
$FilterDir/filter_abyss_contigs.py $WorkDir/scaffolds.fasta 500 > $WorkDir/filtered_contigs/contigs_min_500bp.fasta


rm $WorkDir/$F1_Read
rm $WorkDir/$R1_Read
rm $WorkDir/$F2_Read
rm $WorkDir/$R2_Read
mkdir -p $CurPath/$OutDir
cp -r $WorkDir/* $CurPath/$OutDir/.
echo "files copied"
