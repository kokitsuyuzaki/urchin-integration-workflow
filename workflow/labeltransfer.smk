import pandas as pd
from snakemake.utils import min_version

#
# Setting
#
min_version("7.1.0")
container: 'docker://koki/urchin_workflow_seurat:20221004'

QRY_SAMPLES = ['SeaUrchin-scRNA-01', 'SeaUrchin-scRNA-02', 'SeaUrchin-scRNA-03',
    'SeaUrchin-scRNA-04', 'SeaUrchin-scRNA-05', 'SeaUrchin-scRNA-06',
    'SeaUrchin-scRNA-07', 'SeaUrchin-scRNA-08']
REF_SAMPLES = ['Sp_3dpf', 'Sp_2.75-28hpf', 'Sp_48_72hpf']

rule all:
    input:
        expand('output/{q}_vs_{r}/predictions.RData',
            q=QRY_SAMPLES, r=REF_SAMPLES)

rule labeltransfer2:
    input:
        '../urchin-workflow2/output/echinobase/{q}/seurat_lt.RData',
        'data/{r}/seurat.RData'
    output:
        'output/{q}_vs_{r}/predictions.RData'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/labeltransfer_{q}_{r}.txt'
    log:
        'logs/labeltransfer_{q}_{r}.log'
    shell:
        'src/labeltransfer.sh {input} {output} >& {log}'
