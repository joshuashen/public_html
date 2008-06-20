# Yufeng Shen,

# modified from: 
#              Diabetes Genetics Initiative of Broad Institute of Harvard and MIT, Lund University and
#                                  Novartis Institutes of BioMedical Research
#        Whole-genome association analysis identifies novel loci for type 2 diabetes and triglyceride levels
#                             Science 2007 Jun 1;316(5829):1331-6. Epub 2007 Apr 26
#
#
#
args <- commandArgs(TRUE)

pvals <- read.table(args[1], header=T)

observed <- sort(pvals[,2])
lobs <- -(log10(observed))

expected <- c(1:length(observed)) 
lexp <- -(log10(expected / (length(expected)+1)))

ymax <- ceiling(max(lobs))
xmax <- ceiling(max(lexp))

pdf("qqplot.pdf", width=6, height=6)
plot(c(0,xmax), c(0,xmax), col="red", lwd=3, type="l", xlab="Expected (-logP)", ylab="Observed (-logP)", xlim=c(0,xmax), ylim=c(0,ymax), las=1, xaxs="i", yaxs="i", bty="l")
points(lexp, lobs, pch=23, cex=.4, bg="black") 
dev.off()

