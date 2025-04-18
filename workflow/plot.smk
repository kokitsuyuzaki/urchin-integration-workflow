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

REF_SAMPLES = ['Sp_2.75-28hpf', 'Sp_48_72hpf', 'Sp_Adult']

DBS = ['hpbase']

rule all:
    input:
        expand('plot/{r}/dimplot_rsample.png',
            r=REF_SAMPLES),
        # expand('plot/{q}/{r}.png',
        #     q=QRY_SAMPLES, r=REF_SAMPLES),
        expand('plot/{q2}/{r}.png',
            q2=QRY_SAMPLES2, r=REF_SAMPLES),
        expand('plot/{q2}/heatmap_{r}.png',
            q2=QRY_SAMPLES2, r=REF_SAMPLES),
        expand('plot/integrated/heatmap_{r}_{db}_2.png',
            r=REF_SAMPLES, db=DBS),
        # expand('plot/{q}/{r}_integration.png',
        #     q=QRY_SAMPLES, r=REF_SAMPLES),
        expand('plot/{q2}/{r}_integration.png',
            q2=QRY_SAMPLES2, r=REF_SAMPLES),
        # expand('plot/integrated/{r}_{db}.png',
        #     r=REF_SAMPLES, db=DBS),
        expand('plot/integrated/{r}_{db}_2.png',
            r=REF_SAMPLES, db=DBS)

rule dimplot_rsample:
    input:
        'data/{r}/seurat.RData'
    output:
        'plot/{r}/dimplot_rsample.png'
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/dimplot_rsample_{r}.txt'
    log:
        'logs/dimplot_rsample_{r}.log'
    shell:
        'src/dimplot_rsample.sh {wildcards.r} {input} {output} >& {log}'

rule dimplot_labeltransfer:
    input:
        'output/{q}_vs_{r}/predictions.RData',
        '../urchin-workflow2/output/hpbase/{q}/seurat.RData'
    output:
        'plot/{q}/{r}.png'
    wildcard_constraints:
        q='|'.join([re.escape(x) for x in QRY_SAMPLES])
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/dimplot_labeltransfer_{q}_{r}.txt'
    log:
        'logs/dimplot_labeltransfer_{q}_{r}.log'
    shell:
        'src/dimplot_labeltransfer.sh {wildcards.r} {input} {output} >& {log}'

rule dimplot_labeltransfer2:
    input:
        'output/{q2}_vs_{r}/predictions.RData',
        'data/hpbase/{q2}/seurat_annotated_lt.RData'
    output:
        'plot/{q2}/{r}.png'
    wildcard_constraints:
        q2='|'.join([re.escape(x) for x in QRY_SAMPLES2])
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/dimplot_labeltransfer_{q2}_{r}.txt'
    log:
        'logs/dimplot_labeltransfer_{q2}_{r}.log'
    shell:
        'src/dimplot_labeltransfer.sh {wildcards.r} {input} {output} >& {log}'

rule heatmap_labeltransfer2:
    input:
        'output/{q2}_vs_{r}/predictions.RData',
        'data/hpbase/{q2}/seurat_annotated_lt.RData'
    output:
        'plot/{q2}/heatmap_{r}.png'
    wildcard_constraints:
        q2='|'.join([re.escape(x) for x in QRY_SAMPLES2])
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/heatmap_labeltransfer_{q2}_{r}.txt'
    log:
        'logs/heatmap_labeltransfer_{q2}_{r}.log'
    shell:
        'src/heatmap_labeltransfer.sh {wildcards.r} {input} {output} >& {log}'

def aggregate_qsample(r):
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
        mem_mb=1000000
    benchmark:
        'benchmarks/dimplot_labeltransfer_integrated_{r}_{db}.txt'
    log:
        'logs/dimplot_labeltransfer_integrated_{r}_{db}.log'
    shell:
        'src/dimplot_labeltransfer_integrated.sh {wildcards.db} {wildcards.r} {output} >& {log}'

def aggregate_qsample2(r):
    out = []
    for j in range(len(QRY_SAMPLES2)):
        out.append('output/' + QRY_SAMPLES2[j] + '_vs_' + r[0] + '/predictions.RData')
    return(out)

rule dimplot_labeltransfer_integrated2:
    input:
        aggregate_qsample2
    output:
        'plot/integrated/{r}_{db}_2.png'
    wildcard_constraints:
        r='|'.join([re.escape(x) for x in REF_SAMPLES]),
        db='|'.join([re.escape(x) for x in DBS])
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/dimplot_labeltransfer_integrated2_{r}_{db}.txt'
    log:
        'logs/dimplot_labeltransfer_integrated2_{r}_{db}.log'
    shell:
        'src/dimplot_labeltransfer_integrated2.sh {wildcards.db} {wildcards.r} {output} >& {log}'

rule heatmap_labeltransfer_integrated2:
    input:
        aggregate_qsample2
    output:
        'plot/integrated/heatmap_{r}_{db}_2.png'
    wildcard_constraints:
        r='|'.join([re.escape(x) for x in REF_SAMPLES]),
        db='|'.join([re.escape(x) for x in DBS])
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/heatmap_labeltransfer_integrated2_{r}_{db}.txt'
    log:
        'logs/heatmap_labeltransfer_integrated2_{r}_{db}.log'
    shell:
        'src/heatmap_labeltransfer_integrated2.sh {wildcards.db} {wildcards.r} {output} >& {log}'

rule dimplot_integration:
    input:
        'output/{q}_vs_{r}/predictions.RData',
        'output/{q}_vs_{r}/seurat.RData',
        'data/echinobase/{q}/seurat_lt.RData',
        'data/{r}/seurat.RData'
    output:
        'plot/{q}/{r}_integration.png'
    wildcard_constraints:
        q='|'.join([re.escape(x) for x in QRY_SAMPLES])
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/dimplot_integration_{q}_{r}.txt'
    log:
        'logs/dimplot_integration_{q}_{r}.log'
    shell:
        'src/dimplot_integration.sh {wildcards.r} {input} {output} >& {log}'

rule dimplot_integration2:
    input:
        'output/{q2}_vs_{r}/predictions.RData',
        'output/{q2}_vs_{r}/seurat.RData',
        'data/echinobase/{q2}/seurat_lt.RData',
        'data/{r}/seurat.RData'
    output:
        'plot/{q2}/{r}_integration.png'
    wildcard_constraints:
        q2='|'.join([re.escape(x) for x in QRY_SAMPLES2])
    resources:
        mem_mb=1000000
    benchmark:
        'benchmarks/dimplot_integration_{q2}_{r}.txt'
    log:
        'logs/dimplot_integration_{q2}_{r}.log'
    shell:
        'src/dimplot_integration.sh {wildcards.r} {input} {output} >& {log}'
