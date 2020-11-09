#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -pe smp 8
#$ -l virtual_free=0.9G

# kmer counting using kmc
Usage="kmc_kmer_counting <kmer_size> <outdir> <list of input fasta files>"

CurPath=$PWD
# ReadF=$3


Organism=$(echo $ReadF | rev | cut -d "/" -f4 | rev)
Strain=$(echo $ReadF | rev | cut -d "/" -f3 | rev)
WorkDir=$TMPDIR/kmc

mkdir -p $WorkDir
mkdir -p $WorkDir/results
mkdir -p $WorkDir/temp

cd $WorkDir
num=0
printf '' > in_names_file.txt
for Argument in "$@"; do
  num=$((num +1))
  if [ $num -eq 1 ]; then
    KmerSz=$Argument
    echo "Kmer Size: $KmerSz"
  elif [ $num -eq 2 ]; then
    OutDir=$Argument
    echo "Output directory: $OutDir"
  else
    echo "Infile $num: $Argument"
   	printf "$CurPath/$Argument\n" >> in_names_file.txt
  fi
done

echo ""
cat in_names_file.txt
echo ""

# Kmer counting using kmc
# kmc -k21 -m8 @in_names_file.txt kmc_"$Strain"_out.txt temp/
echo "Kmer counting"
kmc -k$KmerSz  -m8 -t8 -cs1000 @in_names_file.txt kmc_"$KmerSz"_out.db temp/
# kmc -k41 -m8 @in_names_file.txt kmc_"$Strain"_out.txt temp/
echo "Kmer dump"
kmc_dump kmc_"$KmerSz"_out.db kmc_"$KmerSz"_dump_out.txt

# Remove the kmers from the file for more efficient storage & loading
echo "Generating plots"
cut -f2 kmc_"$KmerSz"_dump_out.txt > "$KmerSz"_kmer_abundance.txt
ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/dna_qc
mkdir -p results
$ProgDir/R_kmer_plots.r "$KmerSz"_kmer_abundance.txt results/"$KmerSz"_all_kmer

# From the output denstiy plots and histogram determine the coverage of error kmers
# filter kmers below this threshold

# kmc_dump -ci5 kmc_"$Strain"_out.txt kmc_true_dump.txt
# cut -f2 kmc_true_dump.txt > "$Strain"_true_abundance.txt
# "$ProgDir"/R_kmer_plots.r "$Strain"_true_abundance.txt results/"$Strain"_true_kmer

mkdir -p $CurPath/$OutDir
# cp -r results/* $CurPath/$OutDir/.
# cp "$KmerSz"_kmer_abundance.txt $CurPath/$OutDir/.
rm *.db*
cp -r $WorkDir/* $CurPath/$OutDir/.

# mkdir -p $CurPath/qc_dna/kmc/$Organism/$Strain
# cp results/* $CurPath/qc_dna/kmc/$Organism/$Strain/.
# cp "$Strain"_kmer_abundance.txt $CurPath/qc_dna/kmc/$Organism/$Strain/.

rm -r $TMPDIR
