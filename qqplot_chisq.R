args <- commandArgs(TRUE)

## input file, header is required, and a column called "CHISQ" is required
infile <- args[1]

## the title to be appear in the plot
title <- args[2] 

### genome inflation factor 
lambda <- args[3]

### can be installed separately 
library(car)

if(is.na(lambda)) {
  lambda <- 1.0
} else {
  lambda <- as.numeric(lambda)
}


# qqout <- paste(infile, "chisq_qqplot.ps", sep="_")
qqout <- paste(infile, "l", lambda, "chisq_qqplot.png", sep="_")

# postscript(qqout, height=6, width= 6, paper='special', horizontal=FALSE, onefile=FALSE, family="Helvetica")
# pdf(qqout, width=6, height=6)

png(filename =qqout, width=480, height=480)

par(cex.lab=2)
par(cex.axis=2)
par(family="Helvetica")
par(mar=c(5, 5, 2, 2))
a <- read.table(infile, header=T)
# qq.plot(a$CHISQ/lambda, dist="chisq", df = 1, xlab="Expected chisq", ylab="Observed chisq", main=title)
qq.plot(a$CHISQ/lambda, dist="chisq", df = 1, xlab="Expected chisq", ylab="Observed chisq")

if(!is.null(qqout))
  dev.off()


