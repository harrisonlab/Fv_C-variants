## Satsauma and Satsuma Syteny genome alognmet tool, scripts include 
- Satsuma unmasked WT Illumina to WT MINion 
- Satsuma Synteny WT Illumina hardmasked to WT MINion hardmasked
- Satsuma Synteny WT Illumina to unmasked to WT MINion unmaksed 
#NOTE Satsuma runs slow when unmasked genome is used/ Synteny is faster. 

#unmasked
./Satsuma -q /home/connellj/Illumina/local_assembley/WT_contigs_unmasked.fa -t /home/connellj/MINion/local_assembley/WT_albacore_v2_contigs_unmasked.fa -o /data/scratch/connellj/illumina_minion_alignment/

#hardmasked
./SatsumaSynteny -q /home/groups/harrisonlab/project_files/fusarium_venenatum/repeat_masked/F.venenatum/WT/illumina_assembly_ncbi/WT_contigs_hardmasked_repeatmasker_TPSI_appended.fa -t /home/groups/harrisonlab/project_files/fusarium_venenatum/repeat_masked/F.venenatum/WT_minion/minion_submission/WT_albacore_v2_contigs_hardmasked_repeatmasker_TPSI_appended.fa -o /data/scratch/connellj/illumina_minion_alignment/SatsumaSynteny

#unmasked
./SatsumaSynteny -q /home/connellj/Illumina/local_assembley/WT_contigs_unmasked.fa -t /home/connellj/MINion/local_assembley/WT_albacore_v2_contigs_unmasked.fa -o /data/scratch/connellj/illumina_minion_alignment/SatsumaSynteny/unmaksked


#Hardmasked
 ./SatsumaSynteny -t /home/groups/harrisonlab/project_files/fusarium_venenatum/repeat_masked/F.venenatum/WT/illumina_assembly_ncbi/WT_contigs_hardmasked.fa -q /home/groups/harrisonlab/project_files/fusarium_venenatum/repeat_masked/F.venenatum/WT_minion/minion_submission/WT_albacore_v2_contigs_hardmasked.fa -o /data/scratch/connellj/illumina_minion_alignment/SatsumaSynteny/hardmasked

./MicroSyntenyPlot -i /data/scratch/connellj/illumina_minion_alignment/SatsumaSynteny/unmaksked/summary_refinedAlignments.out
./BlockDisplaySatsuma -i /data/scratch/connellj/illumina_minion_alignment/SatsumaSynteny/unmaksked/summary_refinedAlignments.out 

connellj@bio72:/data/scratch/connellj/illumina_minion_alignment/SatsumaSynteny/unmaksked$ /data/scratch/connellj/illumina_minion_alignment/bin/satsuma-code/MicroSyntenyPlot -i ./satsuma_summary.chained.out -o ./test




#C_variant_vs_MINion_trial

 ./SatsumaSynteny -t /home/groups/harrisonlab/project_files/fusarium_venenatum/repeat_masked/F.venenatum/WT/illumina_assembly_ncbi/WT_contigs_hardmasked.fa -q /home/groups/harrisonlab/project_files/fusarium_venenatum/repeat_masked/F.venenatum/WT_minion/minion_submission/WT_albacore_v2_contigs_hardmasked.fa -o /data/scratch/connellj/illumina_minion_alignment/SatsumaSynteny/hardmasked/c_variant
mkdir -p $OutDir