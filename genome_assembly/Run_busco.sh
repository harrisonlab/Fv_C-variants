  for Assembly in $(ls ../../projects/oldhome/connellj/miseq/c_variant_sequencing/2019/qc_dna/paired/fusarium_venenatum/c-varient/assembly/spades/c9/fusarium_venenatum/c-varient/filtered_contigs/filtered/repeat_masked/busco_analysis/filtered_contigs_contigs_unmasked.fa); do
    Strain=C9
    Organism=F.venenatum
    echo "$Organism - $Strain"
    ProgDir=/home/gomeza/git_repos/scripts/bioinformatics_tools/Gene_prediction
    BuscoDB=$(ls -d /projects/dbBusco/sordariomycetes_odb10)
    OutDir=/home/connellj/busco
    sbatch $ProgDir/busco.sh $Assembly $BuscoDB $OutDir
  done

