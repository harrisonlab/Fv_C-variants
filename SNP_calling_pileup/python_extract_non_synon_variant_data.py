#!/usr/bin/python

import csv


file_in="/projects/fusarium_venenatum_miseq/SNP_calling/pileup_calls/WT_contigs_unmaskedSNPs_filtered_nonsyn.vcf"
file_out="/projects/fusarium_venenatum_miseq/SNP_calling/pileup_calls/non_synon_edited.csv"


file_in = open (file_in, "r")


lines_1 = file_in.readlines()



contig = []
pos = []
alt  = []
qual = []




for line_1 in lines_1:
  if "#" in line_1:
    pass
  else:
    line_1 = line_1.split ("\t")
    contig.append (line_1 [0])
    pos.append (line_1 [1])
    alt.append (line_1 [3])
    qual.append (line_1 [4])




c = (contig)
p = (pos)
a = (alt)
q = (qual)



rows = zip(c,p,a,q)




with open(file_out, "w") as f:
    writer = csv.writer(f)
    for row in rows:
        writer.writerow(row) 


file_in.close()

