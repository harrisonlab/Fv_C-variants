

# This script tells you what genome the snp are present in. SNPs where generated using samtools minion snp calling 


#!/usr/bin/python

# Constants
from operator import itemgetter 

chromsome_multiplier = 1 * 10 ** 8 # Constant to include LG in position data
input_files = ["C1","C2","C3","C4","C5","C6"]
input_file_location = "/data/scratch/connellj/Fusarium_venenatum/MINion_indel_calling/alignments/indipendant_alignments/Structural_variants/"
output_file_name = "/data/scratch/connellj/Fusarium_venenatum/MINion_indel_calling/alignments/Structural_variants/SV_test.csv"

def function_for_vcf_in (file_name):
	list_out = []
	vcf_file = open (file_name, "r")
	data = vcf_file.readlines ()
	for row in data:
		if "#" in row:
			pass
		else:
			row = row.split ("	")
			contig_info = int (row [0][-1]) * chromsome_multiplier
			SNP_info = contig_info + int (row [1])
			list_out.append (SNP_info)
	return list_out
	vcf_file.close ()


def function_find_closest (SNP_pos, SNP_list):
	min_dist = 5* 10 ** 8
	for element in SNP_list:
	 	difference = abs (SNP_pos - element)
		if difference < min_dist:
			min_dist = difference
			min_dist_element = element
	return min_dist, min_dist_element


def function_count_SNP_incidence (c_unique, all_c_varients, window_size):
	for SNP in c_unique:
		c1_counter = 0
		c2_counter = 0
		c3_counter = 0
		c4_counter = 0
		c5_counter = 0
		c6_counter = 0
		for c_var_SNP in all_c_varients ["C1"]:
			if SNP in error_SNPs:
				pass
			elif c_var_SNP <= SNP < (c_var_SNP + window_size):
				c1_counter = c1_counter + 1
		if c1_counter > 1:
			c1_counter = 1
		for c_var_SNP in all_c_varients ["C2"]:
			if SNP in error_SNPs:
				pass
			elif c_var_SNP <= SNP < (c_var_SNP + window_size):
				c2_counter = c2_counter + 1
		if c2_counter > 1:
			c2_counter = 1
		for c_var_SNP in all_c_varients ["C3"]:
			if SNP in error_SNPs:
				pass
			elif c_var_SNP <= SNP < (c_var_SNP + window_size):
				c3_counter = c3_counter + 1
		if c3_counter > 1:
			c3_counter = 1
		for c_var_SNP in all_c_varients ["C4"]:
			if SNP in error_SNPs:
				pass
			elif c_var_SNP <= SNP < (c_var_SNP + window_size):
				c4_counter = c4_counter + 1
		if c4_counter > 1:
			c4_counter = 1
		for c_var_SNP in all_c_varients ["C5"]:
			if SNP in error_SNPs:
				pass
			elif c_var_SNP <= SNP < (c_var_SNP + window_size):
				c5_counter = c5_counter + 1
		if c5_counter > 1:
			c5_counter = 1
		for c_var_SNP in all_c_varients ["C6"]:
			if SNP in error_SNPs:
				pass
			elif c_var_SNP <= SNP < (c_var_SNP + window_size):
				c6_counter = c6_counter + 1
		if c6_counter > 1:
			c6_counter = 1
		if c1_counter + c2_counter + c3_counter + c4_counter + c5_counter + c6_counter == 0:
			pass
		else:	
			SNP_incidence [SNP] = [c1_counter, c2_counter, c3_counter, c4_counter, c5_counter, c6_counter]



window_size = 1000
SNP_incidence = {}



# input all data
all_c_varients = {}

error_SNPs = function_for_vcf_in ("/data/scratch/connellj/Fusarium_venenatum/MINion_indel_calling/alignments/WT_alignment/svaba/Fven_svaba_sv.svaba.unfiltered.sv.vcf")

for c_varient in input_files:
	file_path = input_file_location + c_varient + "/" + "Fven_svaba_sv.svaba.unfiltered.sv_" + c_varient + ".vcf" 
	print "loading:" + file_path
	all_c_varients [c_varient] = function_for_vcf_in (file_path)

c_unique = set (all_c_varients ["C1"] + all_c_varients ["C2"] + all_c_varients ["C3"] + all_c_varients ["C4"] + all_c_varients ["C5"] + all_c_varients ["C6"])



function_count_SNP_incidence (c_unique, all_c_varients, window_size)

with open (output_file_name, "wb") as file_out:
	header = "Unique_SNP_Position,C1,C2,C3,C4,C5,C6,contig"
	file_out.write (header + "\n")
	for element in SNP_incidence:
		Unique_SNP_Position = str (element % chromsome_multiplier)
		contig = str ( element / chromsome_multiplier)
		C1 = str (SNP_incidence	[element][0])
		C2 = str (SNP_incidence	[element][1])
		C3 = str (SNP_incidence	[element][2])
		C4 = str (SNP_incidence	[element][3])
		C5 = str (SNP_incidence	[element][4])
		C6 = str (SNP_incidence	[element][5])
		line = Unique_SNP_Position + "," + C1 + "," + C2 + "," + C3 + "," + C4 + "," + C5 + "," + C6 + "," + contig
		file_out.write (line + "\n")