##Circos plot Fv Illumina genome vs Fv MINion genome
------------------------------------------------------

##1 Prepare genome and .conf files 

OutDir=/home/connellj/fusarium_venenatum/circos_out/Fv_vs_Fv
mkdir -p $OutDir

Fv_Illumina_genome=$(/home/connellj/local_illumina_Fv_genome/WT_contigs_unmasked.fa)
ProgDir=~/git_repos/scripts/Fv_C-variants/Circos
$ProgDir/fasta2circos.py --genome $Fv_Illumina_genome --contig_prefix "A3_5_Ill" > $OutDir/Fv_Illumina_genome.txt
##chmod 777 for permisions 
Fv_MINion_genome=$(/home/connellj/local_MINion_Fv_genome/WT_albacore_v2_contigs_unmasked.fa)
ProgDir=~git_repos/scripts/Fv_C-variants/Circos
$ProgDir/fasta2circos.py --genome $Fv_MINion_genome --contig_prefix "A3_5_MIN" > $OutDir/Fv_MINion_genome.txt
##chmod 777 for permisions 
  cat $OutDir/Fv_Illumina_genome.txt > $OutDir/Fv_Fv_genome.txt
  tac $OutDir/Fv_MINion_genome.txt >> $OutDir/Fv_Fv_genome.txt

## Contigs smaller than 10Kb were removed
  cat $OutDir/Fv_Fv_genome.txt | grep -v -e 'PH1_Mt' -e 'PH1_HG970330' \
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
  > $OutDir/Fv_Fv_genome_edited.txt

##2 Synteny link files are created 

  Orthology=$(ls analysis/orthology/orthomcl/Fv_vs_Fg/Fv_vs_Fg_orthogroups.txt)
  Gff1=$(ls gene_pred/final/F.venenatum/WT/final/final_genes_appended_renamed.gff3)
  Gff2=$(ls assembly/external_group/F.graminearum/PH1/gff/Fusarium_graminearum.RR1.36.gff3)
  cat $Gff2 | grep -v '#' > $OutDir/tmp.gff3
  ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/circos
  $ProgDir/orthology2circos_ribbons.py --orthology $Orthology --name1 A3_5 --gff1 $Gff1 --name2 PH1 --gff2 $OutDir/tmp.gff3 \
   | sort -k4,5 -V \
   > $OutDir/Fv_Fg_links.txt
  # Links to Fg LS contigs 3, 6, 14 and 15 were coloured black
  # cat $OutDir/Fv_Fg_links.txt \
  #   | sed '/4287_CM000591.1/ s/$/\tcolor=black/' \
  #   | sed '/4287_CM000594.1/ s/$/\tcolor=black/' \
  #   | sed '/4287_CM000602.2/ s/$/\tcolor=black/' \
  #   | sed '/4287_CM000603.1/ s/$/\tcolor=black/' \
  #   > $OutDir/Fv_Fg_links_edited.txt
  cat $OutDir/Fv_Fg_links.txt > $OutDir/Fv_Fg_links_edited.txt


  ## Running CIRCOS --CONFIGURATION FILE LOCATION-- 

Conf=$(ls /home/connellj/git_repos/scripts/Fv_C-variants/Circos/Fv_Fv_circos.conf)
circos -conf $Conf -outputdir $OutDir
mv $OutDir/circos.png $OutDir/Fv_Fg_circos.png
mv $OutDir/circos.svg $OutDir/Fv_Fg_circos.svg