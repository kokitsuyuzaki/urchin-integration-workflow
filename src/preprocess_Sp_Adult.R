source("src/Functions.R")

# Parameter
outfile <- commandArgs(trailingOnly=TRUE)[1]

# # Sp_Adult（そのうち詳細をメールしてくれる）
# GSE134350（以下のどれなのかわからない）
# https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM3943024
# https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM3943023
# https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM3943022
# - データタイプ: 行列データ
# - 遺伝子ID: LOC*
# - 細胞型ラベル: 無し


# Seuratデータをそのまま渡してくれるかもしれない







# Save
save(seurat.obj, file=outfile)
