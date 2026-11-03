library(Seurat)
library(dplyr)
library(ggplot2)
library(patchwork)

# 1. Load the matrices
sittc1 <- Read10X_h5("SITTC1_filtered_feature_bc_matrix.h5")
sittf8 <- Read10X_h5("SITTF8_filtered_feature_bc_matrix.h5")

# 2. Create individual Seurat objects with sample identifiers
obj_c1 <- CreateSeuratObject(counts = sittc1, project = "DigitTips", min.cells = 3, min.features = 200)
obj_c1$orig.ident <- "5x"

obj_f8 <- CreateSeuratObject(counts = sittf8, project = "DigitTips", min.cells = 3, min.features = 200)
obj_f8$orig.ident <- "3x"

# 3. Correctly merge them together
myObject <- merge(obj_c1, y = obj_f8, add.cell.ids = c("5x", "3x"))

# 4. Verify basic metadata
table(myObject$orig.ident)
glimpse(myObject)
print(myObject)

# Save intermediate merged object
saveRDS(myObject, file = "DigitTips2.rds")

# Reload and join layers (required for Seurat v5 integration/normalization)
myObject <- readRDS("DigitTips2.rds")
myObject <- JoinLayers(myObject)

# Calculate mitochondrial percentage 
myObject[["percent.mt"]] <- PercentageFeatureSet(
  myObject,
  pattern = "^mt-",
  assay = "RNA"
)

# Generate the PRE-FILTER QC plot (Saved as both PDF and PNG)
p_pre <- VlnPlot(
  object = myObject,
  features = c("nCount_RNA", "nFeature_RNA", "percent.mt"),
  group.by = "orig.ident",
  pt.size = 0,
  ncol = 3
)

pdf("DigitTips_preFilter2.pdf", width = 12, height = 6)
print(p_pre)
dev.off()

png("DigitTips_preFilter2.png", width = 1800, height = 900, res = 150)
print(p_pre)
dev.off()

# 5. FILTER CELLS 
myObject <- subset(
  myObject, 
  subset = nFeature_RNA > 500 & 
           nFeature_RNA < 10000 & 
           nCount_RNA > 1000 & 
           percent.mt < 10
)

# 6. Generate the POST-FILTER QC plot (Saved as both PDF and PNG)
p_post <- VlnPlot(
  object = myObject,
  features = c("nCount_RNA", "nFeature_RNA", "percent.mt"),
  group.by = "orig.ident",
  pt.size = 0,
  ncol = 3
)

pdf("DigitTips_postFilter2.pdf", width = 12, height = 6)
print(p_post)
dev.off()

png("DigitTips_postFilter2.png", width = 1800, height = 900, res = 150)
print(p_post)
dev.off()

# 7. Normalization and Feature Selection
myObject <- NormalizeData(myObject)
myObject <- FindVariableFeatures(myObject, selection.method = "vst", nfeatures = 2000)

# 8. Scaling
myObject <- ScaleData(myObject)

# 9. Dimensionality Reduction & Clustering
myObject <- RunPCA(myObject, reduction.key = "PC_")
myObject <- FindNeighbors(myObject, dims = 1:15) 
myObject <- FindClusters(myObject, resolution = 0.6) 
myObject <- RunUMAP(myObject, dims = 1:15, reduction.name = "umap")

# 10. QC per Cluster Plots (Saved as both PDF and PNG)
p_cluster_qc <- VlnPlot(
  object = myObject,
  features = c("nCount_RNA", "nFeature_RNA", "percent.mt"),
  group.by = "seurat_clusters",
  pt.size = 0,
  ncol = 3
)

pdf("DigitTips_QC_per_cluster.pdf", width = 14, height = 6)
print(p_cluster_qc)
dev.off()

png("DigitTips_QC_per_cluster.png", width = 2100, height = 900, res = 150)
print(p_cluster_qc)
dev.off()

# 11. Plotting and Saving UMAP Results (Saved as both PDF and PNG)
myObject$sample <- myObject$orig.ident

p_umap1 <- DimPlot(myObject, reduction = "umap", group.by = "orig.ident", repel = TRUE) + ggtitle("UMAP by Sample (orig.ident)")
p_umap2 <- DimPlot(myObject, reduction = "umap", group.by = "sample", repel = TRUE) + ggtitle("UMAP by Sample")
p_umap3 <- DimPlot(myObject, reduction = "umap", label = TRUE, repel = TRUE) + ggtitle("UMAP Clustered")

p_umap_combined <- p_umap1 + p_umap2 + p_umap3 + plot_layout(ncol = 3)

pdf(file = "DigitTips_UMAP2.pdf", width = 18, height = 6)
print(p_umap_combined)
dev.off()

png(file = "DigitTips_UMAP2.png", width = 2700, height = 900, res = 150)
print(p_umap_combined)
dev.off()

# Save final processed and clustered object
saveRDS(myObject, file = "clustered2.rds")
