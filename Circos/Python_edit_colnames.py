# Edit the names of colums in satsuma synteny file
#!/usr/bin/python


input_file_location = "/home/connellj/emr_ven_vs_kim_ven/satsuma_summary.chained.out"
output_file_name = "/home/connellj/emr_ven_vs_kim_ven/satsuma_summary_editedforcircos.chained.out"

file_in = open (input_file_location, "r")
file_out = open (output_file_name, "w")

line = file_in.readlines()

for element in line:
	element = element.split ("\t")
	if "I_dna_rm:chromosome_chromosome:ASM90000737v1:I:1:11988928:1_REF" in element [3]:
		element [3] = element [3].replace("I_dna_rm:chromosome_chromosome:ASM90000737v1:I:1:11988928:1_REF", "A3_5_kimI")
		#print element [3]
	else:
		pass
	if "II_dna_rm:chromosome_chromosome:ASM90000737v1:II:1:9140027:1_REF" in element [3]:
		element [3] = element [3].replace("II_dna_rm:chromosome_chromosome:ASM90000737v1:II:1:9140027:1_REF", "A3_5_kimII")
		#print element [3]
	else:
		pass 
	if "III_dna_rm:chromosome_chromosome:ASM90000737v1:III:1:8341993:1_REF" in element [3]:
		 element [3] = element [3].replace("III_dna_rm:chromosome_chromosome:ASM90000737v1:III:1:8341993:1_REF", "A3_5_kimIII")
		#print element [3]
	else:
		pass
	if  "IIII_dna_rm:chromosome_chromosome:ASM90000737v1:IIII:1:9101081:1_REF" in element [3]:
		element [3] = element [3].replace("IIII_dna_rm:chromosome_chromosome:ASM90000737v1:IIII:1:9101081:1_REF", "A3_5_kimIIII")
		#print element [3]
	else:
		pass
	if "v_dna_rm:chromosome_chromosome:ASM90000737v1:v:1:9545:1_REF" in element [3]:
		element [3] = element [3].replace("v_dna_rm:chromosome_chromosome:ASM90000737v1:v:1:9545:1_REF", "A3_5_kimv")
		#print element [3]
	else:
		pass
	if "VI_dna_rm:chromosome_chromosome:ASM90000737v1:VI:1:78612:1_REF" in element [3]:
		element [3] = element [3].replace("VI_dna_rm:chromosome_chromosome:ASM90000737v1:VI:1:78612:1_REF", "A3_5_kimVI")
		#print element [3]
	else:
		pass
		data = [element [0], element [1], element [2], element [3], element [4], element [5]]
		out_line = "\t".join (data)
		print out_line
		file_out.write (out_line)
		file_out.write ("\n")

file_out.close()
file_in.close ()


# oops Edit the named of column 1

input_file_location = "/home/connellj/circos_debug/satsuma_summary_editedforcircos2.chained.out"
output_file_name = "/home/connellj/circos_debug/satsuma_summary_editedforcircos.chained.out"

file_in = open (input_file_location, "r")
file_out = open (output_file_name, "w")

line = file_in.readlines()

for element in line:
	element = element.split ("\t")
	if "contig_" in element [0]:
		element [0] = element [0].replace("contig_", "A3_5_contig_")
	else:
		pass	
	data = [element [0], element [1], element [2], element [3], element [4], element [5]]
	out_line = "\t".join (data)
	print out_line
	file_out.write (out_line)
	file_out.write ("\n")

file_out.close()
file_in.close ()
