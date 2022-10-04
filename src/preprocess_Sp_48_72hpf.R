source("src/Functions.R")

# Parameter
outfile <- commandArgs(trailingOnly=TRUE)[1]

# Loading
seurat.obj <- readRDS("data/Sp_48_72hpf/GSE155427_Sp48and72.rds")

# Cluster ID => Cell type
seurat.obj <- RenameIdents(seurat.obj,
    '0' = 'Ectoderm_uncharacterized',
    '1' = 'Apical_ectoderm',
    '2' = 'Differentiated_pigment_cells',
    '3' = 'Ciliary_band_neurons1',
    '4' = 'Apical_plate_uncharacterized',
    '5' = 'Oral_ectoderm_Mouth',
    '6' = 'Lateral_ectoderm_right',
    '7' = 'Ciliary_band_neurons2',
    '8' = 'Aboral_ectoderm1',
    '9' = 'Aboral_ectoderm2',
    '10' = 'Apical_plate_proneural',
    '11' = 'Skeleton',
    '12' = 'Mesodermal_cells',
    '13' = 'Mitotic_pigment_cells',
    '14' = 'Mid-gut',
    '15' = 'Serotoninergic_neurons_apical_plate1',
    '16' = 'Ciliary_band_neurons3',
    '17' = 'Serotoninergic_neurons_apical_plate2')

# Save
save(seurat.obj, file=outfile)
