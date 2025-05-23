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

# SCTransform
q.seurat.obj <- SCTransform(q.seurat.obj, assay = "RNA")
r.seurat.obj <- SCTransform(r.seurat.obj, assay = "RNA")

# Label Transer
common_features <- intersect(rownames(q.seurat.obj), rownames((r.seurat.obj)))
anchors <- FindTransferAnchors(reference = r.seurat.obj, query = q.seurat.obj,
    dims=1:30,
    features = common_features)

# Label Prediction
predictions <- TransferData(anchorset = anchors, refdata = Idents(r.seurat.obj), dims = 1:30, k.weight=20)

# Save
save(predictions, file=outfile)
