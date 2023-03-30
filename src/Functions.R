library("Seurat")
library("SeuratObject")
library("xlsx")
library("scTGIF")

qsamples = c('SeaUrchin-scRNA-01', 'SeaUrchin-scRNA-02', 'SeaUrchin-scRNA-03',
    'SeaUrchin-scRNA-04', 'SeaUrchin-scRNA-05', 'SeaUrchin-scRNA-06',
    'SeaUrchin-scRNA-07', 'SeaUrchin-scRNA-08')

qsamples2 = c('cont-24h', 'cont-36h', 'cont-48h', 'cont-72h', 'cont-96h', 'DAPT-24h', 'DAPT-36h', 'DAPT-48h', 'DAPT-72h', 'DAPT-96h')

.colorList <- list(
"Sp_2.75-28hpf" = c(
    'Aboral_ectoderm' = rgb(0/255, 180/255, 200/255),
    'Oral_ectoderm1' = rgb(255/255, 255/255, 0/255),
    'Ciliated_cells1' = rgb(0/255, 120/255, 120/255),
    'Neural1' = rgb(0/255, 120/255, 120/255),
    'Oral_ectoderm2' = rgb(255/255, 255/255, 0/255),
    'Aboral_ectoderm_neural' = rgb(0/255, 120/255, 120/255),
    'Endoderm1' = rgb(127/255, 127/255, 255/255),
    'Ciliated_cells2' = rgb(0/255, 120/255, 120/255),
    'Endoderm2' = rgb(127/255, 127/255, 255/255),
    'Neural2' = rgb(255/255, 255/255, 0/255),
    'H2A21' = rgb(0.8, 0.8, 0.8),
    'Pigment_cells' = rgb(110/255, 0/255, 255/255),
    'Oral_ectoderm3' = rgb(255/255, 255/255, 0/255),
    'Oral_ectoderm4' = rgb(255/255, 255/255, 0/255),
    'Endoderm3' = rgb(127/255, 127/255, 255/255),
    'Vault_protein' = rgb(0.8, 0.8, 0.8),
    'Skeleton1' = rgb(255/255, 157/255, 0/255),
    'Neural3' = rgb(255/255, 255/255, 0/255),
    'Neural4' = rgb(255/255, 0/255, 255/255),
    'Skeleton2' = rgb(255/255, 157/255, 0/255),
    'Germline' = rgb(0.8, 0.8, 0.8),
    'Fourcells_LG' = rgb(0.8, 0.8, 0.8)
    ),
"Sp_48_72hpf" = c(
    'Ectoderm_uncharacterized' = rgb(0/255, 120/255, 120/255),
    'Apical_ectoderm' = rgb(0/255, 120/255, 120/255),
    'Differentiated_pigment_cells' = rgb(110/255, 0/255, 255/255),
    'Ciliary_band_neurons1' = rgb(0/255, 255/255, 38/255),
    'Apical_plate_uncharacterized' = rgb(0/255, 120/255, 120/255),
    'Oral_ectoderm_Mouth' = rgb(255/255, 125/255, 255/255),
    'Lateral_ectoderm_right' = rgb(237/255, 209/255, 177/255),
    'Ciliary_band_neurons2' = rgb(0/255, 255/255, 38/255),
    'Aboral_ectoderm1' = rgb(0/255, 180/255, 200/255),
    'Aboral_ectoderm2' = rgb(0/255, 180/255, 200/255),
    'Apical_plate_proneural' = rgb(255/255, 0/255, 255/255),
    'Skeleton' = rgb(255/255, 157/255, 0/255),
    'Mesodermal_cells' = rgb(89/255, 63/255, 127/255),
    'Mitotic_pigment_cells' = rgb(110/255, 0/255, 255/255),
    'Mid-gut' = rgb(127/255, 127/255, 255/255),
    'Serotoninergic_neurons_apical_plate1' = rgb(127/255, 0/255, 127/255),
    'Ciliary_band_neurons3' = rgb(255/255, 0/255, 255/255),
    'Serotoninergic_neurons_apical_plate2' = rgb(127/255, 0/255, 127/255)
    ),
"Sp_3dpf" = c(
    'Ciliary band' = rgb(0/255, 255/255, 38/255),
    'Apical plate' = rgb(255/255, 255/255, 0/255),
    'Aboral ectoderm' = rgb(0/255, 180/255, 200/255),
    'Lower oral ectoderm' = rgb(255/255, 255/255, 0/255),
    'Upper oral ectoderm' = rgb(255/255, 255/255, 0/255),
    'Neurons' = rgb(255/255, 0/255, 255/255),
    'Esophageal muscles' = rgb(100/255, 0/255, 50/255),
    'Coelomic pouches' = rgb(100/255, 0/255, 100/255),
    'Immune cells' = rgb(89/255, 63/255, 127/255),
    'Blastocoelar cells' = rgb(89/255, 63/255, 127/255),
    'Skeleton' = rgb(255/255, 157/255, 0/255),
    'Anus' = rgb(63/255, 63/255, 127/255),
    'Intestine' = rgb(127/255, 127/255, 255/255),
    'Pyloric sphincter' = rgb(0/255, 0/255, 100/255),
    'Stomach (1)' = rgb(0/255, 0/255, 255/255),
    'Stomach (2)' = rgb(0/255, 0/255, 255/255),
    'Stomach (3)' = rgb(0/255, 0/255, 255/255),
    'Exocrine pancreas-like' = rgb(0/255, 255/255, 153/255),
    'Cardiac sphincter' = rgb(150/255, 200/255, 200/255),
    'Esophagus' = rgb(200/255, 150/255, 150/255),
    'Undefined' = rgb(150/255, 150/255, 150/255)
    ),
"Sp_Adult" = c(
    'Endoderm' = rgb(127/255, 127/255, 255/255),
    'Aboral_ECD1' = rgb(0/255, 180/255, 200/255),
    'Aboral_ECD2' = rgb(0/255, 180/255, 200/255),
    'Pigment' = rgb(110/255, 0/255, 255/255),
    'Veg2+' = rgb(0.8, 0.8, 0.8),
    'Neuronal' = rgb(255/255, 255/255, 0/255),
    'LOC576614+' = rgb(0.8, 0.8, 0.8),
    'Skeleton' = rgb(255/255, 157/255, 0/255)
    )
)
