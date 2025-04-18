source("src/Functions.R")

# Parameter
infile1 <- commandArgs(trailingOnly=TRUE)[1]
infile2 <- commandArgs(trailingOnly=TRUE)[2]
outfile <- commandArgs(trailingOnly=TRUE)[3]

# Loading
load(infile1)
q.seurat.obj <- seurat.obj
load(infile2)
r.seurat.obj <- seurat.obj

# Label Transer
DefaultAssay(q.seurat.obj) <- "RNA"
DefaultAssay(r.seurat.obj) <- "RNA"
common_features <- intersect(rownames(q.seurat.obj), rownames((r.seurat.obj)))
anchors <- FindTransferAnchors(reference = r.seurat.obj, query = q.seurat.obj,
    dims=1:30,
    features = common_features)

# Label Prediction
predictions <- TransferData(anchorset = anchors, refdata = Idents(r.seurat.obj), dims = 1:30, k.weight=20)

# Save
save(predictions, file=outfile)
