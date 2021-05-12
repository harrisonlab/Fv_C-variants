#!/usr/bin/env python


#The purpse of this script is to remove errors called as SNPs from you VCF files. 

import argparse


ap = argparse.ArgumentParser()
ap.add_argument('--VCF_file',required=True,type=str,help='VCF file')
ap.add_argument('--error_SNPs',required=True,type=str,help='File containing error snps')
ap.add_argument('--outfile',required=True,type=str,help='output')

file = ap.parse_args()


file_in_1 = open (file.VCF_file, "r")
file_in_2 = open (file.error_SNPs, "r")
file_out = open (file.outfile, "w")



def function_for_column_in_vcf (file_name):
	error_list = {}
	data = file_in_2.readlines ()
	for row in data:
		if "#" in row[0]:
			pass
		else:
			row = row.split ("\t")
			error_info = row[0] + "-" + row[1]
			error_list[error_info] = 0
	return error_list
	file_in_2.close ()



errors = function_for_column_in_vcf (file_in_2)

#print(len(errors))#print(errors)


def function_find_errors (file_name, error_file):
	data2 = file_name.readlines ()
	for row2 in data2:
		if "#" in row2[0]:
			pass
		else:
			row2 = row2.split ("\t")
			pos_info = row2[0] + "-" + row2[1]
			if pos_info in errors:
				pass
			else:
				file_out.write ("\t".join(row2))
	file_in_1.close ()
	file_out.close ()		



true_snps = function_find_errors (file_in_1, errors)




