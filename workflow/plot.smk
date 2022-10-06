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

REF_SAMPLES = ['Sp_3dpf', 'Sp_2.75-28hpf', 'Sp_48_72hpf', 'Sp_Adult']

DBS = ['hpbase', 'echinobase']

rule all:
    input:
        expand('plot/{r}/dimplot_rsample.png',
            r=REF_SAMPLES),
        expand('plot/{q}/{r}.png',
            q=QRY_SAMPLES, r=REF_SAMPLES),
        expand('plot/integrated/{r}_{db}.png',
            r=REF_SAMPLES, db=DBS)

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
    wildcard_constraints:
        q='|'.join([re.escape(x) for x in QRY_SAMPLES])
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/dimplot_labeltransfer_{q}_{r}.txt'
    log:
        'logs/dimplot_labeltransfer_{q}_{r}.log'
    shell:
        'src/dimplot_labeltransfer.sh {input} {output} >& {log}'

def aggregate_qsample(r):
    print(r)
    out = []
    for j in range(len(QRY_SAMPLES)):
        out.append('output/' + QRY_SAMPLES[j] + '_vs_' + r[0] + '/predictions.RData')
    return(out)

rule dimplot_labeltransfer_integrated:
    input:
        aggregate_qsample
    output:
        'plot/integrated/{r}_{db}.png'
    wildcard_constraints:
        r='|'.join([re.escape(x) for x in REF_SAMPLES]),
        db='|'.join([re.escape(x) for x in DBS])
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/dimplot_labeltransfer_integrated_{r}_{db}.txt'
    log:
        'logs/dimplot_labeltransfer_integrated_{r}_{db}.log'
    shell:
        'src/dimplot_labeltransfer_integrated.sh {wildcards.db} {wildcards.r} {output} >& {log}'
