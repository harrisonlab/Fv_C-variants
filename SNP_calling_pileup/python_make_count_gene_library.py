#!/usr/bin/python

# 1.) Take genes identified from SNP calling C-varient genomes and create a libraby of these genes.

input_file_location_1 = "/projects/fusarium_venenatum_miseq/SNP_calling/pileup_calls/snpEff_genes_WT_contigs_unmaskedSNPs_filtered.txt"
input_file_location_2 = "/projects/fusarium_venenatum_miseq/SNP_calling/pileup_calls/snpEff_genes_WT_contigs_unmaskedSNPs_filtered.txt"
input_file_location_3 = "/projects/fusarium_venenatum_miseq/SNP_calling/pileup_calls/snpEff_genes_WT_contigs_unmaskedSNPs_filtered.txt"
output_file_location = "/projects/fusarium_venenatum_miseq/SNP_calling/pileup_calls/gene_library.tsv"
count_file_out = "/projects/fusarium_venenatum_miseq/SNP_calling/pileup_calls/count_gene_library.tsv"

file_in_1 = open (input_file_location_1, "r")
file_in_2 = open (input_file_location_2, "r")
file_in_3 = open (input_file_location_3, "r" )
file_out_1 = open (output_file_location, "w")
file_out_2 = open (count_file_out, "w")

lines_1 = file_in_1.readlines()
lines_2 = file_in_2.readlines()
lines_3 = file_in_3.readlines()

genes = []

for line_1 in lines_1:
	if "#" in line_1:
		pass
	else:
		line_1 = line_1.split ("\t")
		genes.append (line_1 [0])

for line_2 in lines_2:
	if "#" in line_2:
		pass
	else:
		line_2 = line_2.split ("\t")
		genes.append (line_2 [0])

for line_3 in lines_3:
	if "#" in line_3:
		pass
	else:
		line_3 = line_3.split ("\t")
		genes.append (line_3 [0])

header = "Genes identified from SNP+SV calling illumina"
file_out_1.write (header + "\n")
out_line_1 = "\n".join (genes)
file_out_1.write (out_line_1)


from collections import Counter
count_1 = Counter(genes) 

gene_2 = [str(k)+'\t'+str(v) for (k,v) in count_1.items()]


header_2 = "Gene"
header_3 = "Frequency" 
file_out_2.write (header_2 + "\t" + header_3 + "\n")
out_line_2 = "\n".join (gene_2)
file_out_2.write (out_line_2)


file_in_1.close()
file_in_2.close()
file_in_3.close()
file_out_1.close()
file_out_2.close()




