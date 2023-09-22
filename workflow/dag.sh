# DAG graph
snakemake -s workflow/download.smk --rulegraph | dot -Tpng > plot/download.png
snakemake -s workflow/preprocess.smk --rulegraph | dot -Tpng > plot/preprocess.png
snakemake -s workflow/labeltransfer.smk --rulegraph | dot -Tpng > plot/labeltransfer.png
snakemake -s workflow/integration.smk --rulegraph | dot -Tpng > plot/integration.png
snakemake -s workflow/plot.smk --rulegraph | dot -Tpng > plot/plot.png
snakemake -s workflow/kana.smk --rulegraph | dot -Tpng > plot/kana.png
