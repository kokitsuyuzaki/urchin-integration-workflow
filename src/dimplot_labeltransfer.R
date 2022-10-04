source("src/Functions.R")

# Parameter
infile1 <- commandArgs(trailingOnly=TRUE)[1]
infile2 <- commandArgs(trailingOnly=TRUE)[2]
outfile <- commandArgs(trailingOnly=TRUE)[3]

# Loading
load(infile1)
load(infile2)

# Assign Predicted Cell type
seurat.obj <- AddMetaData(object=seurat.obj, metadata=predictions)

# Plot
png(file=outfile, width=750, height=600)
DimPlot(seurat.obj, group.by="predicted.id", pt.size=2, label.size=6)
dev.off()
