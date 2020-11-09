#!/usr/bin/python

# 1.) Take genes identified from SNP calling C-varient genomes and create a libraby of these genes.

input_file_location_1 = "/home/groups/harrisonlab/project_files/Fv_C-variants/analysis/SNP_calling/analysis/popgen/SNP_calling/snpEff_genes_WT_contigs_unmasked_filtered.txt"
input_file_location_2 = "/data/scratch/connellj/Fusarium_venenatum/Illumina_SNP_Calling/SNP_calling_illumina/snpEff_genes_WT_contigs_unmasked_filtered.txt"
input_file_location_3 = "/data/scratch/connellj/Fusarium_venenatum/Illumina_indel_calling/indel_calling/Fv_indel_calling/svaba/filtered_indels/snpEff_genes_Fven_svaba_sv.svaba.unfiltered.indel.txt"
input_file_location_4 = "/home/groups/harrisonlab/project_files/Fv_C-variants/analysis/SV_calling"
output_file_location = "/home/connellj/gene_library/SNP_gene_library.csv"
count_file_out = "/home/connellj/gene_library/count_gene_library-.csv"

file_in_1 = open (input_file_location_1, "r")
file_in_2 = open (input_file_location_2, "r")
file_in_3 = open (input_file_location_3, "r")
file_in_4 = open (input_file_location_4, "r")
file_out_1 = open (output_file_location, "w")
file_out_2 = open (count_file_out, "w")

lines_1 = file_in_1.readlines()
lines_2 = file_in_2.readlines()
lines_3 = file_in_3.readlines()
lines_4 = file_in_4.readlines()

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

for line_4 in lines_4:
	if "#" in line_4:
		pass
	else:
		line_4 = line_4.split ("\t")
		genes.append (line_4 [0])

header = "Genes identified from SNP+SV calling illumina"
file_out_1.write (header + "\n")
out_line_1 = "\n".join (genes)
file_out_1.write (out_line_1)


from collections import Counter
count_1 = Counter(genes) 

gene_2 = []

gene_2.append (count_1)

header_2 = "Gene"
header_3 = "Frequency" 
file_out_2.write (header_2 + "\t" + header_3 + "\n")
out_line_2 = "\n".join (gene_2)
file_out_2.write (out_line_2)


file_in_1.close()
file_in_2.close()
file_in_3.close()
file_in_4.close()
file_out_1.close()
file_out_2.close()




