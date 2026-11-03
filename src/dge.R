library(Seurat)
library(dplyr)

# 1. Load the annotated Seurat object
myObject <- readRDS("annotated.rds")

# 2. Ensure layers are joined if using Seurat v5
if (packageVersion("Seurat") >= "5.0.0") {
  myObject <- JoinLayers(myObject)
}

# 3. Set identity to the sample group column (orig.ident) for differential gene expression between samples
Idents(myObject) <- myObject$orig.ident

# 4. Perform differential gene expression analysis between 5x and 3x across all cells
# Note: min.pct = 0.1 and logfc.threshold = 0.25 are standard default filters
dge_results <- FindMarkers(
  object = myObject,
  ident.1 = "5x",
  ident.2 = "3x",
  min.pct = 0.1,
  logfc.threshold = 0.25
)

# 5. Add gene names as a proper column from rownames
dge_results$Gene <- rownames(dge_results)
dge_results <- dge_results %>% select(Gene, everything())

# 6. Save results to a CSV file in the current directory
write.csv(dge_results, file = "DGE_5x_vs_3x.csv", row.names = FALSE)

message("Differential gene expression complete! Results saved to DGE_5x_vs_3x.csv")
