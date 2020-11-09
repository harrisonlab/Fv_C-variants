#!/usr/bin/python

# 1.) Take genes identified from SNP calling C-varient genomes and create a libraby of these genes.

input_file_location = "/home/groups/harrisonlab/project_files/Fv_C-variants/analysis/SNP_calling/analysis/popgen/SNP_calling/snpEff_genes_WT_contigs_unmasked_filtered.txt"
output_file_location = "/home/groups/harrisonlab/project_files/Fv_C-variants/analysis/SNP_calling/analysis/popgen/SNP_calling/SNP_gene_library.csv"

file_in =  open (input_file_location, "r")
file_out = open (output_file_location, "w")
lines = file_in.readlines()
#new list "genes"
genes = []

for line in lines:
	if "#" in line:
		pass
	else:
		line = line.split ("\t")
		genes.append (line [0])

header = "Genes identified from SNP calling"
file_out.write (header + "\n")
out_line = "\n".join (genes)
file_out.write (out_line)

file_in.close()
file_out.close()




