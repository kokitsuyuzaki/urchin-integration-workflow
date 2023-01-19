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

# Integration
seurat.list <- list(q.seurat.obj, r.seurat.obj)
common_features <- intersect(rownames(q.seurat.obj), rownames((r.seurat.obj)))
anchors <- FindIntegrationAnchors(object.list = seurat.list,
    anchor.features = common_features)
seurat.combined <- IntegrateData(anchorset = anchors)
DefaultAssay(seurat.combined) <- "integrated"

# SCTransform
seurat.combined <- SCTransform(seurat.combined)

# Dimension Reduction
seurat.combined <- RunPCA(seurat.combined)
seurat.combined <- RunUMAP(seurat.combined, dims=1:30)

# Group
group_names <- c("Query", "Reference")
seurat.combined@meta.data$sample <- unlist(lapply(seq_along(seurat.list),
    function(x){
        rep(group_names[x], length=ncol(seurat.list[[x]]))
    }))

# Save
save(seurat.combined, file=outfile)
