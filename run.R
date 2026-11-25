#!/usr/bin/env Rscript
# Data stage: Schurch et al. (2016) S. cerevisiae WT vs snf2 counts.
#
# Source: Bioconductor HighlyReplicatedRNASeq::Schurch16() (ExperimentHub EH3315),
# built from https://github.com/bartongroup/profDGE48.
#
# Outputs (in --output_dir):
#   counts.tsv.gz  first column `gene`, then one column per sample; raw integer counts
#   coldata.tsv    sample, condition (WT | snf2), replicate

suppressPackageStartupMessages({
  library(optparse)
  library(SummarizedExperiment)
  library(HighlyReplicatedRNASeq)
})

opt <- parse_args(OptionParser(option_list = list(
  make_option("--output_dir", type = "character", help = "Output directory"),
  make_option("--name", type = "character", default = "schurch2016", help = "Module id")
)))
stopifnot(!is.null(opt$output_dir))
dir.create(opt$output_dir, recursive = TRUE, showWarnings = FALSE)

se <- HighlyReplicatedRNASeq::Schurch16()
counts <- assay(se, "counts")
samples <- colnames(counts)

# Sample names are `wildtype_NN` / `knockout_NN`.
condition <- ifelse(grepl("^wildtype", samples), "WT",
             ifelse(grepl("^knockout", samples), "snf2", NA))
if (anyNA(condition)) {
  stop("Unrecognised sample names: ", paste(samples[is.na(condition)], collapse = ", "))
}
replicate <- as.integer(sub(".*_", "", samples))

if (any(counts < 0) || any(counts != round(counts))) stop("Counts are not non-negative integers")
storage.mode(counts) <- "integer"

coldata <- data.frame(sample = samples, condition = condition, replicate = replicate)

con <- gzfile(file.path(opt$output_dir, "counts.tsv.gz"), "w")
write.table(data.frame(gene = rownames(counts), counts, check.names = FALSE),
            con, sep = "\t", quote = FALSE, row.names = FALSE)
close(con)
write.table(coldata, file.path(opt$output_dir, "coldata.tsv"),
            sep = "\t", quote = FALSE, row.names = FALSE)

message(sprintf("%s: %d genes, %d WT + %d snf2 samples",
                opt$name, nrow(counts), sum(condition == "WT"), sum(condition == "snf2")))
