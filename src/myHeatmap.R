library(dplyr)
library(ggplot2)
library(Seurat)

# 1. Load the annotated Seurat object
myObject <- readRDS("annotated.rds")

# Ensure layers are joined if using Seurat v5
if (packageVersion("Seurat") >= "5.0.0") {
  myObject <- JoinLayers(myObject)
}

# 2. Read the DGE CSV file
dge_data <- read.csv("DGE_5x_vs_3x.csv")

# 3. Filter for significant genes (p_val_adj < 0.05), sort by absolute log2FC, and select Top N = 20
N <- 20
top_genes <- dge_data %>%
  filter(p_val_adj < 0.05) %>%
  arrange(desc(abs(avg_log2FC))) %>%
  head(N) %>%
  pull(Gene)

# 4. Compute pseudobulk average expression per condition (orig.ident)
avg_expr <- AverageExpression(
  object = myObject, 
  features = top_genes, 
  group.by = "orig.ident", 
  slot = "data"
)

avg_matrix <- as.matrix(avg_expr$RNA)

# 5. Row-scale the aggregated matrix for relative expression comparison (z-score per gene)
scaled_matrix <- t(scale(t(avg_matrix)))

# 6. Convert to long format for ggplot2
df_long <- as.data.frame(scaled_matrix) %>%
  mutate(Gene = rownames(.)) %>%
  tidyr::pivot_longer(cols = -Gene, names_to = "Sample", values_to = "Expression")

# Maintain the sorted order of top genes on the y-axis
df_long$Gene <- factor(df_long$Gene, levels = rev(top_genes))

# 7. Generate clean aggregated heatmap using ggplot2 (Red-White-Blue color scale)
p <- ggplot(df_long, aes(x = Sample, y = Gene, fill = Expression)) +
  geom_tile(color = "white", linewidth = 0.5) +
  scale_fill_gradient2(
    low = "#2166AC",  # Blue for lower expression
    mid = "#F7F7F7",  # White for baseline
    high = "#B2182B", # Red for higher expression
    midpoint = 0,
    name = "Scaled Expression\n(Z-score)"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    axis.text.x = element_text(angle = 0, hjust = 0.5, face = "bold", size = 11),
    axis.text.y = element_text(face = "bold", size = 10),
    panel.grid = element_blank(),
    plot.title = element_text(face = "bold", hjust = 0.5, size = 13)
  ) +
  labs(
    title = paste0("Top ", N, " DEGs (Condition Average Expression)"),
    x = "Condition / Sample",
    y = "Genes"
  )

# 8. Save as PDF and PNG
pdf("Heatmap_Aggregated_Top20_DGE.pdf", width = 6, height = 8)
print(p)
dev.off()

png("Heatmap_Aggregated_Top20_DGE.png", width = 900, height = 1200, res = 150)
print(p)
dev.off()

message("Aggregated comparison heatmap successfully saved as PDF and PNG!")
