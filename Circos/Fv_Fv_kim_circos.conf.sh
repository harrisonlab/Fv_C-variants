

# Circos configuration for EMR illumina Fv genome vs Kim Fv genome 





# Defines unit length for ideogram and tick spacing, referenced

# using "u" prefix, e.g. 10u

#chromosomes_units           = 1000000



# Show all chromosomes in karyotype file. By default, this is

# true. If you want to explicitly specify which chromosomes

# to draw, set this to 'no' and use the 'chromosomes' parameter.

# chromosomes_display_default = yes



# Chromosome name, size and color definition

karyotype = ../../projects/oldhome/connellj/emr_ven_vs_kim_ven/Fv_Fv_genome_edited.txt




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

    <pairwise A3_5_kimI A3_5_kimII>

      spacing = 10r

    </pairwise>

    <pairwise A3_5_kimII A3_5_kimIII>

      #spacing = 0.005r

      spacing = 10r

    </pairwise>

    <pairwise A3_5_kimIII A3_5_kimIIII>

      spacing = 10r

    </pairwise>

    <pairwise A3_5_contig_18 A3_5_kimI>

      spacing = 10r

    </pairwise>

    <pairwise A3_5_contig_32 A3_5_contig_24>

      spacing = 10r

    </pairwise>

    <pairwise A3_5_contig_1 A3_5_contig_49>

      spacing = 10r

    </pairwise>

    <pairwise A3_5_kimVI A3_5_contig_85>

      spacing = 10r

    </pairwise>

    <pairwise A3_5_kimVI A3_5_kimv>

      spacing = 10r

    </pairwise>

    <pairwise A3_5_kimv A3_5_kimIIII>

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

#chromosomes_reverse = A3_5_kimI, A3_5_kimII, A3_5_kimIII, A3_5_kimIIII, A3_5_kimv, A3_5_kimVI, A3_5_contig_85, A3_5_contig_72, A3_5_contig_71, A3_5_contig_56, A3_5_contig_8, A3_5_contig_3, A3_5_contig_73, A3_5_contig_4, A3_5_contig_27, A3_5_contig_39, A3_5_contig_83, A3_5_contig_40, A3_5_contig_42, A3_5_contig_36, A3_5_contig_48, A3_5_contig_11, A3_5_contig_63, A3_5_contig_55, A3_5_contig_22, A3_5_contig_66, A3_5_contig_57, A3_5_contig_13, A3_5_contig_9, A3_5_contig_59, A3_5_contig_47, A3_5_contig_23, A3_5_contig_19, A3_5_contig_64, A3_5_contig_79, A3_5_contig_51, A3_5_contig_20, A3_5_contig_41, A3_5_contig_2, A3_5_contig_33, A3_5_contig_80, A3_5_contig_49, A3_5_contig_1, A3_5_contig_12, A3_5_contig_62, A3_5_contig_61, A3_5_contig_81, A3_5_contig_38, A3_5_contig_86, A3_5_contig_6, A3_5_contig_31, A3_5_contig_15, A3_5_contig_69, A3_5_contig_50, A3_5_contig_5, A3_5_contig_35, A3_5_contig_17, A3_5_contig_24, A3_5_contig_32, A3_5_contig_14, A3_5_contig_53, A3_5_contig_45, A3_5_contig_34, A3_5_contig_78, A3_5_contig_75, A3_5_contig_26, A3_5_contig_82, A3_5_contig_74, A3_5_contig_77, A3_5_contig_65, A3_5_contig_37, A3_5_contig_25, A3_5_contig_10, A3_5_contig_21, A3_5_contig_67, A3_5_contig_28, A3_5_contig_16, A3_5_contig_84, A3_5_contig_68, A3_5_contig_52, A3_5_contig_58, A3_5_contig_76, A3_5_contig_7, A3_5_contig_54, A3_5_contig_60, A3_5_contig_70, A3_5_contig_43, A3_5_contig_46, A3_5_contig_29, A3_5_contig_44, A3_5_contig_30, A3_5_contig_18, 

#chromosomes_order = A3_5_contig_18, A3_5_contig_30, A3_5_contig_44, A3_5_contig_29, A3_5_contig_46, A3_5_contig_43, A3_5_contig_70, A3_5_contig_60, A3_5_contig_54, A3_5_contig_7, A3_5_contig_76, A3_5_contig_58, A3_5_contig_52, A3_5_contig_68, A3_5_contig_84, A3_5_contig_16, A3_5_contig_28, A3_5_contig_67, A3_5_contig_21, A3_5_contig_10, A3_5_contig_25, A3_5_contig_37, A3_5_contig_65, A3_5_contig_77, A3_5_contig_74, A3_5_contig_82, A3_5_contig_26, A3_5_contig_75, A3_5_contig_78, A3_5_contig_34, A3_5_contig_45, A3_5_contig_53, A3_5_contig_14, A3_5_contig_32, A3_5_contig_24, A3_5_contig_17, A3_5_contig_35, A3_5_contig_5, A3_5_contig_50, A3_5_contig_69, A3_5_contig_15, A3_5_contig_31, A3_5_contig_6, A3_5_contig_86, A3_5_contig_38, A3_5_contig_81, A3_5_contig_61, A3_5_contig_62, A3_5_contig_12, A3_5_contig_1, A3_5_contig_49, A3_5_contig_80, A3_5_contig_33, A3_5_contig_2, A3_5_contig_41, A3_5_contig_20, A3_5_contig_51, A3_5_contig_79, A3_5_contig_64, A3_5_contig_19, A3_5_contig_23, A3_5_contig_47, A3_5_contig_59, A3_5_contig_9, A3_5_contig_13, A3_5_contig_57, A3_5_contig_66, A3_5_contig_22, A3_5_contig_55, A3_5_contig_63, A3_5_contig_11, A3_5_contig_48, A3_5_contig_36, A3_5_contig_42, A3_5_contig_40, A3_5_contig_83, A3_5_contig_39, A3_5_contig_27, A3_5_contig_4, A3_5_contig_73, A3_5_contig_3, A3_5_contig_8, A3_5_contig_56, A3_5_contig_71, A3_5_contig_72, A3_5_contig_85, A3_5_kimVI, A3_5_kimv, A3_5_kimIIII, A3_5_kimIII, A3_5_kimII, A3_5_kimI,

# RGB/HSV color definitions, color lists, location of fonts,


# fill patterns

<<include etc/colors_fonts_patterns.conf>> # included from Circos distribution
 

chromosomes_color = A3_5_contig_18=red,A3_5_contig_30=red,A3_5_contig_44=red,A3_5_contig_29=red,A3_5_contig_46=red,A3_5_contig_43=red,A3_5_contig_70=red,A3_5_contig_60=red,A3_5_contig_54=red,A3_5_contig_7=red,A3_5_contig_76=red,A3_5_contig_58=red,A3_5_contig_52=red,A3_5_contig_68=red,A3_5_contig_84=red,A3_5_contig_16=red,A3_5_contig_28=red,A3_5_contig_67=red,A3_5_contig_21=red,A3_5_contig_10=red,A3_5_contig_25=red,A3_5_contig_37=red,A3_5_contig_65=red,A3_5_contig_77=red,A3_5_contig_74=red,A3_5_contig_82=red,A3_5_contig_26=red,A3_5_contig_75=red,A3_5_contig_78=red,A3_5_contig_34=red,A3_5_contig_45=red,A3_5_contig_53=red,A3_5_contig_14=red,A3_5_contig_32=red,A3_5_kimI=red,A3_5_contig_24=gpos75,A3_5_contig_17=gpos75,A3_5_contig_35=gpos75,A3_5_contig_5=gpos75,A3_5_contig_50=gpos75,A3_5_contig_69=gpos75,A3_5_contig_15=gpos75,A3_5_contig_31=gpos75,A3_5_contig_6=gpos75,A3_5_contig_86=gpos75,A3_5_contig_38=gpos75,A3_5_contig_81=gpos75,A3_5_contig_61=gpos75,A3_5_contig_62=gpos75,A3_5_contig_12=gpos75,A3_5_contig_1=gpos75,A3_5_kimII=gpos75,A3_5_contig_22=blue,A3_5_contig_66=blue,A3_5_contig_57=blue,A3_5_contig_13=blue,A3_5_contig_9=blue,A3_5_contig_59=blue,A3_5_contig_47=blue,A3_5_contig_23=blue,A3_5_contig_19=blue,A3_5_contig_64=blue,A3_5_contig_79=blue,A3_5_contig_51=blue,A3_5_contig_20=blue,A3_5_contig_41=blue,A3_5_contig_49=blue,A3_5_contig_63=yellow,A3_5_contig_2=blue,A3_5_contig_33=blue,A3_5_contig_55=yellow,A3_5_kimIII=blue,A3_5_contig_80=yellow,A3_5_contig_11=yellow,A3_5_contig_48=yellow,A3_5_contig_36=yellow,A3_5_contig_42=yellow,A3_5_contig_40=yellow,A3_5_contig_83=yellow,A3_5_contig_39=yellow,A3_5_contig_27=yellow,A3_5_contig_4=yellow,A3_5_contig_73=yellow,A3_5_contig_3=yellow,A3_5_contig_8=yellow,A3_5_contig_56=yellow,A3_5_contig_71=yellow,A3_5_contig_72=yellow,A3_5_contig_85=yellow,A3_5_kimIIII=yellow,A3_5_kimv=yellow,A3_5_kimVI=yellow






# debugging, I/O an dother system parameters

<<include etc/housekeeping.conf>> # included from Circos distribution


# Include ticks

<<include /home/connellj/git_repos/Fv_C-variants/Circos/At_vs_As_ticks.conf>>



# Include a 2D plot

<<include /home/connellj/git_repos/Fv_C-variants/Circos/Fv_Fv_kim_illumina_2D_plot.conf.sh>>

