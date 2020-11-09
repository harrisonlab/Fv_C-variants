import re


input_file_location = "/projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/SNP_calling_out/WT_contigs_unmasked_temp.vcf"
output_file_name = "/projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/SNP_calling_out/WT_contigs_unmasked_temp_contigsrenamed.vcf"

file_in = open (input_file_location, "r")
file_out = open (output_file_name, "w")

file = file_in.readlines()

for column in file:
	column = column.split ("\t")
r1 = re.findall(r"^NODE_[0-9]",column [0])
	r1 = "\t".join (column)
	print r1
	file_out.write (r1)
	












input_file_location = "/projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/SNP_calling_out/WT_contigs_unmasked_temp.vcf"
output_file_name = "/projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/SNP_calling_out/WT_contigs_unmasked_temp_contigsrenamed.vcf"

file_in = open (input_file_location, "r")
file_out = open (output_file_name, "w")

file = file_in.readlines()

for column in file:
	column = column.split ("\t")
	column [0] = column [0].replace("NODE_", "contig_")
	column [0] = column [0].replace("length_", "") 
	out_line = "\t".join (column)
	print out_line
	file_out.write (out_line)

file_out.close()
file_in.close ()


print column


