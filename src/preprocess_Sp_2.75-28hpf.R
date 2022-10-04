source("src/Functions.R")

# Parameter
outfile <- commandArgs(trailingOnly=TRUE)[1]

# Loading
seurat.obj <- readRDS("data/Sp_2.75-28hpf/GSE149221_SpInteg.rds")

# Cluster ID => Cell type
seurat.obj <- RenameIdents(seurat.obj,
    '0' = 'Aboral_ectoderm',
    '1' = 'Oral_ectoderm1',
    '2' = 'Ciliated_cells1',
    '3' = 'Neural1',
    '4' = 'Oral_ectoderm2',
    '5' = 'Aboral_ectoderm_neural',
    '6' = 'Endoderm1',
    '7' = 'Ciliated_cells2',
    '8' = 'Endoderm2',
    '9' = 'Neural2',
    '10' = 'H2A21',
    '11' = 'Pigment_cells',
    '12' = 'Oral_ectoderm3',
    '13' = 'Oral_ectoderm4',
    '14' = 'Endoderm3',
    '15' = 'Vault_protein',
    '16' = 'Skeleton1',
    '17' = 'Neural3',
    '18' = 'Neural4',
    '19' = 'Skeleton2',
    '20' = 'Germline',
    '21' = 'Fourcells_LG')

# Save
save(seurat.obj, file=outfile)
