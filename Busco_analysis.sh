 
 for Assembly in $(ls /projects/fusarium_venenatum_miseq/genome_assemblys/C9/C9_contigs_unmasked.fa); do
    Strain=$(echo $Assembly| rev | cut -d '/' -f1 | rev)
    Organism=$(echo $Assembly | rev | cut -d '/' -f4 | rev)
    echo "$Organism - $Strain"
    ProgDir=/home/connellj/git_repos/emr_repos/Fv_C-variants/genome_assembly
    BuscoDB=$(ls -d /projects/oldhome/groups/harrisonlab/dbBusco/sordariomyceta_odb9)
    OutDir=/projects/fusarium_venenatum_miseq/genome_assembly/C9
    sbatch $ProgDir/busco.sh $Assembly $BuscoDB $OutDir
  done

  for Assembly in $(ls /projects/fusarium_venenatum_miseq/genome_assemblys/C15/C15_contigs_unmasked.fa); do
    Strain=$(echo $Assembly| rev | cut -d '/' -f1 | rev)
    Organism=$(echo $Assembly | rev | cut -d '/' -f4 | rev)
    echo "$Organism - $Strain"
    ProgDir=/home/connellj/git_repos/emr_repos/Fv_C-variants/genome_assembly
    BuscoDB=$(ls -d /projects/oldhome/groups/harrisonlab/dbBusco/sordariomyceta_odb9)
    OutDir=/projects/fusarium_venenatum_miseq/genome_assembly/C15
    sbatch $ProgDir/busco.sh $Assembly $BuscoDB $OutDir
  done