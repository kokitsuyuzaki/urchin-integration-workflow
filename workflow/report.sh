# HTML
mkdir -p report
snakemake -s workflow/download.smk --report report/download.html
snakemake -s workflow/preprocess.smk --report report/preprocess.html
snakemake -s workflow/labeltransfer.smk --report report/labeltransfer.html
snakemake -s workflow/plot.smk --report report/plot.html

