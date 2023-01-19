source("src/Functions.R")

# Parameter
rsample <- commandArgs(trailingOnly=TRUE)[1]
infile1 <- commandArgs(trailingOnly=TRUE)[2]
infile2 <- commandArgs(trailingOnly=TRUE)[3]
infile3 <- commandArgs(trailingOnly=TRUE)[4]
infile4 <- commandArgs(trailingOnly=TRUE)[5]
outfile <- commandArgs(trailingOnly=TRUE)[6]

# Loading
load(infile1) # predictions
load(infile2) # seurat.combined
load(infile3)
q.seurat.obj <- seurat.obj
load(infile4)
r.seurat.obj <- seurat.obj

# Color map of reference sample
cols <- .colorList[[rsample]]

# Assign Predicted Cell type
q.seurat.obj <- AddMetaData(object=q.seurat.obj, metadata=predictions)
seurat.combined@meta.data[["combined.id"]] <- c(unlist(q.seurat.obj[["predicted.id"]]), as.character(Idents(r.seurat.obj)))

# Plot
png(file=outfile, width=1200, height=600)
p1 <- DimPlot(seurat.combined, reduction = "umap", group.by="sample", label=TRUE, pt.size=2, label.size=6)
p2 <- DimPlot(seurat.combined, reduction="umap", group.by="combined.id", pt.size=2, label.size=6, cols=cols)
p1 + p2
dev.off()
