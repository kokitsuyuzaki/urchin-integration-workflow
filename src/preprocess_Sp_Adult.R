source("src/Functions.R")

# Parameter
outfile <- commandArgs(trailingOnly=TRUE)[1]

# Loading
load("data/Sp_Adult/urchinOnly.RData")
seurat.obj <- urchinSeu
annotation <- read.delim("data/Sp_Adult/GCF_000002235.4_Spur_4.2_genomic.gtf", header=FALSE)

# Preprocessing
m1 <- regexpr("gene_id gene.*?;", annotation[,9])
gene_id <- substr(annotation[,9], m1, m1 + attr(m1, "match.length") - 1)
gene_id <- gsub("gene_id ", "", gene_id)
gene_id <- gsub(";", "", gene_id)

m2 <- regexpr("gene_name LOC.*?;", annotation[,9])
gene_name <- substr(annotation[,9], m2, m2 + attr(m2, "match.length") - 1)
gene_name <- gsub("gene_name ", "", gene_name)
gene_name <- gsub(";", "", gene_name)

# ID conversion
LtoR <- cbind(gene_id, gene_name)
LtoR <- unique(LtoR)
LtoR <- LtoR[which(LtoR[, 1] != ""), ]
LtoR <- LtoR[which(LtoR[, 2] != ""), ]

tmp <- convertRowID(
    input = as.matrix(seurat.obj@assays$RNA@counts),
    rowID = rownames(seurat.obj@assays$RNA@counts),
    LtoR = LtoR)

seurat.obj@assays$RNA@counts <- as(tmp$output, "sparseMatrix")
seurat.obj@assays$RNA@data <- as(tmp$output, "sparseMatrix")
seurat.obj <- NormalizeData(seurat.obj)
seurat.obj <- ScaleData(seurat.obj)

# Cluster ID => Cell type
seurat.obj <- RenameIdents(seurat.obj,
    '0' = 'Endoderm',
    '1' = 'Aboral_ECD1',
    '2' = 'Aboral_ECD2',
    '3' = 'Pigment',
    '4' = 'Veg2+',
    '5' = 'Neuronal',
    '6' = 'LOC576614+',
    '7' = 'Skeleton')

# Save
save(seurat.obj, file=outfile)
