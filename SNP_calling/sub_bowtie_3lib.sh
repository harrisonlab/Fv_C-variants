#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -pe smp 8
#$ -l virtual_free=1G
#$ -l h=blacklace03.blacklace|blacklace04.blacklace|blacklace05.blacklace|blacklace06.blacklace|blacklace07.blacklace|blacklace08.blacklace|blacklace09.blacklace|blacklace10.blacklace

# Align raw reads to an assembly.

# ---------------
# Step 1
# Collect inputs
# ---------------

Assembly=$(basename $1)
Read_F1=$(basename $2)
Read_R1=$(basename $3)
Read_F2=$(basename $4)
Read_R2=$(basename $5)
Read_F3=$(basename $6)
Read_R3=$(basename $7)
OutDir=$8

if [ $8 ]; then
  AddOptions="--rg-id $8"
else
  AddOptions=""
fi

CurDir=$PWD
echo  "Running Bowtie with the following inputs:"
echo "Assembly - $Assembly"
echo "Forward trimmed reads 1 - $Read_F1"
echo "Reverse trimmed reads 1 - $Read_R1"
echo "Forward trimmed reads 2 - $Read_F2"
echo "Reverse trimmed reads 2 - $Read_R2"
echo "Forward trimmed reads 3 - $Read_F3"
echo "Reverse trimmed reads 3 - $Read_R3"
echo "OutDir - $OutDir"

# ---------------
# Step 2
# Copy data
# ---------------

WorkDir=$TMPDIR/bowtie
mkdir -p $WorkDir
cd $WorkDir
cp $CurDir/$1 $Assembly
cp $CurDir/$2 $Read_F1
cp $CurDir/$3 $Read_R1
cp $CurDir/$4 $Read_F2
cp $CurDir/$5 $Read_R2
cp $CurDir/$6 $Read_F3
cp $CurDir/$7 $Read_R3

# ---------------
# Step 3
# Align seq reads
# ---------------
# Prepare the assembly for alignment
# Align reads against the assembly
# Convert the SAM file to BAM in preparation for sorting.
# Sort the BAM file, in preparation for SNP calling:
# Index the bam file

bowtie2-build $Assembly $Assembly.indexed
bowtie2 -p 8 -X 1200 --no-mixed $AddOptions -x $Assembly.indexed -1 $Read_F1,$Read_F2,$Read_F3 -2 $Read_R1,$Read_R2,$Read_R3 -S "$Assembly"_aligned.sam 2>&1 | tee bowtie_log.txt
samtools view --threads 8 -bS "$Assembly"_aligned.sam -o "$Assembly"_aligned.bam
samtools sort --threads 8 -o "$Assembly"_aligned_sorted.bam "$Assembly"_aligned.bam
samtools index -@ 8 "$Assembly"_aligned_sorted.bam "$Assembly"_aligned_sorted.bam.index

# ---------------
# Step 4
# Determine RPKM
# ---------------
# Determine the number of reads aligning per kilobase,
# normalised by the number of million reads aligned to
# the genome.

samtools view  --threads 8 -f 2 -F 104 "$Assembly"_aligned_sorted.bam | cut -f3 | uniq -c > "$Assembly"_fpkm.txt

# ---------------
# Step 5
# Cleanup
# ---------------
# Delete uneccessary files
# and copy to $OutDir

rm "$Assembly"_aligned.bam
rm *.sam
rm $Assembly
rm $Read_F1
rm $Read_R1
rm $Read_F2
rm $Read_R2
rm $Read_F3
rm $Read_R3
mkdir -p $CurDir/$OutDir
cp -r $WorkDir/* $CurDir/$OutDir/.
