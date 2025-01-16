import pandas as pd
from snakemake.utils import min_version

#
# Setting
#
min_version("7.1.0")
container: 'docker://koki/urchin_workflow_seurat:20221004'

SAMPLES = ['Sp_2.75-28hpf', 'Sp_48_72hpf', 'Sp_Adult']

rule all:
    input:
        expand('data/{sample}/seurat.RData', sample=SAMPLES)

rule preprocess:
    output:
        'data/{sample}/seurat.RData'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/preprocess_{sample}.txt'
    log:
        'logs/preprocess_{sample}.log'
    shell:
        'src/preprocess_{wildcards.sample}.sh {output} >& {log}'
