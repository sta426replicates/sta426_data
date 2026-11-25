# sta425_data

Omnibenchmark **data** module for the STA425 replicate benchmark.

Loads the Schurch et al. (2016) *S. cerevisiae* wild-type vs *Δsnf2* RNA-seq count
matrix from the Bioconductor package
[HighlyReplicatedRNASeq](https://bioconductor.org/packages/HighlyReplicatedRNASeq)
(`Schurch16()`, ExperimentHub record EH3315; source
[bartongroup/profDGE48](https://github.com/bartongroup/profDGE48)).
The package ships 7,126 genes × 86 samples.

## Interface

```
run.R --output_dir DIR --name ID
```

| Output | Format |
|---|---|
| `counts.tsv.gz` | tab-separated; first column `gene`, then one column per sample; raw integer counts |
| `coldata.tsv` | tab-separated; `sample`, `condition` (`WT` or `snf2`), `replicate` |

The data are downloaded from ExperimentHub on first use and cached, so the first
run needs network access.

## Environment

R with `HighlyReplicatedRNASeq`, `SummarizedExperiment` and `optparse`
(`envs/r_data.yaml` in the benchmark repository).
