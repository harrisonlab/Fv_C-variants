#!/usr/bin/env Rscript


# R script for analysing a file of abundance of kmers.
# The input file should be a single column of abundance values.
# This script will produce a histogram of kmer abundance, a distribution plot
# and generate summary statistics.

args<-commandArgs(TRUE)

cat("Usage: R_kmer_plots.r <infile> <outfile>\n");
infile <- toString(args[1]);
outfile <- args[2];
cat("Supplied infile is: ", infile, "\n")
hist_out <- paste(outfile, "_hist_log.pdf", sep = "")
density_out <- paste(outfile, "_dist.pdf", sep = "")
summary_out <- paste(outfile, "_summary.txt", sep = "")
cat("Outfiles will be named:\n")
cat(hist_out, "\n", density_out, "\n", summary_out, "\n")

# options(download.file.method = "wget")
# install.packages("ggplot2")
library(ggplot2)

data1 <- read.delim(file=infile, header=F, sep="\t")
attach(data1)
colnames(data1) <- c("kmer_abundance")

# pdf(hist_out)
# hist(data1$kmer_abundance)
# dev.off()

kmer_hist <- ggplot(data1, aes(data1$kmer_abundance)) +
  xlab("Kmer abundance") +
  ylab("Frequency of count") +
  geom_histogram(stat = "count") +
  scale_y_continuous(trans='log10', expand=c(0,0)) +
  scale_x_continuous(breaks=seq(1,max(data1$kmer_abundance),10), expand=c(0,0))
  #   scale_x_continuous(breaks=seq(1,max(data1$kmer_abundance),10), expand=c(0,0))
# scale_y_sqrt()

hist_out <- paste(outfile, "_hist_log.pdf", sep = "")
ggsave(hist_out, kmer_hist, dpi=300, height=8, width=12)


kmer_hist <- ggplot(data1, aes(data1$kmer_abundance)) +
  xlab("Kmer abundance") +
  ylab("Frequency of count") +
  geom_histogram(stat = "count") +
  scale_y_continuous(trans='log10', expand=c(0,0)) +
  scale_x_continuous(trans='log10', expand=c(0,0))
# scale_y_sqrt()

hist_out <- paste(outfile, "_hist_log-log.pdf", sep = "")
ggsave(hist_out, kmer_hist, dpi=300, height=8, width=12)


#d <- density(data1$kmer_abundance)
#pdf(density_out)
#plot(d)
#dev.off()

sink(summary_out)
summary(data1$kmer_abundance)
freq_tab <- table(as.vector(data1$kmer_abundance))
mode <- as.numeric(names(freq_tab) [freq_tab == max(freq_tab)])
cat("The mode kmer abundance is: ", mode, "\n")
total_kmers <- sum(as.numeric(data1$kmer_abundance))
cat("The total number of kmers counted is: ", total_kmers, "\n")
genome_sz <- total_kmers / mode
cat("The estimated genome size is: ", genome_sz, "\n")

subset <- subset(data1, kmer_abundance >= 11 & kmer_abundance < 1000, select=kmer_abundance)

freq_tab <- table(as.vector(subset$kmer_abundance))
mode <- as.numeric(names(freq_tab) [freq_tab == max(freq_tab)])
cat("The mode kmer abundance is: ", mode, "\n")

subset <- subset(data1, kmer_abundance >= 10, select=kmer_abundance)
total_kmers <- sum(as.numeric(subset$kmer_abundance))
cat("The total number of kmers counted is: ", total_kmers, "\n")
genome_sz <- total_kmers / mode
cat("The estimated genome size at a cutoff of 10 is: ", genome_sz, "\n")

subset <- subset(data1, kmer_abundance >= 11, select=kmer_abundance)
total_kmers <- sum(as.numeric(subset$kmer_abundance))
cat("The total number of kmers counted is: ", total_kmers, "\n")
genome_sz <- total_kmers / mode
cat("The estimated genome size at a cutoff of 11 is: ", genome_sz, "\n")

subset <- subset(data1, kmer_abundance >= 12, select=kmer_abundance)
total_kmers <- sum(as.numeric(subset$kmer_abundance))
cat("The total number of kmers counted is: ", total_kmers, "\n")
genome_sz <- total_kmers / mode
cat("The estimated genome size at a cutoff of 12 is: ", genome_sz, "\n")

subset <- subset(data1, kmer_abundance >= 13, select=kmer_abundance)
total_kmers <- sum(as.numeric(subset$kmer_abundance))
cat("The total number of kmers counted is: ", total_kmers, "\n")
genome_sz <- total_kmers / mode
cat("The estimated genome size at a cutoff of 13 is: ", genome_sz, "\n")

subset <- subset(data1, kmer_abundance >= 13 & kmer_abundance < 999, select=kmer_abundance)
total_kmers <- sum(as.numeric(subset$kmer_abundance))
cat("The total number of kmers counted is: ", total_kmers, "\n")
genome_sz <- total_kmers / mode
cat("The estimated genome size at a cutoff of 13 and less than 999 is: ", genome_sz, "\n")

sink()

kmer_hist <- ggplot(subset, aes(subset$kmer_abundance)) +
  xlab("Kmer abundance") +
  ylab("Frequency of count") +
  geom_histogram(stat = "count") +
  scale_y_continuous(expand=c(0,0)) +
  scale_x_continuous(breaks=seq(1,max(subset$kmer_abundance),10), expand=c(0,0))

hist_out <- paste(outfile, "_hist.pdf", sep = "")
ggsave(hist_out, kmer_hist, dpi=300, height=8, width=12)

q()
