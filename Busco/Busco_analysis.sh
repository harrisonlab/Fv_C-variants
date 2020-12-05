


export PATH="/home/connellj/miniconda2/pkgs/augustus-3.1-0/bin:$PATH"
export PATH="/home/connellj/miniconda2/pkgs/augustus-3.1-0/scripts:$PATH"
export PATH="/home/connellj/miniconda2/pkgs/augustus-3.1-0/config:$PATH"




 for Assembly in $(ls /projects/fusarium_venenatum_miseq/genome_assemblys/C9/C9_contigs_unmasked.fa); do
    Strain=$(echo $Assembly| rev | cut -d '/' -f1 | rev)
    Organism=$(echo $Assembly | rev | cut -d '/' -f4 | rev)
    echo "$Organism - $Strain"
    ProgDir=/home/connellj/git_repos/emr_repos/Fv_C-variants/Busco
    BuscoDB=$(ls -d /projects/dbBusco/sordariomycetes_odb10)
    OutDir=/projects/fusarium_venenatum_miseq/genome_assembly/C9
    sbatch $ProgDir/run_busco.sh $Assembly $BuscoDB $OutDir
  done




  for Assembly in $(ls /projects/fusarium_venenatum_miseq/genome_assemblys/C15/C15_contigs_unmasked.fa); do
    Strain=$(echo $Assembly| rev | cut -d '/' -f1 | rev)
    Organism=$(echo $Assembly | rev | cut -d '/' -f4 | rev)
    echo "$Organism - $Strain"
    ProgDir=/home/connellj/git_repos/emr_repos/Fv_C-variants/Busco
    BuscoDB=$(ls -d /projects/dbBusco/sordariomycetes_odb10)
    OutDir=/projects/fusarium_venenatum_miseq/genome_assembly/C15
    sbatch $ProgDir/run_busco.sh $Assembly $BuscoDB $OutDir
  done

