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

QRY_SAMPLES2 = ['cont-24h', 'cont-36h', 'cont-48h', 'cont-72h', 'cont-96h', 'DAPT-24h', 'DAPT-36h', 'DAPT-48h', 'DAPT-72h', 'DAPT-96h']

REF_SAMPLES = ['Sp_3dpf', 'Sp_2.75-28hpf', 'Sp_48_72hpf', 'Sp_Adult']

rule all:
    input:
        expand('output/{q}_vs_{r}/predictions.RData',
            q=QRY_SAMPLES, r=REF_SAMPLES),
        expand('output/{q2}_vs_{r}/predictions.RData',
            q2=QRY_SAMPLES2, r=REF_SAMPLES)

rule labeltransfer:
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

rule labeltransfer2:
    input:
        '../urchin-workflow3/output/echinobase/{q2}/seurat_lt.RData',
        'data/{r}/seurat.RData'
    output:
        'output/{q2}_vs_{r}/predictions.RData'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/labeltransfer_{q2}_{r}.txt'
    log:
        'logs/labeltransfer_{q2}_{r}.log'
    shell:
        'src/labeltransfer.sh {input} {output} >& {log}'
