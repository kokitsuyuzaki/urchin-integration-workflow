# urchin-integration-workflow
Snakemake workflow to integrate multiple single-cell RNA-seq dataset of sea urchin.

This workflow consists of four workflows as follows:

- **workflow/download.smk**: Data downloading

![](https://github.com/kokitsuyuzaki/urchin-integration-workflow/blob/main/plot/download.png?raw=true)

- **workflow/preprocess.smk**: Data preprocessing

![](https://github.com/kokitsuyuzaki/urchin-integration-workflow/blob/main/plot/preprocess.png?raw=true)

- **workflow/labeltransfer.smk**: Transfer label of reference to query

![](https://github.com/kokitsuyuzaki/urchin-integration-workflow/blob/main/plot/labeltransfer.png?raw=true)

- **workflow/integration.smk**: Integration of reference and query

![](https://github.com/kokitsuyuzaki/urchin-integration-workflow/blob/main/plot/integration.png?raw=true)

- **workflow/plot.smk**: Plots cells with transfered label

![](https://github.com/kokitsuyuzaki/urchin-integration-workflow/blob/main/plot/plot.png?raw=true)

## Requirements
- Bash: GNU bash, version 4.2.46(1)-release (x86_64-redhat-linux-gnu)
- Snakemake: 6.5.3
- Singularity: 3.8.0

## How to reproduce this workflow
### In Local Machine

```
snakemake -s workflow/download.smk -j 4 --use-singularity
snakemake -s workflow/preprocess.smk -j 4 --use-singularity
snakemake -s workflow/labeltransfer.smk -j 4 --use-singularity
snakemake -s workflow/integration.smk -j 4 --use-singularity
snakemake -s workflow/plot.smk -j 4 --use-singularity
```

### In Open Grid Engine

```
snakemake -s workflow/download.smk -j 32 --cluster qsub --latency-wait 600 --use-singularity
snakemake -s workflow/preprocess.smk -j 32 --cluster qsub --latency-wait 600 --use-singularity
snakemake -s workflow/labeltransfer.smk -j 32 --cluster qsub --latency-wait 600 --use-singularity
snakemake -s workflow/integration.smk -j 32 --cluster qsub --latency-wait 600 --use-singularity
snakemake -s workflow/plot.smk -j 32 --cluster qsub --latency-wait 600 --use-singularity
```

### In Slurm

```
snakemake -s workflow/download.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
snakemake -s workflow/preprocess.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
snakemake -s workflow/labeltransfer.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
snakemake -s workflow/integration.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
snakemake -s workflow/plot.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
```

## License
Copyright (c) 2022 Koki Tsuyuzaki released under the [Artistic License 2.0](http://www.perlfoundation.org/artistic_license_2_0).

## Authors
- Koki Tsuyuzaki
- Shunsuke Yaguchi