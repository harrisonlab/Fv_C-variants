#!/usr/bin/python

#Edit contig name from satasuma alignments 

input_file_location = "/home/connellj/chrom_rearr_check/satsuma_summary.chained.out"
output_file_name = "/home/connellj/chrom_rearr_check/satsuma_summary_editedforcircos.chained.out"

file_in = open (input_file_location, "r")
file_out = open (output_file_name, "w")

line = file_in.readlines()

for element in line:
	element = element.split ("\t")
	if "contig_" in element [0]:
		element [0] = element [0].replace("contig_", "A3_5_contig_")
	else:
		pass
	if "contig_" in element [3]:
		element [3] = element [3].replace("contig_", "C_15_contig_")
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
