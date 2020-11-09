#!usr/bin/python

import os

input_file_location = "/home/groups/harrisonlab/project_files/fusarium_venenatum/repeat_masked/F.venenatum/WT/illumina_assembly_ncbi"
input_file = "WT_contigs_hardmasked.fa"
chromosome_gap = 100 * "N" 

output_file = "/home/connellj/fusarium_venenatum/reference_generation/WT_illumina_reference_genome.fasta"

os.remove (output_file)

chromosome_contig_1_order = "A3_5_contig_18, A3_5_contig_30, A3_5_contig_44, A3_5_contig_29, A3_5_contig_46, A3_5_contig_43, A3_5_contig_70, A3_5_contig_60, A3_5_contig_54, A3_5_contig_7, A3_5_contig_76, A3_5_contig_58, A3_5_contig_52, A3_5_contig_68, A3_5_contig_84, A3_5_contig_16, A3_5_contig_28, A3_5_contig_67, A3_5_contig_21, A3_5_contig_10, A3_5_contig_25, A3_5_contig_37, A3_5_contig_65, A3_5_contig_77, A3_5_contig_74, A3_5_contig_82, A3_5_contig_26, A3_5_contig_75, A3_5_contig_78, A3_5_contig_34, A3_5_contig_45, A3_5_contig_53, A3_5_contig_14, A3_5_contig_32"
chromosome_contig_2_order = "A3_5_contig_24, A3_5_contig_17, A3_5_contig_35, A3_5_contig_5, A3_5_contig_50, A3_5_contig_69, A3_5_contig_15, A3_5_contig_31, A3_5_contig_6, A3_5_contig_86, A3_5_contig_38, A3_5_contig_81, A3_5_contig_61, A3_5_contig_62, A3_5_contig_12, A3_5_contig_1"
chromosome_contig_3_order = "A3_5_contig_49, A3_5_contig_80, A3_5_contig_33, A3_5_contig_2, A3_5_contig_41, A3_5_contig_20, A3_5_contig_51, A3_5_contig_79, A3_5_contig_64, A3_5_contig_19, A3_5_contig_23, A3_5_contig_47, A3_5_contig_59, A3_5_contig_9, A3_5_contig_13, A3_5_contig_57, A3_5_contig_66, A3_5_contig_22, A3_5_contig_55"
chromosome_contig_4_order = "A3_5_contig_63, A3_5_contig_11, A3_5_contig_48, A3_5_contig_36, A3_5_contig_42, A3_5_contig_40, A3_5_contig_83, A3_5_contig_39, A3_5_contig_27, A3_5_contig_4, A3_5_contig_73, A3_5_contig_3, A3_5_contig_8, A3_5_contig_56, A3_5_contig_71, A3_5_contig_72, A3_5_contig_85"

chromosome_contig_1_order = chromosome_contig_1_order.split (", ")
chromosome_contig_2_order = chromosome_contig_2_order.split (", ")
chromosome_contig_3_order = chromosome_contig_3_order.split (", ")
chromosome_contig_4_order = chromosome_contig_4_order.split (", ")

len (chromosome_contig_1_order) + len (chromosome_contig_2_order) + len (chromosome_contig_3_order) + len (chromosome_contig_4_order)



os.chdir(input_file_location)

file_in = open (input_file)

data_dict = {}

for line in file_in:
  while "\n" in line:
    line = line.strip ("\n")
  if ">" in line:
    contig_name = line [1:]
    data_dict [contig_name] = []
  else:
    data_dict [contig_name].append (line)


file_out = open (output_file, "w+")
chrom_1 = 0
chrom_2 = 0
chrom_3 = 0
chrom_4 = 0
file_out.write (">" + "Chromosome_1" + "\n")
for element in chromosome_contig_1_order:
  chrom_1 +=1
  element = element [5:]
  for thing in data_dict [element]:
    file_out.write (thing)
  file_out.write (chromosome_gap + "\n")

file_out.write (">" + "Chromosome_2" + "\n")
for element in chromosome_contig_2_order:
  chrom_2  +=1
  element = element [5:]
  for thing in data_dict [element]:
    file_out.write (thing)
  file_out.write (chromosome_gap + "\n")

file_out.write (">" + "Chromosome_3" + "\n")
for element in chromosome_contig_3_order:
  chrom_3  +=1
  element = element [5:]
  for thing in data_dict [element]:
    file_out.write (thing)
  file_out.write (chromosome_gap + "\n")

file_out.write (">" + "Chromosome_4" + "\n")
for element in chromosome_contig_4_order:
  chrom_4  +=1
  element = element [5:]
  for thing in data_dict [element]:
    file_out.write (thing)
  file_out.write (chromosome_gap + "\n")



file_out.close()
file_in.close()