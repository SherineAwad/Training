library(Seurat)
library(dplyr)
library(ggplot2)

# 1. Load your clustered object
myObject <- readRDS("clustered2.rds")

# 2. Define your grouped annotations using a named list of vectors
# This lets you map multiple cluster numbers to a single cell type effortlessly
annotation_list <- list(
  "Immune"        = c(8, 11, 24, 17),
  "Epithelial"    = c(13, 14),
  "Endothelial"   = c(2),
  "Pericyte"  = c(23,3),
  "Mesenchymal" = c(1,5,6,7,19,15,0,22,12,10,4,21,16,25,20,9,18)
  # Add any remaining clusters here so they don't get left as raw numbers
)

# 3. Apply the mapping to a new metadata column
myObject$cell_type <- as.character(myObject$seurat_clusters)

for (cell_type in names(annotation_list)) {
  clusters_to_map <- as.character(annotation_list[[cell_type]])
  myObject$cell_type[myObject$seurat_clusters %in% clusters_to_map] <- cell_type
}

# 4. Set the object identities to your new cell types
Idents(myObject) <- myObject$cell_type

# 5. Generate the annotated UMAP plot object
p <- DimPlot(myObject, reduction = "umap", label = TRUE, repel = TRUE, pt.size = 0.5) + 
  ggtitle("UMAP - Grouped & Annotated Cell Types") +
  theme(legend.position = "right")

# Save as PDF
pdf(file = "DigitTips_Annotated_UMAP.pdf", width = 10, height = 8)
print(p)
dev.off()

# Save as PNG
png(file = "DigitTips_Annotated_UMAP.png", width = 1500, height = 1200, res = 150)
print(p)
dev.off()

# 6. Save the final annotated object
saveRDS(myObject, file = "annotated.rds")
