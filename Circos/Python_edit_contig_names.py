#!/usr/bin/python

import argparse


ap = argparse.ArgumentParser()
ap.add_argument('--synteny',required=True,type=str,help='The genome assembly')
ap.add_argument('--outfile',required=True,type=str,help='output')

file = ap.parse_args()


file_in = open (file.synteny, "r")
file_out = open (file.outfile, "w")


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



 



