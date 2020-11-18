#!/usr/bin/python
import re


input_file_location = "/projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/SNP_calling_out/non_synonomous_data_2.csv"
output_file_name = "/projects/fusarium_venenatum_miseq/SNP_calling/F.venenatum/SNP_calling_out/non_synonomous_data_edited.csv"

file_in = open (input_file_location, "r")
file_out = open (output_file_name, "w")

file = file_in.readlines()

genes = []

for column in file:
	column = column.split (" ")

r = re.findall(r"g[0-9]+|", column[7])


genes.append(r)
out = str (genes)
file_out.write (out + "\n")


file_in.close()	
file_out.close()












