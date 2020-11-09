
input_file_location = "/home/connellj/satsuma_summary_editedforcircos.chained.out"
output_file_name = "/home/connellj/satsuma_summary_editedforcircos_colour"

file_in = open (input_file_location, "r")
file_out = open (output_file_name, "w")

line = file_in.readlines()

for element in line:
	element = element.split ("\t")
	#a = line
	#aa = element [0] 
	if "contig_1" in element [0]:
		#line.append(["colour=red"])
		#print element [0]
		element [6] = element[5].replace("red")
	else:
		pass	
	print element 
	out_line = "\t".join (element)
	print out_line
	file_out.write (out_line)

file_out.close()
file_in.close ()



input_file_location = "/home/connellj/satsuma_summary_editedforcircos.chained.out"
output_file_name = "/home/connellj/satsuma_summary_editedforcircos_colour"

file_in = open (input_file_location, "r")
file_out = open (output_file_name, "w")

line = file_in.readlines()

for element in line:
	element = element.split ("\t")
	element.append(["red"])

	if "contig_1" in element [0]:
		element [0] = element[0] .append([colour])
		#print element [0]
	else:
		pass	

	print element 
	out_line = "\t".join (element)
	print out_line
	file_out.write (out_line)

file_out.close()
file_in.close ()







		x = [1, 2, 3]
		x.append([4, 5])	
		print (x)