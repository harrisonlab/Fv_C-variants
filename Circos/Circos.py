
input_file_location = "/data/scratch/connellj/illumina_minion_alignment/SatsumaSynteny/hardmasked/chained_out/satsuma_summary.chained.out"
output_file_name = "/data/scratch/connellj/illumina_minion_alignment/SatsumaSynteny/hardmasked/chained_out/satsuma_summary_chained_out_python.tsv"

import os
os.remove(output_file_name)

output = open (output_file_name, "a+")

raw_data = open (input_file_location,'r')

data_row = raw_data.readlines ()
chrom_prev = 0
for data in data_row:
	data_check = data.split ("\t")
	chrom_next = data_check [1]
	if int (chrom_next) > int (chrom_prev):
		output.write (data)
	chrom_prev = data_check [2]


print ("John is gay")
output.close()
raw_data.close()

new_output = "/data/scratch/connellj/illumina_minion_alignment/SatsumaSynteny/hardmasked/chained_out/satsuma_summary_chained_out_python_2.tsv"


os.remove(new_output)

output = open (new_output, "a+")

raw_data = open (output_file_name,'r')

data_row = raw_data.readlines ()
chrom_prev = 0
for data in data_row:
	data_check = data.split ("\t")
	chrom_next = data_check [4]
	if int (chrom_next) > int (chrom_prev):
		output.write (data)
	chrom_prev = data_check [5]


print ("John is gay")
output.close()
raw_data.close()