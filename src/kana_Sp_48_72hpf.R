source("src/Functions.R")

# Parameter
infile <- commandArgs(trailingOnly=TRUE)[1]
outfile <- commandArgs(trailingOnly=TRUE)[2]

# Loading
load(infile)

# Setting for kana
sce <- as.SingleCellExperiment(seurat.obj)
reducedDims(sce) <- SimpleList(tSNE=seurat.obj@reductions$tsne@cell.embeddings)
# counts(sce) <- NULL
altExp(sce) <- NULL

# Save
saveRDS(sce, file=outfile)
