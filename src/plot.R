library(Seurat)
library(ggplot2)

# 1. Load the clustered Seurat object
myObject <- readRDS("clustered2.rds")

# 2. Ensure layers are joined if using Seurat v5
if (packageVersion("Seurat") >= "5.0.0") {
  myObject <- JoinLayers(myObject)
}

# 3. Comprehensive marker dictionary with expanded VSM, Pericyte, and Schwann cell markers
marker_genes <- list(
  # --- Broad Lineage Compartments ---
  "Immune_Broad" = c("Ptprc", "Cd48", "Tyrobp", "Cd53", "Dock2"),
  "Mesenchymal_Broad" = c("Prrx1", "Pdgfra", "Thy1", "Twist1", "Gli1"),
  "Epithelial_Broad" = c("Epcam", "Cdh1", "Krt8", "Krt18", "Krt19"),
  "Endothelial_Broad" = c("Pecam1", "Cdh5", "Vwf", "Kdr", "Flt1", "Emcn"),
  
  # --- Frequently Unannotated Digit Tip Populations ---
  "Cycling" = c("Mki67", "Top2a", "Stmn1", "Ccna2", "Ccnb1", "Pclaf"),
  "Erythroid" = c("Hbb-bt", "Hbb-bs", "Hba-a1", "Alas2", "Car2"),
  "Skeletal_Muscle" = c("Myod1", "Myog", "Ttn", "Ckm", "Pax7"),
  "Melanocyte" = c("Dct", "Tyr", "Pmel", "Mitf"),
  
  # --- Expanded Perivascular & Neural Populations ---
  "Pericyte" = c("Cspg4", "Pdgfrb", "Kcnj8", "Abcc9", "Rgs5", "Notch3", "Des", "Anpep", "Colec11"),
  "SMC" = c("Myh11", "Tagln", "Acta2", "Cnn1", "Des", "Myl9", "Vtn", "Mustn1", "Tpm2"),
  "Schwann" = c("Mbp", "Plp1", "Sox10", "S100b", "Pmp22", "Mpz", "Prx", "Ncam1", "Egr2", "Gas7"),
  
  # --- Specific Cell Types & Subsets ---
  "Fibroblast" = c("Prrx1", "Pdgfra", "Dcn", "Pi16", "Col1a1"),
  "Macrophage" = c("Adgre1", "Csf1r", "Cd68", "Mrc1", "Cd163"),
  "Keratinocyte" = c("Krt14", "Krt5", "Krt17", "Dsg3", "Krt1"),
  "Osteoblast" = c("Runx2", "Postn", "Mmp13", "Spp1", "Sp7", "Bglap", "Alpl"),
  "Chondrocyte" = c("Col2a1", "Acan", "Sox9", "Matn1", "Comp"),
  "T-cell" = c("Cd3d", "Cd3e", "Cd4", "Cd8a", "Cd28"),
  "Osteoclast" = c("Ctsk", "Acp5", "Calcr", "Oscar", "Nfatc1", "Tnfrsf11a"),
  "Synoviocyte" = c("Prg4", "Ucma", "Gdf5", "Cilp2", "Frzb"),
  "Neutrophil" = c("Ly6g", "S100a8", "S100a9", "Mpo", "Csf3r"),
  "Lymphatic_Endothelial" = c("Prox1", "Lyve1", "Pdpn", "Flt4"),
  "B-cell" = c("Cd79a", "Cd19", "Ms4a1", "Ighm", "Pax5"),
  "Rspo3_Col23a1" = c("Rspo3", "Col23a1"),
  "MSC" = c("Lepr", "Cxcl12", "Ngfr", "Nes", "Cd44"),
  "Osteosarcoma" = c("EGFP"),
  "Nail_Epithelium" = c("Lgr6", "Sp6", "Sp8"),
  "Sweat_glands" = c("Aqp5", "Scnn1a", "Scnn1b", "Foxa1"),
  "Mast_cell" = c("Kit", "Cpa3", "Tpsab1", "Tpsb2", "Ms4a2", "Hdc")
)

# 4. Loop through each cell type and generate FeaturePlots (saved as both PDF and PNG)
for (cell_type in names(marker_genes)) {
  genes <- marker_genes[[cell_type]]
  available_genes <- intersect(genes, rownames(myObject))
  
  if (length(available_genes) > 0) {
    base_filename <- paste0("FeaturePlot_", gsub(" ", "_", cell_type))
    pdf_filename <- paste0(base_filename, ".pdf")
    png_filename <- paste0(base_filename, ".png")
    
    p <- FeaturePlot(
      object = myObject, 
      features = available_genes, 
      reduction = "umap", 
      ncol = 3, 
      repel = TRUE, 
      combine = TRUE
    ) + ggtitle(paste0("Marker Genes: ", cell_type))
    
    # Save as PDF
    pdf(pdf_filename, width = 14, height = 10)
    print(p)
    dev.off()
    
    # Save as PNG
    png(png_filename, width = 2100, height = 1500, res = 150)
    print(p)
    dev.off()
    
    message(paste("Saved:", pdf_filename, "and", png_filename))
  } else {
    message(paste("Skipping", cell_type, "- none of the specified genes found in object rownames."))
  }
}
