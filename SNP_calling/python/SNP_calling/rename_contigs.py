#Rename contigs in gatk vcf file to match snpeff gff 

import re

input_file_location = "/projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/SNP_calling_out/WT_contigs_unmasked_temp.vcf"
output_file_name = "/projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/SNP_calling_out/WT_contigs_unmasked_temp_contigs_renamed.vcf"

file_in = open (input_file_location, "r")
file_out = open (output_file_name, "w")

file = file_in.readlines()

for column in file:
	column = column.split ("\t")
	result = re.match(r"^NODE_[0-9]*", column[0])
	print result








	out_line = "\t".join (column)
	print out_line
	file_out.write (out_line)

file_out.close()
file_in.close ()


print column











