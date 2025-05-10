source("src/Functions.R")

# Parameter
db <- commandArgs(trailingOnly=TRUE)[1]
rsample <- commandArgs(trailingOnly=TRUE)[2]
outfile <- commandArgs(trailingOnly=TRUE)[3]

# Loading
our_celltypes <- c()
reported_celltypes <- c()
for(i in seq_along(qsamples2)){
	infile1 <- paste0("data/", db, "/", qsamples2[i], "/seurat_annotated_lt.RData")
	infile2 <- paste0("output/", qsamples2[i], "_vs_", rsample, "/predictions.RData")
	load(infile1)
	load(infile2)
	our_celltypes <- c(our_celltypes, seurat.obj$celltype)
	reported_celltypes <- c(reported_celltypes, predictions$predicted.id)
}

# Corresponding Table
tbl <- table(our_celltypes, reported_celltypes)
tbl <- tbl / rowSums(tbl)
df <- as.data.frame(tbl)
colnames(df) <- c("Ours", "Reported", "Rate")
if(rsample == "Sp_48_72hpf") {
  df$Ours <- factor(df$Ours, levels = label_ours)
  df$Reported <- factor(df$Reported, levels = label_reported)
}else{
  all_labels <- sort(unique(c(df$Ours, df$Reported)))
  df$Ours <- factor(df$Ours, levels = all_labels)
  df$Reported <- factor(df$Reported, levels = all_labels)
}

# Plot
g <- ggplot(df, aes(x = Reported, y = Ours, fill = Rate)) +
  geom_tile(color = "white") +
  scale_fill_viridis(name = "Rate", option = "D", direction = 1) +
  theme_minimal(base_size = 12) +
  labs(x = "Reported", y = "Ours") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave(g, file = outfile, width = 8, height = 6, dpi = 300)