#Script to create circos plots. 


#1.) Create a .txt file with contig lengths of the genomes to be aligned. 
#.txt file for genome 1 


Genome1=$(ls /home/connellj/local_illumina_Fv_genome/WT_contigs_unmasked.fa)
OutDir=/home/connellj/Circos 
mkdir -p $OutDir
ProgDir=/home/connellj/git_repos/emr_repos/Fv_C-variants/Circos
$ProgDir/fasta2circos.py --genome $Genome1 --contig_prefix "A3_5_" > $OutDir/Fv_Illumina_genome.txt


#.txt file for genome 2 


Genome2=$(ls /home/connellj/local_MINion_Fv_genome/WT_albacore_v2_contigs_unmasked.fa)
OutDir=/home/connellj/Circos 
ProgDir=/home/connellj/git_repos/emr_repos/Fv_C-variants/Circos
$ProgDir/fasta2circos.py --genome $Fv_MINion_genome --contig_prefix "A3_5_MIN" > $OutDir/Fv_MINion_genome.txt


#concatenate files


cat $OutDir/Fv_Illumina_genome.txt > $OutDir/Fv_Fv_genome.txt
tac $OutDir/Fv_MINion_genome.txt >> $OutDir/Fv_Fv_genome.txt


 Contigs smaller than 10Kb can be removed if required. 
  cat $OutDir/Fv_Fv_genome.txt \
  | grep -v -e "A3_5_contig_87" \
  | grep -v -e "A3_5_contig_88" \
  | grep -v -e "A3_5_contig_89" \
  | grep -v -e "A3_5_contig_90" \
  | grep -v -e "A3_5_contig_91" \
  | grep -v -e "A3_5_contig_92" \
  | grep -v -e "A3_5_contig_93" \
  | grep -v -e "A3_5_contig_94" \
  | grep -v -e "A3_5_contig_95" \
  | grep -v -e "A3_5_contig_96" \
  | grep -v -e "A3_5_contig_97" \
  | grep -v -e "A3_5_contig_98" \
  | grep -v -e "A3_5_contig_99" \
  | grep -v -e "A3_5_contig_100" \
  | grep -v -e "A3_5_contig_101" \
  | grep -v -e "A3_5_contig_102" \
  | grep -v -e "A3_5_contig_103" \
  | grep -v -e "A3_5_contig_104" \
  | grep -v -e "A3_5_contig_105" \
  | grep -v -e "A3_5_MINcontig_5" \
  > $OutDir/Fv_Fv_genome_edited.txt


#2.) Create synteny links between genomes. 


Genome1=../../projects/fusarium_venenatum_miseq/genomes/WT/WT_contigs_unmasked.fa
Genome2=../../projects/oldhome/connellj/local_MINion_Fv_genome/WT_albacore_v2_contigs_unmasked.fa
OutDir=/home/connellj/Circos/satsuma_alignment 
mkdir -p $OutDir
ProgDir=/home/connellj/git_repos/emr_repos/Fv_C-variants/Circos
sbatch $ProgDir/satsuma_synteny.sh $Genome1 $Genome2 $OutDir 













#3.) Run circos  

  ## Running CIRCOS --CONFIGURATION FILE LOCATION-- 
  ## /home/connellj/software/circos
OutDir=/home/connellj/fusarium_venenatum/circos_out/Fv_vs_Fv
Conf=$(ls /home/connellj/git_repos/scripts/Fv_C-variants/Circos/Fv_Fv_circos.conf.sh)
circos -conf $Conf -outputdir $OutDir
mv $OutDir/circos.png $OutDir/Fv_Fv_circos.png
mv $OutDir/circos.svg $OutDir/Fv_Fv_circos.svg

