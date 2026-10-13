# Training Dataset: scRNA-seq Analysis of Mouse Digit Tip Regeneration


## Background Questionnaire 

Based on the [background questionnaire](https://docs.google.com/document/d/1h3HWbbqakCWmlmo7nwa8gpQcNXwEqdGgQ0KwCASXyD0/edit?usp=sharing), we will organise an scRNA-seq tutorial using RStudio, tailored to your current level of experience.


# Single-Cell RNA Sequencing (scRNA-seq)

## 1. What is scRNA-seq?

Single-cell RNA sequencing (scRNA-seq) is a technique used to measure gene expression in individual cells.

Traditional bulk RNA-seq measures RNA from a mixture of many cells, so the results represent an average across those cells.

scRNA-seq allows us to investigate differences between individual cells within the same tissue.

**Example:**

A digit tip contains several cell types, such as fibroblasts, immune cells, endothelial cells, and epithelial cells. scRNA-seq helps us identify these cell types and investigate which genes they express.

---

## 2. What does scRNA-seq measure?

Genes contain DNA instructions that cells use to produce RNA and, in many cases, proteins.

When a gene is active, the cell may produce RNA from that gene. Measuring RNA therefore helps us estimate gene expression.

scRNA-seq measures RNA molecules, mainly messenger RNA (mRNA), captured from individual cells.

- **More detected RNA:** Generally suggests higher expression of a gene.
- **Less detected RNA:** Generally suggests lower expression.
- **No detected RNA:** Does not necessarily mean the gene is inactive; its RNA may simply not have been captured or detected.

In single-cell RNA-seq, the failure to detect an RNA molecule that is present is often described as a **dropout event**.

**Important:** scRNA-seq measures RNA, not proteins directly.

---

## 3. How does scRNA-seq work?

The process can be summarised in several steps:

1. **Tissue collection:** A tissue sample is collected.

2. **Cell isolation:** The tissue is processed to obtain individual cells or cell nuclei, depending on the experimental method.

3. **RNA capture and barcoding:** RNA from individual cells is captured, for example, using droplet microfluidics. Each captured molecule receives a **cell-specific barcode** that identifies its cell of origin. In many protocols, a **Unique Molecular Identifier (UMI)** is also attached to help distinguish individual captured RNA molecules.

4. **Library preparation:** Captured RNA is converted into complementary DNA (cDNA), which is amplified and prepared for sequencing.

5. **Sequencing:** The DNA fragments are sequenced to generate short sequences called reads.

6. **Data analysis:** The reads are processed and mapped to genes, allowing us to estimate gene expression in each cell.

The cell barcode tells us which cell a captured RNA molecule came from.

The UMI helps distinguish unique captured molecules from copies generated during PCR amplification. This improves molecule counting, although it does not eliminate all amplification bias.

**Note:** UMIs are used in many common scRNA-seq protocols, but not all protocols use them.

Together, these methods allow us to reconstruct the gene expression profile of individual cells.

---

## 4. What is a gene expression matrix?

After processing the sequencing data, we obtain a gene expression matrix.

Each row represents a cell, and each column represents a gene. The values indicate how much RNA was detected for each gene in each cell, usually represented by counts.

For example:

| Cell | Gene A | Gene B | Gene C |
|---|---:|---:|---:|
| Cell 1 | 10 | 0 | 5 |
| Cell 2 | 0 | 15 | 2 |
| Cell 3 | 8 | 1 | 0 |

In this example:

- **Cell 1:** Has 10 counts for Gene A and 5 counts for Gene C.
- **Cell 2:** Has 15 counts for Gene B and 2 counts for Gene C.
- **Cell 3:** Has 8 counts for Gene A and 1 count for Gene B.

A count of zero means that no RNA molecules were detected for that gene in that cell. It does not necessarily mean that the gene is completely inactive.

Different patterns of gene expression can help us distinguish cell types.

---

## 5. Why do we perform quality control (QC)?

Not every cell produces a high-quality sequencing profile. Some cells may be damaged, contain very little RNA, or represent multiple cells captured together.

When two or more cells are captured and mistakenly treated as one, the resulting observation is called a **doublet** or, more generally, a **multiplet**.

Quality control helps identify and remove low-quality cells and potential doublets before downstream analysis.

Common QC measurements include:

- **Number of genes detected:** How many different genes have at least one detected RNA molecule in a cell.
- **Total counts:** The total number of RNA-derived counts detected in a cell.
- **Percentage of mitochondrial RNA:** The proportion of counts coming from mitochondrial genes. A high percentage can indicate cell stress or damage, but it is not definitive evidence of either.

Mitochondrial RNA fractions vary between tissues and cell types. They can also be influenced by cell metabolism, sample preparation, and the quality of the cells.

For example, a damaged cell may lose some of its cytoplasmic RNA, increasing the proportion of detected RNA that comes from mitochondria. However, other biological and technical factors can produce similar patterns.

QC thresholds should therefore be chosen based on the dataset rather than applied blindly.

---

## 6. Why do we normalise the data?

Different cells can have different total numbers of detected RNA molecules because of biological differences, technical variation, and differences in RNA capture efficiency.

Without normalisation, a cell with more total counts may appear to express many genes more highly simply because more RNA was captured or sequenced.

Normalisation adjusts for differences in sequencing depth and other technical factors, making gene expression comparisons more meaningful.

**Important:** Normalisation does not make every cell identical. It aims to reduce technical differences while preserving meaningful biological variation.

---

## 7. What is dimensionality reduction?

A dataset may contain thousands of genes measured across thousands of cells. It is difficult to visualise such a high-dimensional dataset directly.

Dimensionality reduction summarises patterns of variation in the data using a smaller number of dimensions.

Two common methods are:

- **PCA (Principal Component Analysis):** Summarises major linear patterns of variation in gene expression data.
- **UMAP (Uniform Manifold Approximation and Projection):** Creates a low-dimensional representation, often in two dimensions, to help visualise relationships between cells.

Each dot in a UMAP plot usually represents one cell. Cells with similar gene expression patterns often appear close together.

**Important:** UMAP is a visualisation and exploration tool. The positions of cells on the plot do not, by themselves, establish their biological identities or prove that particular cells belong to distinct cell types.

---

## 8. What is clustering?

Clustering groups cells according to similarities in their gene expression profiles.

For example, a dataset may contain clusters corresponding to fibroblasts, immune cells, endothelial cells, and epithelial cells.

Clustering algorithms identify groups computationally by assessing similarities between cells. Depending on the method, this may involve distances between cells or a graph connecting similar cells.

Clustering is a computational process: the algorithm does not automatically know the biological identity of each group.

The resulting clusters must be interpreted using biological evidence, such as marker genes and knowledge of the tissue.

**Important:** Clusters do not automatically correspond to distinct cell types. Different clusters may represent different cell states within the same cell type, while closely related cell types may sometimes appear in the same cluster.

---

## 9. How do we identify cell types?

Cell-type annotation assigns biological identities to clusters.

Researchers examine genes that are more highly expressed in one cluster than in other cells and compare them with known cell-type markers.

Examples include:

- **Pecam1 (CD31):** Commonly used as an endothelial cell marker.
- **Ptprc (CD45):** Commonly used as a marker of immune cells.
- **Col1a1:** Commonly associated with collagen-producing fibroblasts and other stromal cells.
- **Epcam:** Commonly used as an epithelial cell marker.

No single marker should automatically determine a cell's identity. Researchers should consider several markers together, as well as the tissue, biological context, and experimental design.

**Important:** Marker genes provide evidence for a cell's identity, but their expression is not always exclusive to one cell type.

---

## 10. What is differential gene expression (DGE)?

Differential gene expression analysis identifies genes whose expression differs between two groups of cells.

For example, we might compare fibroblasts from an uninjured digit tip with fibroblasts from a regenerating digit tip.

The analysis can identify genes that are expressed at higher or lower levels in one group.

- **Upregulated genes:** Genes with higher expression in the specified comparison group.
- **Downregulated genes:** Genes with lower expression in the specified comparison group.

Differential expression can help us investigate which genes and biological processes may change during regeneration.

When comparing biological conditions, researchers should account for the experimental design, including biological replicates and potential differences between samples.

**Important:** A difference in gene expression does not, by itself, prove that a gene causes regeneration.

---

## 11. What is the difference between a cell type and a cell state?

A cell type describes a cell's general identity, whereas a cell state describes its current condition or activity.

For example, fibroblasts remain fibroblasts but may adopt different states during wound healing or regeneration.

One group of fibroblasts may express genes associated with extracellular matrix production, while another may express genes associated with cell proliferation.

scRNA-seq can help identify both different cell types and different states within the same cell type.

**Example:**

Two groups of cells may both be fibroblasts, but one group may show a gene expression pattern associated with tissue repair, while the other may show a pattern associated with normal tissue maintenance.

These differences may reflect changes in cell state rather than differences in cell identity.

---

## 12. What can scRNA-seq tell us about regeneration?

In a regenerating digit tip, scRNA-seq can help us:

- Identify the cell types present in the tissue.
- Compare cell populations between uninjured and regenerating tissue.
- Identify genes associated with different stages of regeneration.
- Investigate changes in fibroblast, immune, endothelial, and epithelial cell states.
- Generate hypotheses about the biological pathways involved in regeneration.

However, scRNA-seq mainly provides a snapshot of RNA expression at the time of sample collection.

By itself, it does not establish cell lineage, prove gene function, or demonstrate that a particular cell population causes regeneration.

Additional experiments may be required to test these hypotheses. For example, lineage-tracing experiments can investigate cell origins, while functional experiments can test whether a gene or cell population contributes to regeneration.

---

## 13. Key concepts to remember

- **scRNA-seq:** Measures RNA expression in individual cells.
- **Cell barcode:** Identifies the cell of origin of a captured RNA molecule.
- **UMI:** Helps distinguish unique captured molecules from PCR-generated copies.
- **Gene expression matrix:** Records detected expression for genes across cells (rows = cells, columns = genes).
- **QC:** Identifies low-quality cells and potential doublets or multiplets.
- **Normalisation:** Helps account for technical differences in RNA counts.
- **Dimensionality reduction:** Summarises complex data for analysis and visualisation (PCA, UMAP).
- **Clustering:** Groups cells with similar expression profiles.
- **Cell-type annotation:** Assigns biological identities to clusters using marker genes and biological knowledge.
- **Differential gene expression:** Identifies genes whose expression differs between groups.
- **Cell state:** Describes the current condition or activity of a cell.
- **Biological validation:** Tests whether computational findings reflect real biological phenomena.

**The main idea:** scRNA-seq helps us understand which cells are present in a tissue, what genes they express, and how their expression patterns change under different biological conditions. It generates valuable biological insights, but further evidence may be needed to establish the mechanisms responsible for those changes.


# R Software and Packages Required for scRNA-seq Analysis

## 1. Recommended R Packages

| Package | Purpose | Priority |
|---|---|---|
| `Seurat` | Main scRNA-seq analysis: QC, normalisation, clustering, UMAP and marker genes | Essential |
| `ggplot2` | Data visualisation and plotting | Essential |
| `dplyr` | Filtering and manipulating data | Recommended |
| `patchwork` | Combining multiple plots | Recommended |
| `Matrix` | Working with sparse gene expression matrices | Recommended |
| `BiocManager` | Installing Bioconductor packages | Recommended |
| `SingleR` | Cell-type annotation using reference datasets | Optional |
| `harmony` | Correcting batch effects across samples | Optional |
| `clusterProfiler` | Functional enrichment analysis | Optional |


## Installing R, RStudio, and scRNA-seq Packages on Windows

### Step 1. Install R

1. Open the official R website: https://cran.r-project.org/
2. Click **Download R for Windows**.
3. Click **base**.
4. Download the latest stable R version compatible with Seurat.
5. Run the downloaded installer and keep the default settings.

### Step 2. Install RStudio Desktop

1. Open: https://posit.co/download/rstudio-desktop/
2. Download the free **RStudio Desktop for Windows** installer.
3. Run the installer and keep the default settings.

**Important:** Install R before installing RStudio. R is the programming language; RStudio is the interface used to work with it.

### Step 3. Open RStudio

1. Open RStudio from the Windows Start menu.
2. Locate the **Console** panel.
3. Click inside the Console to enter R commands.

### Step 4. Install the scRNA-seq Packages

Copy and paste the following commands into the RStudio Console and press Enter:

```r
install.packages(c(
  "Seurat",
  "ggplot2",
  "dplyr",
  "patchwork"
))
``` 

## Reference: Seurat v5 Tutorial 

[Getting Started with Seurat v5: Introduction to Single-Cell RNA-seq Analysis](https://satijalab.org/seurat/articles/get_started_v5_new)

## Training Dataset: scRNA-seq Data from 3x and 5x Amputated Mouse Digit Tips

[Click here to download the data (you will need to log in with your University of Cambridge credentials)](https://drive.google.com/drive/folders/1xFSFhso0atJtTVNzQtSWkT2popfzkdIB?usp=sharing)

| Sample ID | Condition |
|---|---|
| SITTF8 | 3x |
| SITTC1 | 5x |

## Getting started

```r
library(Seurat)
library(dplyr)

# 1. Load the matrices
sittc1 <- Read10X_h5("SITTC1_raw_feature_bc_matrix.h5")
sittf8 <- Read10X_h5("SITTF8_raw_feature_bc_matrix.h5")

# 2. Create individual Seurat objects with sample identifiers
obj_c1 <- CreateSeuratObject(counts = sittc1, project = "DigitTips", min.cells = 0, min.features = 0)
obj_c1$orig.ident <- "5x"

obj_f8 <- CreateSeuratObject(counts = sittf8, project = "DigitTips", min.cells = 0, min.features = 0)
obj_f8$orig.ident <- "3x"

# 3. Correctly merge them together
myObject <- merge(obj_c1, y = obj_f8, add.cell.ids = c("5x", "3x"))

# 4. Verify
table(myObject$orig.ident)
glimpse(myObject)
print(myObject)

saveRDS(myObject, file = "DigitTips.rds")
```


###### You will see something like this: 

```text
  3x    5x 
25703  5230 
Formal class 'Seurat' [package "SeuratObject"] with 13 slots
  ..@ assays      :List of 1
  .. ..$ RNA:Formal class 'Assay5' [package "SeuratObject"] with 8 slots
  ..@ meta.data   :'data.frame':	30933 obs. of  3 variables:
  .. ..$ orig.ident  : chr [1:30933] "5x" "5x" "5x" "5x" ...
  .. ..$ nCount_RNA  : num [1:30933] 16692 15785 18225 88472 18423 ...
  .. ..$ nFeature_RNA: int [1:30933] 4777 3968 4547 9082 4458 4750 4848 162 4595 4558 ...
  ..@ active.assay: chr "RNA"
  ..@ active.ident: Factor w/ 1 level "DigitTips": 1 1 1 1 1 1 1 1 1 1 ...
  .. ..- attr(*, "names")= chr [1:30933] "5x_AAACCCACACTCCGGA-1" "5x_AAACCCAGTCCTCCAT-1" "5x_AAACCCAGTCCTTTGC-1" "5x_AAACCCAGTGTTGCCG-1" ...
  ..@ graphs      : list()
  ..@ neighbors   : list()
  ..@ reductions  : list()
  ..@ images      : list()
  ..@ project.name: chr "SeuratProject"
  ..@ misc        : list()
  ..@ version     :Classes 'package_version', 'numeric_version'  hidden list of 1
  .. ..$ : int [1:3] 5 3 0
  ..@ commands    : list()
  ..@ tools       : list()
An object of class Seurat 
32285 features across 30933 samples within 1 assay 
Active assay: RNA (32285 features, 0 variable features)
 2 layers present: counts.1, counts.2

``` 


###### Key points in the output

Sample cell counts:

- 3x: 25,703 cells
- 5x: 5,230 cells
- Total: 30,933 cells
- Features: 32,285 genes measured across the dataset.

Metadata (`meta.data`): Contains 3 columns:

- `orig.ident`: Identifies the sample of origin (3x or 5x).
- `nCount_RNA`: Total RNA counts per cell.
- `nFeature_RNA`: Number of genes detected per cell.

Active assay: RNA, containing the gene expression count data.

Count layers: `counts.1` and `counts.2` store the raw counts for the two samples separately.

Variable features: 0 identified so far. Highly variable genes have not yet been selected.

Active identity (`active.ident`): Currently `DigitTips` for all cells, reflecting the project name rather than the sample labels.

Saved object: `DigitTips.rds` contains the Seurat object and can be reloaded using `readRDS("DigitTips.rds")`.
