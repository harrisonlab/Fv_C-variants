##Circos plot Fv Illumina genome vs Fv MINion genome

#1 Prepare genome and .conf files 

OutDir=/home/connellj/fusarium_venenatum/circos_out/Fv_Fg
mkdir -p $OutDir

Fv_Illumina_genome=$(/home/groups/harrisonlab/project_files/Fv_C-variants/repeat_masked/F.venenatum/WT/illumina_assembly_ncbi/WT_contigs_unmasked.fa)
ProgDir=~/home/armita/git_repos/emr_repos/scripts/fusarium/pathogen/identify_LS_chromosomes/circos
$ProgDir/fasta2circos.py --genome $Fv_Illumina_genome --contig_prefix "A3_5_" > $OutDir/Fv_Illumina_genome.txt

Fv_MINion_genome=$(/home/groups/harrisonlab/project_files/Fv_C-variants/repeat_masked/F.venenatum/WT_minion/minion_submission/WT_albacore_v2_contigs_unmasked.fa)
ProgDir=~/home/armita/git_repos/emr_repos/scripts/fusarium/pathogen/identify_LS_chromosomes/circos
$ProgDir/fasta2circos.py --genome $Fv_MINion_genome --contig_prefix "PH1_" > $OutDir/Fv_MINion_genome.txt

  cat $OutDir/Fv_Illumina_genome.txt > $OutDir/Fv_Fv_genome.txt
  tac $OutDir/Fv_MINion_genome.txt >> $OutDir/Fv_Fv_genome.txt

  # Contigs smaller than 10Kb were removed
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
  > $OutDir/Fv_Fg_genome_edited.txt



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