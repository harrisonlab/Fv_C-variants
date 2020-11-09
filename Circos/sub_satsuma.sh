#$ -S /bin/bash
#$ -cwd
#$ -pe smp 12
#$ -l virtual_free=1.25G
#$ -l h=blacklace01.blacklace|blacklace09.blacklace 



/home/connellj/bin/satsuma-code -t /home/connellj/local_illumina_Fv_genome/WT_contigs_unmasked.fa -q /home/connellj/miseq/c_variant_sequencing/2019/qc_dna/paired/fusarium_venenatum/c-varient/assembly/spades/c15/fusarium_venenatum/c-varient/filtered_contigs/filtered/repeat_masked/filtered_contigs_contigs_unmasked.fa -o /home/connellj/chrom_rearr_check/



