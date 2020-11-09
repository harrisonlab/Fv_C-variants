#!/usr/bin/python


input_file_location = "/data/scratch/connellj/Fusarium_venenatum/F.venenatum/WT/minion_reference_check/reference_check/snp_calling_out/Error_snp/Minion_genome_SNPs.vcf"
output_file_name = "/data/scratch/connellj/Fusarium_venenatum/F.venenatum/WT/minion_reference_check/reference_check/snp_calling_out/Error_snp/Minion_genome_SNPs_edited_column_John_is_gay.vcf"

file_in = open (input_file_location, "r")
file_out = open (output_file_name, "w")

line = file_in.readlines()

for element in line:
	element = element.split ("\t")
	if "#" in element [0]:
		pass
	else:
		element [0] = element [0].replace("contig_", "A3_5_MINcontig_")
		bob = [element [0], element [1]]
		out_line = "\t".join (bob)
		print out_line
		file_out.write (out_line)
		file_out.write ("\n")

file_out.close()
file_in.close ()



#!/usr/bin/python


input_file_location = "/home/connellj/emr_ven_vs_kim_ven/satsuma_summary.chained.out"
output_file_name = "/home/connellj/emr_ven_vs_kim_ven/satsuma_summary_editedforcircos.chained.out"

file_in = open (input_file_location, "r")
file_out = open (output_file_name, "w")

line = file_in.readlines()

for element in line:
	element = element.split ("\t")
	if "I_dna_rm:chromosome_chromosome:ASM90000737v1:I:1:11988928:1_REF" in element [3]:
		element [3] = element [3].replace("I_dna_rm:chromosome_chromosome:ASM90000737v1:I:1:11988928:1_REF", "A3_5_kim_I")
	elif "II_dna_rm:chromosome_chromosome:ASM90000737v1:II:1:9140027:1_REF" in element [3]:
		element [3] = element [3].replace("II_dna_rm:chromosome_chromosome:ASM90000737v1:II:1:9140027:1_REF", "A3_5_kim_II")
	elif "III_dna_rm:chromosome_chromosome:ASM90000737v1:III:1:8341993:1_REF" in element [3]:
		element [3] = element [3].replace("III_dna_rm:chromosome_chromosome:ASM90000737v1:III:1:8341993:1_REF", "A3_5_kim_III")
	elif "IIII_dna_rm:chromosome_chromosome:ASM90000737v1:IIII:1:9101081:1_REF" in element [3]:
		element [3] = element [3].replace("IIII_dna_rm:chromosome_chromosome:ASM90000737v1:IIII:1:9101081:1_REF", "A3_5_kim_IIII")
	elif "v_dna_rm:chromosome_chromosome:ASM90000737v1:v:1:9545:1_REF" in element [3]:
		element [3] = element [3].replace("v_dna_rm:chromosome_chromosome:ASM90000737v1:v:1:9545:1_REF", "A3_5_kim_v")
	elif "VI_dna_rm:chromosome_chromosome:ASM90000737v1:VI:1:78612:1_REF" in element [3]:
		element [3] = element [3].replace("VI_dna_rm:chromosome_chromosome:ASM90000737v1:VI:1:78612:1_REF", "A3_5_kim_VI")
	else: 
		pass 
		element = "\t".join 
		file_out.write ("\n")

file_out.close()
file_in.close ()


