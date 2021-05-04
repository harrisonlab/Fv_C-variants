# Script to reduce the number of contigs in a genome assembly 


reference_genome=/projects/botrytis_cinerea/External_group/renamed/GCF_000143535.2_ASM14353v4_genomic.fasta
query_genome=/projects/botrytis_cinerea/External_group/sl9/renamed/JACVFN01.1.fasta
Outdir=/projects/botrytis_cinerea/ragtag_output
mkdir -p $Outdir
progdir=/home/bourquif/git_repos/scripts/genome_correction
sbatch $progdir/ragtag.sh $reference_genome $query_genome $Outdir











ln -s /projects/fusarium_venenatum_miseq/genome_assemblys/C9/C9_contigs_unmasked.fa
ln -s /projects/fusarium_venenatum_miseq/genomes/WT/WT_contigs_unmasked.fa
#ln -s /projects/ensa/frankia/baiting_nodules/Soil4B/Soil4B.fastq


python /home/pricej/programs/RaGOO/ragoo.py -T corr -t 8 C9_contigs_unmasked.fa WT_contigs_unmasked.fa







  ProgDir=$(ls -d /home/connellj/git_repos/emr_repos/Fv_C-variants/genome_assembly)
  touch tmp.csv
  for Assembly in $(ls /home/connellj/ragoo_output/ragoo.fasta); do  
    OutDir=/home/connellj/ragoo_output
    $ProgDir/python_rename_contigs.py --inp $Assembly --out $OutDir/C9_ragoo.fasta --coord_file tmp.csv
  done
  rm tmp.csv


















cd /ensa/frankia/baiting_nodules/Soil4B/RaGOO/
ln -s /projects/ensa/frankia/baiting_nodules/Dg1.fasta
ln -s /projects/ensa/frankia/baiting_nodules/Soil4B/flye/assembly.fasta
#ln -s /projects/ensa/frankia/baiting_nodules/Soil4B/Soil4B.fastq


python /home/pricej/programs/RaGOO/ragoo.py -R Soil4B.fastq -T corr -t 8 assembly.fasta Dg1.fasta

