#Align the minION Fv genome to kim Fv genome to generate synteny co-localisation data for circos
#Run from command line satsauma-code

# requires a reference, quiery genome, and outdir, run from satsuma directory /home/connellj/bin/satsuma-code

 #minION 
 ./SatsumaSynteny -t /home/connellj/JGI_venenatum_genome/JGI_venenatum_genome.fasta -q /home/groups/harrisonlab/project_files/fusarium_venenatum/repeat_masked/F.venenatum/WT_minion/minion_submission/WT_albacore_v2_contigs_hardmasked.fa -o /home/connellj/emr_ven_vs_JGI_ven/satsuma_minION
 #Illumina
 ./SatsumaSynteny -t /home/connellj/JGI_venenatum_genome/JGI_venenatum_genome.fasta -q /home/groups/harrisonlab/project_files/fusarium_venenatum/repeat_masked/F.venenatum/WT/illumina_assembly/WT_contigs_hardmasked.fa -o /home/connellj/emr_ven_vs_JGI_ven/satsuma_Illumina

#Next generate data to create base circos plot via.conf file


##1 Prepare genome and .conf files 

OutDir=/home/connellj/emr_ven_vs_JGI_ven/satsuma_minION
#mkdir -p $OutDir
#minION genome to circos and combine
Fv_minION_genome=$(ls /home/groups/harrisonlab/project_files/fusarium_venenatum/repeat_masked/F.venenatum/WT_minion/minion_submission/WT_albacore_v2_contigs_hardmasked.fa)
ProgDir=~/git_repos/scripts/Fv_C-variants/Circos
$ProgDir/fasta2circos.py --genome $Fv_minION_genome --contig_prefix "A3_5_minION" > $OutDir/Fv_minION_genome.txt

Fv_JGI_genome=$(ls /home/connellj/JGI_venenatum_genome/JGI_venenatum_genome.fasta)
ProgDir=~/git_repos/scripts/Fv_C-variants/Circos
$ProgDir/fasta2circos.py --genome $Fv_JGI_genome --contig_prefix "A3_5_JGI" > $OutDir/Fv_JGI_genome.txt

  cat $OutDir/Fv_minION_genome.txt > $OutDir/Fv_Fv_genome.txt
  tac $OutDir/Fv_JGI_genome.txt >> $OutDir/Fv_Fv_genome.txt
#Illumina genome to circos and combine 
OutDir=/home/connellj/emr_ven_vs_JGI_ven/satsuma_Illumina
Fv_Illumina_genome=$(ls /home/groups/harrisonlab/project_files/fusarium_venenatum/repeat_masked/F.venenatum/WT/illumina_assembly/WT_contigs_hardmasked.fa)
ProgDir=~/git_repos/scripts/Fv_C-variants/Circos
$ProgDir/fasta2circos.py --genome $Fv_Illumina_genome --contig_prefix "A3_5_Illumina" > $OutDir/Fv_Illumina_genome.txt

Fv_JGI_genome=$(ls /home/connellj/JGI_venenatum_genome/JGI_venenatum_genome.fasta)
ProgDir=~/git_repos/scripts/Fv_C-variants/Circos
$ProgDir/fasta2circos.py --genome $Fv_JGI_genome --contig_prefix "A3_5_JGI" > $OutDir/Fv_JGI_genome.txt

  cat $OutDir/Fv_Illumina_genome.txt > $OutDir/Fv_Fv_genome.txt
  tac $OutDir/Fv_JGI_genome.txt >> $OutDir/Fv_Fv_genome.txt


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



# Edit the names of colums in satsuma synteny file to match fasta2circos output 

#!/usr/bin/python


input_file_location = "/home/connellj/emr_ven_vs_JGI_ven/satsuma_Illumina/satsuma_summary.chained.out"
output_file_name = "/home/connellj/emr_ven_vs_JGI_ven/satsuma_Illumina/satsuma_summary_editedforcircos.chained.out"

file_in = open (input_file_location, "r")
file_out = open (output_file_name, "w")

line = file_in.readlines()

for element in line:
	element = element.split ("\t")
	if "scaffold_1" in element [0]:
		element [0] = element [0].replace("scaffold_1", "A3_5_JGIscaffold_1")
		#print element [0]
	else:
		pass
	if "scaffold_2" in element [0]:
		element [0] = element [0].replace("scaffold_2", "A3_5_JGIscaffold_2")
		#print element [3]
	else:
		pass 
	if "scaffold_3" in element [0]:
		 element [0] = element [0].replace("scaffold_3", "A3_5_JGIscaffold_3")
		#print element [3]
	else:
		pass
	if  "scaffold_4" in element [0]:
		element [0] = element [0].replace("scaffold_4", "A3_5_JGIscaffold_4")
		#print element [3]
	else:
		pass
	if "scaffold_5" in element [0]:
		element [0] = element [0].replace("scaffold_5", "A3_5_JGIscaffold_5")
		#print element [3]
	else:
		pass
	if "scaffold_6" in element [0]:
		element [0] = element [0].replace("scaffold_6", "A3_5_JGIscaffold_6")
		#print element [3]
	else:
		pass
	if "scaffold_7" in element [0]:
		element [0] = element [0].replace("scaffold_7", "A3_5_JGIscaffold_7")
		#print element [3]
	else:
		pass
	if "scaffold_8" in element [0]:
		element [0] = element [0].replace("scaffold_8", "A3_5_JGIscaffold_8")
		#print element [3]
	else:
		pass
	if "scaffold_9" in element [0]:
		element [0] = element [0].replace("scaffold_9", "A3_5_JGIscaffold_9")
		#print element [3]
	else:
		pass
		data = [element [0], element [1], element [2], element [3], element [4], element [5]]
		out_line = "\t".join (data)
		print out_line
		file_out.write (out_line)
		file_out.write ("\n")

file_out.close()
file_in.close()


# oops also edit the named of genome 1 synteny to match fasta2circos output 

input_file_location = "/home/connellj/emr_ven_vs_JGI_ven/satsuma_Illumina/satsuma_summary_editedforcircos.chained.out"
output_file_name = "/home/connellj/emr_ven_vs_JGI_ven/satsuma_Illumina/satsuma_summary_editedforcircos2.chained.out"

file_in = open (input_file_location, "r")
file_out = open (output_file_name, "w")

line = file_in.readlines()

for element in line:
	element = element.split ("\t")
	if "NODE_" in element [3]:
		element [3] = element [3].replace("NODE_", "A3_5_contig_")
	else:
		pass	
	data = [element [0], element [1], element [2], element [3], element [4], element [5]]
	out_line = "\t".join (data)
	print out_line
	file_out.write (out_line)
	file_out.write ("\n")

file_out.close()
file_in.close ()

input_file_location = "/home/connellj/emr_ven_vs_JGI_ven/satsuma_Illumina/satsuma_summary_editedforcircos.chained.out"
output_file_name = "/home/connellj/emr_ven_vs_JGI_ven/satsuma_Illumina/satsuma_summary_editedforcircos2.chained.out"

file_in = open (input_file_location, "r")
file_out = open (output_file_name, "w")

line = file_in.readlines()

for element in line:
	element = element.split ("\t")
	if "NODE_" in element [3]:
		element [3] = element [3].replace("NODE_", "A3_5_contig_")
	else:
		pass
	if "A3_5_contig_1_length_1912021_cov_80.4554_ID_1380" in element [3]:
		element [3] = element [3].replace("A3_5_contig_1_length_1912021_cov_80.4554_ID_1380", "A3_5_contig_1")
	else:
		pass	
	data = [element [0], element [1], element [2], element [3], element [4], element [5]]
	out_line = "\t".join (data)
	print out_line
	file_out.write (out_line)
	file_out.write ("\n")

file_out.close()
file_in.close ()

  ## Running CIRCOS --CONFIGURATION FILE LOCATION-- 
  ## /home/connellj/software/circos
OutDir=/home/connellj/emr_ven_vs_JGI_ven/satsuma_Illumina
Conf=$(ls /home/connellj/git_repos/scripts/Fv_C-variants/Circos/Fv_Fv_JGI_illumina_circos.conf.sh)
circos -conf $Conf -outputdir $OutDir
mv $OutDir/circos.png $OutDir/Fv_Fv_JGI_circos.png
mv $OutDir/circos.svg $OutDir/Fv_Fv_JGI_circos.svg 

#check 2d plot file 
#check ticks.conf file 
#synteny colours edited via synteny file 



