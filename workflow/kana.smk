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
        expand('data/{sample}/{sample}.rds', sample=SAMPLES)

rule kana_sample:
    input:
        'data/{sample}/seurat.RData'
    output:
        'data/{sample}/{sample}.rds'
    wildcard_constraints:
        sample='|'.join([re.escape(x) for x in SAMPLES])
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/kana_{sample}.txt'
    log:
        'logs/kana_{sample}.log'
    shell:
        'src/kana_{wildcards.sample}.sh {input} {output} >& {log}'
