#Align the minION Fv genome to kim Fv genome to generate synteny co-localisation data for circos
#Run from command line satsauma-code

# requires a reference, quiery genome, and outdir

 ./SatsumaSynteny -t /home/connellj/Kim_venenatum_genome/Fusarium_venenatum_gca_900007375.ASM90000737v1.dna_rm.toplevel.fa -q /home/groups/harrisonlab/project_files/fusarium_venenatum/repeat_masked/F.venenatum/WT_minion/minion_submission/WT_albacore_v2_contigs_hardmasked.fa -o /home/connellj/emr_ven_vs_kim_ven/satsuma_minION

#Next generate data to create base circos plot via.conf file


##1 Prepare genome and .conf files 

OutDir=/home/connellj/emr_ven_vs_kim_ven/satsuma_minION
#mkdir -p $OutDir

Fv_minION_genome=$(ls /home/groups/harrisonlab/project_files/fusarium_venenatum/repeat_masked/F.venenatum/WT_minion/minion_submission/WT_albacore_v2_contigs_hardmasked.fa)
ProgDir=~/git_repos/scripts/Fv_C-variants/Circos
$ProgDir/fasta2circos.py --genome $Fv_minION_genome --contig_prefix "A3_5_minION" > $OutDir/Fv_minION_genome.txt

Fv_kim_genome=$(ls /home/connellj/Kim_venenatum_genome/Fusarium_venenatum_gca_900007375.ASM90000737v1.dna_rm.toplevel.fa)
ProgDir=~/git_repos/scripts/Fv_C-variants/Circos
$ProgDir/fasta2circos.py --genome $Fv_kim_genome --contig_prefix "A3_5_kim" > $OutDir/Fv_kim_genome.txt

  cat $OutDir/Fv_minION_genome.txt > $OutDir/Fv_Fv_genome.txt
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



# Edit the names of colums in satsuma synteny file to match fasta2circos output 

#!/usr/bin/python


input_file_location = "/home/connellj/emr_ven_vs_kim_ven/satsuma_minION/satsuma_summary.chained.out"
output_file_name = "/home/connellj/emr_ven_vs_kim_ven/satsuma_minION/satsuma_summary_editedforcircos.chained.out"

file_in = open (input_file_location, "r")
file_out = open (output_file_name, "w")

line = file_in.readlines()

for element in line:
	element = element.split ("\t")
	if "I_dna_rm:chromosome_chromosome:ASM90000737v1:I:1:11988928:1_REF" in element [0]:
		element [0] = element [0].replace("I_dna_rm:chromosome_chromosome:ASM90000737v1:I:1:11988928:1_REF", "A3_5_kimI")
		#print element [0]
	else:
		pass
	if "II_dna_rm:chromosome_chromosome:ASM90000737v1:II:1:9140027:1_REF" in element [0]:
		element [0] = element [0].replace("II_dna_rm:chromosome_chromosome:ASM90000737v1:II:1:9140027:1_REF", "A3_5_kimII")
		#print element [3]
	else:
		pass 
	if "III_dna_rm:chromosome_chromosome:ASM90000737v1:III:1:8341993:1_REF" in element [0]:
		 element [0] = element [0].replace("III_dna_rm:chromosome_chromosome:ASM90000737v1:III:1:8341993:1_REF", "A3_5_kimIII")
		#print element [3]
	else:
		pass
	if  "IIII_dna_rm:chromosome_chromosome:ASM90000737v1:IIII:1:9101081:1_REF" in element [0]:
		element [0] = element [0].replace("IIII_dna_rm:chromosome_chromosome:ASM90000737v1:IIII:1:9101081:1_REF", "A3_5_kimIIII")
		#print element [3]
	else:
		pass
	if "v_dna_rm:chromosome_chromosome:ASM90000737v1:v:1:9545:1_REF" in element [0]:
		element [0] = element [0].replace("v_dna_rm:chromosome_chromosome:ASM90000737v1:v:1:9545:1_REF", "A3_5_kimv")
		#print element [3]
	else:
		pass
	if "VI_dna_rm:chromosome_chromosome:ASM90000737v1:VI:1:78612:1_REF" in element [0]:
		element [0] = element [0].replace("VI_dna_rm:chromosome_chromosome:ASM90000737v1:VI:1:78612:1_REF", "A3_5_kimVI")
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

input_file_location = "/home/connellj/emr_ven_vs_kim_ven/satsuma_minION/satsuma_summary_editedforcircos.chained.out"
output_file_name = "/home/connellj/emr_ven_vs_kim_ven/satsuma_minION/satsuma_summary_editedforcircos2.chained.out"

file_in = open (input_file_location, "r")
file_out = open (output_file_name, "w")

line = file_in.readlines()

for element in line:
	element = element.split ("\t")
	if "contig_" in element [3]:
		element [3] = element [3].replace("contig_", "A3_5_minIONcontig_")
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
OutDir=/home/connellj/emr_ven_vs_kim_ven/satsuma_minION
Conf=$(ls /home/connellj/git_repos/scripts/Fv_C-variants/Circos/Fv_Fv_kim_minION_circos.conf.sh)
circos -conf $Conf -outputdir $OutDir
mv $OutDir/circos.png $OutDir/Fv_Fv_circos.png
mv $OutDir/circos.svg $OutDir/Fv_Fv_circos.svg 

#check 2d plot file 
#check ticks.conf file 
#synteny colours edited via synteny file 
