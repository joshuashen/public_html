args <- commandArgs(TRUE)

infile <- args[1]

title <- args[2] 

library(car)

# qqout <- paste(infile, "chisq_qqplot.ps", sep="_")
qqout <- paste(infile, "chisq_qqplot.png", sep="_")

# postscript(qqout, height=6, width= 6, paper='special', horizontal=FALSE, onefile=FALSE, family="Helvetica")
# pdf(qqout, width=6, height=6)
png(filename =qqout, width=480, height=480)

a <- read.table(infile, header=T)
qq.plot(a$CHISQ, dist="chisq", df = 1, xlab="Expected chisq", ylab="Observed chisq", main=title)

if(!is.null(qqout))
  dev.off()


