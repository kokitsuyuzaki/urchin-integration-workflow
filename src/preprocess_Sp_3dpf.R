source("src/Functions.R")
source("https://raw.githubusercontent.com/vertesy/Seurat.utils/master/R/Seurat.Utils.R")

# Parameter
outfile <- commandArgs(trailingOnly=TRUE)[1]

# Loading
seurat.obj <- readRDS("data/Sp_3dpf/Sp3dpf_integratd_umap/sp72_integrated_umap_named.rds")
annotation <- read.xlsx("data/Sp_3dpf/Sp3dpf_integratd_umap/WHL_to_gene_name.xlsx", sheetIndex=1)

# Preprocessing
x <- annotation[,3]
m <- regexpr("\\(LOC.*\\)", x)
SPU_gene_id <- substr(x, m+1, m + attr(m, "match.length") - 2)

# WHL ID => Gene ID (LOC*)
whl_to_loc <- data.frame(WHLID = annotation[,1], LOCID=SPU_gene_id)
new.rownames <- unlist(lapply(rownames(seurat.obj), function(x){
    target <- which(whl_to_loc[, 1] == x)
    if(length(target) != 0){
        geneid <- whl_to_loc[target, 2][1]
        if((geneid != "none") && (geneid != "")){
            out <- geneid
        }else{
            out <- x
        }
    }else{
        out <- x
    }
    out
}))
seurat.obj <- RenameGenesSeurat(seurat.obj, newnames=new.rownames)

# Save
save(seurat.obj, file=outfile)
