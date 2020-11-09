
# This script takes in filtered vcf file created by samtools and creates a master SNP list, it then uses each SNP as a point, it then looks up and down each of the 6 isolates until it finds a SNP.
# It then outputs a distance from each 'unique' SNP and its location. 
# This script is for the unfiltered vcf file outputted from minion SNP calling using 6 c variants sequenced using illumina.


#!/usr/bin/python

# Constants
from operator import itemgetter 

chromsome_multiplier = 1 * 10 ** 8 # Constant to include LG in position data
input_files = ["C1","C2","C3","C4","C5","C6"]
input_file_location = "/data/scratch/connellj/Fusarium_venenatum/MINion_SNP_Calling/"
output_file_name = "/data/scratch/connellj/Fusarium_venenatum/MINion_SNP_Calling/sliding_window_unfiltered_SNP_calling.csv"

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
		if element in error_SNPs:
			pass
		else:
	 		difference = abs (SNP_pos - element)
			if difference < min_dist:
				min_dist = difference
				min_dist_element = element
	if min_dist == 0:
		pass
	else:
		return min_dist, min_dist_element


# input all data
all_c_varients = {}

error_SNPs = function_for_vcf_in ("/data/scratch/connellj/Fusarium_venenatum/F.venenatum/WT/minion_reference_check/reference_check/snp_calling_out/Error_snp/Minion_genome_SNPs.vcf")

for c_varient in input_files:
	file_path = input_file_location + c_varient + "/" + "WT_albacore_v2_contigs_unmasked_filtered_" + c_varient + ".vcf" 
	print "loading:" + file_path
	all_c_varients [c_varient] = function_for_vcf_in (file_path)

c_unique = set (all_c_varients ["C1"] + all_c_varients ["C2"] + all_c_varients ["C3"] + all_c_varients ["C4"] + all_c_varients ["C5"] + all_c_varients ["C6"])


output = {}

for unique_SNP in c_unique:
	for C_strain in all_c_varients:
		closest_SNP = function_find_closest (unique_SNP, all_c_varients [C_strain])
		if unique_SNP not in output:
			output [unique_SNP] = [[C_strain, closest_SNP]]
		else:
			output [unique_SNP].append ([C_strain, closest_SNP])


unique_SNP_range = []
for unique_SNP in output:
	SNP_positions = [output [unique_SNP] [0][1][1], output [unique_SNP] [1][1][1], output [unique_SNP] [2][1][1], output [unique_SNP] [3][1][1], output [unique_SNP] [4][1][1], output [unique_SNP] [5][1][1]]
	difference = max (max (SNP_positions), unique_SNP) - min (min (SNP_positions), unique_SNP)
	SNP_positions.append (unique_SNP)
	SNP_positions.append (difference)
	unique_SNP_range.append (SNP_positions)

range_sorted = sorted(unique_SNP_range, key=itemgetter(-1))


with open (output_file_name, "wb") as file_out:
	header = "C1,C2,C3,C4,C5,C6,Unique_SNP_Position,Range,contig"
	file_out.write (header + "\n")
	for element in range_sorted:
		contig = str (element [0] / chromsome_multiplier)
		C3 = str (element [0] % chromsome_multiplier)
		C2 = str (element [1] % chromsome_multiplier)
		C1 = str (element [2] % chromsome_multiplier)
		C6 = str (element [3] % chromsome_multiplier)
		C5 = str (element [4] % chromsome_multiplier)
		C4 = str (element [5] % chromsome_multiplier)
		Unique_SNP_Position = str (element [6] % chromsome_multiplier)
		Range = str (element [7])
		line = C1 + "," + C2 + "," + C3 + "," + C4 + "," + C5 + "," + C6 + "," + Unique_SNP_Position + "," + Range + "," + contig
		file_out.write (line + "\n")