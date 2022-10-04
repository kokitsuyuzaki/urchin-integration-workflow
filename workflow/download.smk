import pandas as pd
from snakemake.utils import min_version

#
# Setting
#
min_version("7.1.0")
container: 'docker://koki/urchin_workflow_seurat:20221004'

SAMPLES = ['Sp_2.75-28hpf', 'Sp_48_72hpf']

rule all:
    input:
        expand('data/{sample}/DOWNLOADED', sample=SAMPLES)

rule download:
    output:
        'data/{sample}/DOWNLOADED'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/download_{sample}.txt'
    log:
        'logs/download_{sample}.log'
    shell:
        'src/download_{wildcards.sample}.sh >& {log}'

