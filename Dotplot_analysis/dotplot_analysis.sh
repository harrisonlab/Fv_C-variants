#Create dotplot synteny analysis from two genomes

# First create the minimap.paf file from 2 genomes 

Genome1=/projects/fusarium_venenatum_miseq/genomes/WT/WT_contigs_unmasked.fa              #replace with your genome 
Genome2=/projects/fusarium_venenatum_miseq/genome_assemblys/C15/C15_contigs_unmasked.fa   #replace with your genome 
Outdir=/projects/fusarium_venenatum_miseq/genome_synteny/
mkdir -p $Outdir
Progdir=/home/connellj/git_repos/emr_repos/Fv_C-variants/Dotplot_analysis/
sbatch $Progdir/minimap.sh $Genome1 $Genome2 $Outdir



#Create the dot plot 
paf_file=/projects/fusarium_venenatum_miseq/genome_synteny/minimap.paf;
Outdir=/projects/fusarium_venenatum_miseq/genome_synteny/
Progdir=/home/connellj/git_repos/emr_repos/Fv_C-variants/Dotplot_analysis/
sbatch $Progdir/create_dotplot.sh $paf_file $Outdir
