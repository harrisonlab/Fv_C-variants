#!/usr/bin/python

#Script to remove WT SNP calls from C-variant SNP call file for correction.  
# Constants
from operator import itemgetter 
import csv


input_file_location_1 = "/projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/SNP_calling_out/WT_contigs_unmasked_temp_nonsyn.vcf"
output_file_location_1 = "/projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/variant_analysis/SNP_edited_unfiltered.csv"


file_in_1 = open (input_file_location_1, "r")

lines_1 = file_in_1.readlines()


pos = []
ref  = []
snp = []
qual = []
gene = []

# For this vcf 
# [1] = position 
# [3] = reference 
# [4] = SNP identified from SNP calling
# [5] = Quality Score
# [7] = Gene 

for line_1 in lines_1:
	if "#" in line_1:
		pass
	else:
		line_1 = line_1.split ("\t")
		pos.append (line_1 [1])
		ref.append (line_1 [3])
		snp.append (line_1 [4])
		qual.append (line_1 [5])
		gene.append (line_1 [7])


header_1 = "Quality_Score"
header_2 = "Position"
header_3 = "Refrence"
header_4 = "SNPs identified from SNP calling"
header_5 = "Gene"
#file_out_1.write (header_1 + "\t" + header_2 + "\t" + header_3 + "\t" + header_4 + "\t" + "\n")




q = (qual)
p = (pos)
r = (ref)
s = (snp)
g = (gene)

rows = zip(q,p,r,s,g)


with open(output_file_location_1, "w") as f:
    writer = csv.writer(f)
    for row in rows:
        writer.writerow(row)


file_in_1.close()	



#!/usr/bin/python

#Script to remove WT SNP calls from C-variant SNP call file for correction.  
# Constants
from operator import itemgetter 
import csv



input_file_location_1 = "/projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/variant_analysis/SNP_edited_unfiltered.csv"
output_file_location_1 = "/projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/variant_analysis/SNP_table.csv"


file_in_1 = open (input_file_location_1, "r")

lines_1 = file_in_1.readlines()


pos = []
ref  = []
snp = []
qual = []
gene = []

# For this vcf 
# [1] = position 
# [3] = reference 
# [4] = SNP identified from SNP calling
# [5] = Quality Score
# [7] = Gene 

for line_1 in lines_1:
	if "#" in line_1:
		pass
	else:
		line_1 = line_1.split (" ")
		pos.append (line_1 [1])
		ref.append (line_1 [2])
		snp.append (line_1 [3])
		qual.append (line_1 [0])
		gene.append (line_1 [21])


header_1 = "Quality_Score"
header_2 = "Position"
header_3 = "Refrence"
header_4 = "SNPs identified from SNP calling"
header_5 = "Gene"
#file_out_1.write (header_1 + "\t" + header_2 + "\t" + header_3 + "\t" + header_4 + "\t" + "\n")




q = (qual)
p = (pos)
r = (ref)
s = (snp)
g = (gene)

rows = zip(q,p,r,s,g)



with open(output_file_location_1, "w") as f:
    writer = csv.writer(f)
    for row in rows:
        writer.writerow(row)


file_in_1.close()	

