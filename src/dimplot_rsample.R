source("src/Functions.R")

# Parameter
rsample <- commandArgs(trailingOnly=TRUE)[1]
infile <- commandArgs(trailingOnly=TRUE)[2]
outfile <- commandArgs(trailingOnly=TRUE)[3]

# Loading
load(infile)

# Color map of reference sample
cols <- .colorList[[rsample]]

# Plot
png(file=outfile, width=750, height=600)
DimPlot(seurat.obj, pt.size=2, label.size=6, cols=cols)
dev.off()
