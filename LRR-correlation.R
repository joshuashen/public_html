
lrr <- read.table("illumina1M.BeadStudio_2_PennCNV.txt.LRR", header=TRUE)
## lrr <- read.table("temp", header=TRUE)

lrrCor <- cor(as.matrix(lrr[,2:209]), use="complete.obs")

write.table(lrrCor, "lrr.cor")
