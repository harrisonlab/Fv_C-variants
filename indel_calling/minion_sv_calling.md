Structural variant discovery minion 


 lumpy and svaba are specifically geared toward identifying indels and structural variants and uses more lines of evidence that gatk. Also, GATK will detect only small indels, whereas lumpy can detect bigger structural variants.


```bash
CurDir=$PWD
Reference=$(ls ../../../home/groups/harrisonlab/project_files/fusarium_venenatum/repeat_masked/F.venenatum/WT_minion/minion_submission/WT_albacore_v2_contigs_unmasked.fa)
for StrainPath in $(ls -d ../../../home/groups/harrisonlab/project_files/fusarium_venenatum/qc_dna/paired/F.venenatum/* | grep -v 'strain1'| grep -v 'WT'); do
  Strain=$(echo $StrainPath | rev | cut -f1 -d '/' | rev)
  Organism=$(echo $StrainPath | rev | cut -f2 -d '/' | rev)
  echo $Strain
  echo $Organism
    ReadsF=$(ls $StrainPath/F/*fq.gz)
    ReadsR=$(ls $StrainPath/R/*fq.gz)
    ConcatTmpDir=tmp_concat_dir
    mkdir -p $ConcatTmpDir
    ConcatF=$ConcatTmpDir/"$Strain"_F_reads.fq.gz
    ConcatR=$ConcatTmpDir/"$Strain"_R_reads.fq.gz
    cat $ReadsF > $ConcatF
    cat $ReadsR > $ConcatR
    OutDir=Fusarium_venenatum/MINion_indel_calling
    ProgDir=../../../home/armita/git_repos/emr_repos/scripts/phytophthora/Pcac_popgen
    qsub $ProgDir/sub_prep_lumpy.sh $Strain $CurDir/$Reference $ConcatF $ConcatR $OutDir
done
```
Prefix=Fven_svaba
  Reference=$(ls ../../../home/groups/harrisonlab/project_files/fusarium_venenatum/repeat_masked/F.venenatum/WT_minion/minion_submission/WT_albacore_v2_contigs_unmasked.fa)
  AlignDir=/Fusarium_venenatum/MINion_indel_calling
  OutDir=/Fusarium_venenatum/MINion_indel_calling/svaba
  ProgDir=../../../home/armita/git_repos/emr_repos/scripts/phytophthora/Pcac_popgen
  qsub $ProgDir/sub_svaba.sh $Prefix $Reference $AlignDir $OutDir

Filter vcf files to remove low quality calls. (Just completed above)
Only retain biallelic high-quality SNPS with no missing data (for any individual) for genetic analyses below (in some cases, may allow some missing data in order to retain more SNPs, or first remove poorly sequenced individuals with too much missing data and then filter the SNPs).


```bash
# cp analysis/popgen/Fv_indel_calling/svaba/Fven_svaba_sv.svaba.unfiltered.indel.vcf analysis/popgen/Fv_indel_calling/svaba/Fven_svaba_sv.svaba.filtered.indel.vcf
for Vcf in $(ls analysis/popgen/Fv_indel_calling/svaba/Fven_svaba_sv.svaba.*.vcf | grep -v -e 'unfiltered' -e 'filtered' -e 'no_errors'); do
ProgDir=/home/armita/git_repos/emr_repos/scripts/phytophthora/Pcac_popgen
qsub $ProgDir/sub_vcf_parser_only_indels.sh $Vcf 40 30 10 30 1
done
```
