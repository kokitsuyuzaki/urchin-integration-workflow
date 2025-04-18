source("src/Functions.R")

# Parameter
rsample <- commandArgs(trailingOnly=TRUE)[1]
infile1 <- commandArgs(trailingOnly=TRUE)[2]
infile2 <- commandArgs(trailingOnly=TRUE)[3]
outfile <- commandArgs(trailingOnly=TRUE)[4]
# rsample <- "Sp_2.75-28hpf"
# infile1 <- 'output/cont-24h_vs_Sp_2.75-28hpf/predictions.RData'
# infile2 <- 'data/hpbase/cont-24h/seurat_annotated_lt.RData'

# Loading
load(infile1)
load(infile2)

# Corresponding Table
tbl <- table(seurat.obj$celltype, predictions$predicted.id)
tbl <- tbl / rowSums(tbl)
df <- as.data.frame(tbl)
colnames(df) <- c("Ours", "Reported", "Rate")
all_labels <- sort(union(df$Ours, df$Reported))
df$Ours <- factor(df$Ours, levels = all_labels)
df$Reported <- factor(df$Reported, levels = all_labels)

# Plot
g <- ggplot(df, aes(x = Reported, y = Ours, fill = Rate)) +
  geom_tile(color = "white") +
  scale_fill_viridis(name = "Rate", option = "D", direction = 1) +
  theme_minimal(base_size = 12) +
  labs(x = "Reported", y = "Ours") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave(g, file = outfile, width = 8, height = 6, dpi = 300)