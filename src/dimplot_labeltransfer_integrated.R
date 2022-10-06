source("src/Functions.R")

# Parameter
db <- commandArgs(trailingOnly=TRUE)[1]
rsample <- commandArgs(trailingOnly=TRUE)[2]
outfile <- commandArgs(trailingOnly=TRUE)[3]

# Loading
celltypes <- c()
for(i in seq_along(qsamples)){
	infile1 <- paste0("../urchin-workflow2/output/", db, "/", qsamples[i], "/seurat.RData")
	infile2 <- paste0("output/", qsamples[i], "_vs_", rsample, "/predictions.RData")
	load(infile1)
	load(infile2)
	# Assign Predicted Cell type
	seurat.obj <- AddMetaData(object=seurat.obj, metadata=predictions)
	celltypes <- c(celltypes, seurat.obj@meta.data$predicted.id)
}
infile3 <- paste0("../urchin-workflow2/output/", db, "/integrated/seurat.RData")
load(infile3)

seurat.integrated[["predicted.id"]] <- celltypes

# Plot
png(file=outfile, width=1200, height=600)
DimPlot(seurat.integrated, reduction="umap", group.by="predicted.id", split.by="sample", pt.size=2, label.size=6, ncol=4)
dev.off()
