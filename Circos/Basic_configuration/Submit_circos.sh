OutDir=analysis/circos/F.venenatum/Fv_Fg
mkdir -p $OutDir

Fv_genome=$(ls repeat_masked/F.venenatum/WT/illumina_assembly_ncbi/WT_contigs_unmasked.fa)
ProgDir=~/git_repos/emr_repos/scripts/fusarium/pathogen/identify_LS_chromosomes/circos
$ProgDir/fasta2circos.py --genome $Fv_genome --contig_prefix "A3_5_" > $OutDir/Fv_genome.txt

Fg_genome=$(ls assembly/external_group/F.graminearum/PH1/dna/Fusarium_graminearum.RR1.dna.toplevel.fa)
ProgDir=~/git_repos/emr_repos/scripts/fusarium/pathogen/identify_LS_chromosomes/circos
$ProgDir/fasta2circos.py --genome $Fg_genome --contig_prefix "PH1_" > $OutDir/Fg_genome.txt

  cat $OutDir/Fv_genome.txt > $OutDir/Fv_Fg_genome.txt
  tac $OutDir/Fg_genome.txt >> $OutDir/Fv_Fg_genome.txt

  # Contigs smaller than 10Kb were removed
  cat $OutDir/Fv_Fg_genome.txt | grep -v -e 'PH1_Mt' -e 'PH1_HG970330' \
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

  Conf=$(ls /home/connellj/git_repos/Fv_C-variants/Circos/Basic_configuration/Base_circos_conf.sh)
circos -conf $Conf -outputdir $OutDir
mv $OutDir/circos.png $OutDir/Fv_Fg_circos.png
mv $OutDir/circos.svg $OutDir/Fv_Fg_circos.svg