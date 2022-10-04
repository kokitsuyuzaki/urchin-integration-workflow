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
        expand('plot/{r}/dimplot_rsample.png',
            r=REF_SAMPLES),
        expand('plot/{q}/{r}.png', q=QRY_SAMPLES, r=REF_SAMPLES)

rule dimplot_rsample:
    input:
        'data/{r}/seurat.RData'
    output:
        'plot/{r}/dimplot_rsample.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/dimplot_rsample_{r}.txt'
    log:
        'logs/dimplot_rsample_{r}.log'
    shell:
        'src/dimplot_rsample.sh {input} {output} >& {log}'

rule dimplot_labeltransfer:
    input:
        'output/{q}_vs_{r}/predictions.RData',
        '../urchin-workflow2/output/hpbase/{q}/seurat.RData'
    output:
        'plot/{q}/{r}.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/dimplot_labeltransfer_{q}_{r}.txt'
    log:
        'logs/dimplot_labeltransfer_{q}_{r}.log'
    shell:
        'src/dimplot_labeltransfer.sh {input} {output} >& {log}'

