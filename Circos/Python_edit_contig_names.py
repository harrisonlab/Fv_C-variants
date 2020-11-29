# Edit the names of colums in satsuma synteny file
#!/usr/bin/python


#1.) Change input_file_name to the location of satsuma_summary_chained_out + file name 
#2.) Chnge output_file_name to a any location + any file name you like but not the same file name as input
#3.) Chnage contig nammes to be replaced 
#3.) Run command line by opening python 


input_file_location = "/home/connellj/Circos/satsuma_alignment/test_copy/satsuma_summary.chained.out"
output_file_name = "/home/connellj/Circos/satsuma_alignment/test_copy/satsuma_summary_editedforcircos.chained.out"

file_in = open (input_file_location, "r")
file_out = open (output_file_name, "w")

line = file_in.readlines()

for element in line:
  element = element.split ("\t")
  if "contig_" in element [0]:
    element [0] = element [0].replace("contig_", "A3_5_contig_")
  if "contig_" in element [3]:
    element [3] = element [3].replace("contig_", "A3_5_MIN_contig_")
  else:
    pass 
  data = [element [0], element [1], element [2], element [3], element [4], element [5]]
  out_line = "\t".join (data)
  print out_line
  file_out.write (out_line)
  file_out.write ("\n")

file_out.close()
file_in.close ()


 



