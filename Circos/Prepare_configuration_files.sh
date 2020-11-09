##Circos plot Fv Illumina genome vs Fv MINion genome
------------------------------------------------------

##1 Prepare genome and .conf files 

OutDir=/home/connellj/emr_ven_vs_kim_ven
mkdir -p $OutDir

Fv_Illumina_genome=$(ls /home/connellj/local_illumina_Fv_genome/WT_contigs_unmasked.fa)
ProgDir=~/git_repos/scripts/Fv_C-variants/Circos
$ProgDir/fasta2circos.py --genome $Fv_Illumina_genome --contig_prefix "A3_5_" > $OutDir/Fv_Illumina_genome.txt

Fv_kim_genome=$(ls /home/connellj/Kim_venenatum_genome/Fusarium_venenatum_gca_900007375.ASM90000737v1.dna_rm.toplevel.fa)
ProgDir=~/git_repos/scripts/Fv_C-variants/Circos
$ProgDir/fasta2circos.py --genome $Fv_kim_genome --contig_prefix "A3_5_kim" > $OutDir/Fv_kim_genome.txt

  cat $OutDir/Fv_Illumina_genome.txt > $OutDir/Fv_Fv_genome.txt
  tac $OutDir/Fv_kim_genome.txt >> $OutDir/Fv_Fv_genome.txt

  # Contigs smaller than 10Kb were removed
 # cat $OutDir/Fv_Fg_genome.txt | grep -v -e 'PH1_Mt' -e 'PH1_HG970330' \
 # | grep -v -e "A3_5_contig_87" \
 # | grep -v -e "A3_5_contig_88" \
 # | grep -v -e "A3_5_contig_89" \
 # | grep -v -e "A3_5_contig_90" \
 # | grep -v -e "A3_5_contig_91" \
 # | grep -v -e "A3_5_contig_92" \
 # | grep -v -e "A3_5_contig_93" \
 # | grep -v -e "A3_5_contig_94" \
 # | grep -v -e "A3_5_contig_95" \
 # | grep -v -e "A3_5_contig_96" \
 # | grep -v -e "A3_5_contig_97" \
 # | grep -v -e "A3_5_contig_98" \
 # | grep -v -e "A3_5_contig_99" \
 # | grep -v -e "A3_5_contig_100" \
 # | grep -v -e "A3_5_contig_101" \
 # | grep -v -e "A3_5_contig_102" \
 # | grep -v -e "A3_5_contig_103" \
 # | grep -v -e "A3_5_contig_104" \
 # | grep -v -e "A3_5_contig_105" \
 # > $OutDir/Fv_Fg_genome_edited.txt

 ##2 Synteny link files are created 

  #Orthology=$(ls analysis/orthology/orthomcl/Fv_vs_Fg/Fv_vs_Fg_orthogroups.txt)
  #Gff1=$(ls gene_pred/final/F.venenatum/WT/final/final_genes_appended_renamed.gff3)
  #Gff2=$(ls gene_pred/final/F.venenatum/WT/final/final_genes_appended_renamed.gff3)
  #cat $Gff2 | grep -v '#' > $OutDir/tmp.gff3
  #ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/circos
  #$ProgDir/orthology2circos_ribbons.py --orthology $Orthology --name1 A3_5 --gff1 $Gff1 --name2 PH1 --gff2 $OutDir/tmp.gff3 \
  # | sort -k4,5 -V \
  # > $OutDir/Fv_Fg_links.txt
  # Links to Fg LS contigs 3, 6, 14 and 15 were coloured black
  # cat $OutDir/Fv_Fg_links.txt \
  #   | sed '/4287_CM000591.1/ s/$/\tcolor=black/' \
  #   | sed '/4287_CM000594.1/ s/$/\tcolor=black/' \
  #   | sed '/4287_CM000602.2/ s/$/\tcolor=black/' \
  #   | sed '/4287_CM000603.1/ s/$/\tcolor=black/' \
  #   > $OutDir/Fv_Fg_links_edited.txt
 # cat $OutDir/Fv_Fg_links.txt > $OutDir/Fv_Fg_links_edited.txt


  ## Running CIRCOS --CONFIGURATION FILE LOCATION-- 
  ## /home/connellj/software/circos
OutDir=/home/connellj/emr_ven_vs_kim_ven
Conf=$(ls /home/connellj/git_repos/scripts/Fv_C-variants/Circos/Fv_Fv_kim_circos.conf.sh)
circos -conf $Conf -outputdir $OutDir
mv $OutDir/circos.png $OutDir/Fv_Fv_circos.png
mv $OutDir/circos.svg $OutDir/Fv_Fv_circos.svg


## SatsumaSynteny 

 ./SatsumaSynteny -t /home/connellj/local_illumina_Fv_genome/WT_contigs_unmasked.fa -q /home/connellj/Kim_venenatum_genome/Fusarium_venenatum_gca_900007375.ASM90000737v1.dna_rm.toplevel.fa -o /home/connellj/emr_ven_vs_kim_ven
mkdir -p $OutDir