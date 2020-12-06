#Whole genome alignment tool
# this can be used to look for variants between genome or to look for sequence similiarity between genomes, look for ANI % in slurm out file 

prefix=WT_vs_kim
Genone1=/projects/fusarium_venenatum_miseq/genomes/WT/WT_contigs_unmasked.fa
Genone2=/projects/fusarium_venenatum_miseq/comparing_refs/vs_kim_geno/Kim_venenatum_genome/Fusarium_venenatum_kim_genome.fa
Outdir=/projects/fusarium_venenatum_miseq/comparing_refs/vs_kim_geno
Progdir=/home/connellj/
sbatch $Progdir/gsa_align.sh $Genone1 $Genone2 $prefix $Outdir

prefix=WT_vs_jgi
Genone1=/projects/fusarium_venenatum_miseq/genomes/WT/WT_contigs_unmasked.fa
Genone2=/projects/fusarium_venenatum_miseq/comparing_refs/jgi_ven_geno/JGI_venenatum_genome.fasta
Outdir=/projects/fusarium_venenatum_miseq/comparing_refs/jgi_ven_geno
Progdir=/home/connellj
sbatch $Progdir/gsa_align.sh $Genone1 $Genone2 $prefix $Outdir