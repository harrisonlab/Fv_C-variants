# Circos configuration for EMR illumina Fv genome vs Kim Fv genome 





# Defines unit length for ideogram and tick spacing, referenced

# using "u" prefix, e.g. 10u

#chromosomes_units           = 1000000



# Show all chromosomes in karyotype file. By default, this is

# true. If you want to explicitly specify which chromosomes

# to draw, set this to 'no' and use the 'chromosomes' parameter.

# chromosomes_display_default = yes



# Chromosome name, size and color definition

karyotype = /home/connellj/emr_ven_vs_kim_ven/satsuma_minION/Fv_Fv_genome.txt


<ideogram>

  <spacing>

    # spacing between ideograms is 0.5% of the image

    #default = 0.005r

    default = 0.001r

    <pairwise A3_5_contig_22 A3_5_contig_55>

      # spacing between contig1 and FoL_chromosome_1 is 4x of 0.5% (2%) of image

      # The angle of the ideogram is also edited in <image> below.

      spacing = 10r

    </pairwise>

    <pairwise A3_5_kimII A3_5_kimI>

      spacing = 10r

    </pairwise>

    <pairwise A3_5_kimIII A3_5_kimII>

      #spacing = 0.005r

      spacing = 10r

    </pairwise>

    <pairwise A3_5_kimIII A3_5_kimIIII>

      spacing = 10r

    </pairwise>

    <pairwise A3_5_minIONcontig_1 A3_5_kimI>

      spacing = 10r

    </pairwise>

    <pairwise A3_5_minIONcontig_1 A3_5_minIONcontig_2>

      spacing = 10r

    </pairwise>

    <pairwise A3_5_minIONcontig_2 A3_5_minIONcontig_3>

      spacing = 10r

    </pairwise>

    <pairwise A3_5_minIONcontig_3 A3_5_minIONcontig_4>

      spacing = 10r

    </pairwise>

    <pairwise A3_5_kimVI A3_5_kimv>

      spacing = 10r

    </pairwise>

    <pairwise A3_5_kimv A3_5_kimIIII>

      spacing = 10r

    </pairwise>

    <pairwise A3_5_kimIIII A3_5_minIONcontig_4>

      spacing = 10r

    </pairwise>

  </spacing>



  # ideogram position, thickness and fill

  radius           = 0.90r

  thickness        = 30p

  fill             = yes



  stroke_thickness = 3

  stroke_color     = gneg



  # ideogram labels

  # <<include ideogram.label.conf>>

  show_label        = no



  # show labels only for contigs 1-16 and

  # use the chromosome name as the label, but replace "contig" with "FoC"

  #label_format     = eval( var(idx) < 16? replace(var(chr),"contig_","Cont_") : "")
  label_format   = eval(sprintf("chr%s",var(label)))

  label_color    = gneg

  # 5% of inner radius outside outer ideogram radius

  label_radius = dims(ideogram,radius_outer) + 0.15r

  label_size        = 30p

  label_font        = bold

  label_parallel    = yes





  # ideogram cytogenetic bands, if defined in the karyotype file

  # <<include bands.conf>>

</ideogram>

<background>
color = chr10
</background>

# image size, background color, angular position

# of first ideogram, transparency levels, output

# file and directory

#

# it is best to include these parameters from etc/image.conf

# and override any using param* syntax

#

# e.g.

#<image>

# <<include etc/image.conf>>

# radius* = 500

# </image>

<image>


  # override the default angle_offset of -90 defined in etc/image.conf

  angle_offset* = -90

  radius* = 1500p

  <<include etc/image.conf>> # included from Circos distribution

</image>



# Specify which chromosomes will be drawn and their orientation

chromosomes_reverse = A3_5_kimI, A3_5_kimII, A3_5_kimIII, A3_5_kimIIII, A3_5_minIONcontig_4, A3_5_minIONcontig_3, A3_5_minIONcontig_2, A3_5_minIONcontig_1 

chromosomes_order = A3_5_minIONcontig_1, A3_5_minIONcontig_2, A3_5_minIONcontig_3, A3_5_minIONcontig_4, A3_5_kimIIII, A3_5_kimIII, A3_5_kimII, A3_5_kimI,

# RGB/HSV color definitions, color lists, location of fonts,

# fill patterns

<<include etc/colors_fonts_patterns.conf>> # included from Circos distribution
 

chromosomes_color = A3_5_minIONcontig_1=red,A3_5_minIONcontig_2=gpos75,A3_5_minIONcontig_3=blue,A3_5_minIONcontig_4=yellow,A3_5_kimIIII=yellow,A3_5_kimIII=blue,A3_5_kimII=gpos75,A3_5_kimI=red,
# debugging, I/O an dother system parameters

<<include etc/housekeeping.conf>> # included from Circos distribution
# Include ticks

<<include /home/connellj/git_repos/scripts/Fv_C-variants/Circos/At_vs_As_ticks.conf>>

# Include a 2D plot

<<include /home/connellj/git_repos/scripts/Fv_C-variants/Circos/Fv_Fv_kim_minION_2D_plot.conf.sh>>