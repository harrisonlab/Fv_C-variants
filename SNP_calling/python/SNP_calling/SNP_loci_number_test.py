 qlogin 
 -pe smp 24
 -l virtual_free=1.25G
 -l h=blacklace01.blacklace|blacklace02.blacklace|blacklace04.blacklace|blacklace05.blacklace|blacklace06.blacklace|blacklace07.blacklace|blacklace08.blacklace|blacklace09.blacklace|blacklace10.blacklace|blacklace12.blacklace

## Satsuma Fv illumina vs Minion genome scaffold

$ ./Satsuma

Python

-q<string> : "/home/connellj/Illumina/local_assembley/WT_contigs_unmasked.fa"
-t<string> : "/home/connellj/MINion/local_assembley/WT_albacore_v2_contigs_unmasked.fa" 
-o<string> : "/data/scratch/connellj/illumina_minion_alignment"
-l<int> : =0
-t_chunk<int> : =4096
-q_chunk<int> : =4096
-n<int> : =1
-lsf<bool> : =0
-nosubmit<bool> : =0
-nowait<bool> : =0
-chain_only<bool> : =0
-refine_only<bool> : =0
-min_prob<double> : =0.99999
-proteins<bool> : =0
-cutoff<double> : =1.8
-same_only<bool> : =0
-self<bool> : =0



-q<string> : query fasta sequence
-t<string> : target fasta sequence
-o<string> : output directory
-l<int> : minimum alignment length (def=0)
-t_chunk<int> : target chunk size (def=4096)
-q_chunk<int> : query chunk size (def=4096)
-n<int> : number of blocks (def=1)
-lsf<bool> : submit jobs to LSF (def=0)
-nosubmit<bool> : do not run jobs (def=0)
-nowait<bool> : do not wait for jobs (def=0)
-chain_only<bool> : only chain the matches (def=0)
-refine_only<bool> : only refine the matches (def=0)
-min_prob<double> : minimum probability to keep match (def=0.99999)
-proteins<bool> : align in protein space (def=0)
-cutoff<double> : signal cutoff (def=1.8)
-same_only<bool> : only align sequences that have the same name. (def=0)
-self<bool> : ignore self-matches. (def=0)