#!/usr/bin/python

#The purpose of this script is to remov error snp calls from vcf files and to tell what genomes snps are present in  


Constants
from operator import itemgetter

input_files = ["C1","C2","C3","C4","C5","C6"]
input_file_location = "/data/scratch/connellj/Fusarium_venenatum/MINion_SNP_Calling/"
output_file_name = "/data/scratch/connellj/Fusarium_venenatum/MINion_SNP_Calling/sliding_window_unfiltered_SNP_calling_1000bp_genome_prsence.csv"



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

error_SNPs = function_for_vcf_in ("/data/scratch/connellj/Fusarium_venenatum/F.venenatum/WT/minion_reference_check/reference_check/snp_calling_out/Error_snp/Minion_genome_SNPs.vcf")