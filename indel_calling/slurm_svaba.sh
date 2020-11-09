#!/bin/bash
#SBATCH --partition=unlimited
#SBATCH --time=24:00:00
#SBATCH --mem=100gb
#SBATCH --cpus-per-task=40




# # Prefix="Fven_svaba"
# Prefix="Fven_svaba"
# Assembly=/home/groups/harrisonlab/project_files/fusarium_venenatum/repeat_masked/F.venenatum/WT/illumina_assembly_ncbi/WT_contigs_unmasked.fa
# F_reads=/home/groups/harrisonlab/project_files/Fv_C-variants/analysis/SV_calling/tmp_concat_dir/*_F_reads.fq.gz
# R_reads=/home/groups/harrisonlab/project_files/Fv_C-variants/analysis/SV_calling/tmp_concat_dir/*_R_reads.fq.gz
# # ControlBAM=PcacP414.bam
# OutDir=/home/groups/harrisonlab/project_files/Fv_C-variants/analysis/SV_calling

Usage="sub_svaba <prefix> <reference_assembly.fa> <directory_containing_BAM_Files> <output_directory>"
echo "$Usage"

Prefix=$1
Assembly=$2
BamDir=$3
OutDir=$4

CWD=$PWD

WorkDir="$TMPDIR"
# WorkDir=/tmp/svaba
mkdir -p $WorkDir

cp -r $Assembly $WorkDir/.
cp $BamDir/*.bam $WorkDir/.
cp $BamDir/*.bam.bai $WorkDir/.
# Cb=$(basename "$ControlBAM")
As=$(basename "$Assembly")

cd $WorkDir
# Output=${Fr%.*}.bam

# Align the data
bwa index $As
# bwa mem -t 16 $As $Fr $Rr | samtools view -S -b - > "$Prefix".bam

# samtools sort -@ 16 -o "$Prefix".sorted.bam "$Prefix".bam
# samtools index "$Prefix".sorted.bam

# samtools sort -@ 16 -o control.sorted.bam $Cb
# samtools index control.sorted.bam

# Control=normal.bam
# TargetRegion=22
# svaba -t "$Prefix".bam -n $Control -k $TargetRegion -G ref.fa -a test_id -p -4

# svaba run -t "$Prefix".bam -G $As -a "$Prefix"_sv -p 16
# svaba run -t "$Prefix".sorted.bam -n control.sorted.bam -G $As -a "$Prefix"_sv -p 24
BamFiles=$(ls *.bam | sed -E "s/$/ -t /g" | tr -d '\n' | sed -E "s/ -t $/ /g")
svaba run -t $BamFiles -G $As -a "$Prefix"_sv -p 8

rm $As*
rm $BamFiles
rm *.bam.bai
mkdir -p $CWD
cp -r $WorkDir/* $CWD/$OutDir/.
# wget "https://data.broadinstitute.org/snowman/dbsnp_indel.vcf" ## get a DBSNP known indel file
# DBSNP=dbsnp_indel.vcf
# CORES=8 ## set any number of cores
# REF=/seq/references/Homo_sapiens_assembly19/v1/Homo_sapiens_assembly19.fasta
# ## -a is any string you like, which gives the run a unique ID
# svaba run -t $TUM_BAM -n $NORM_BAM -p $CORES -D $DBSNP -a somatic_run -G $REF

echo COMPLETE