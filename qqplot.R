## file: HistQQ.R
## author: Silviu-Alin Bacanu
## created: 6/22/2006
## modified: 11/14/2007
## description: Basic code to create a figure with a histogram and QQ plot of
##  p-value data.

## pvalfile: text name of file containing p-values.  Column 1 is assumed to be
##  the SNP ID.
## colList: numeric vector of columns with p-values to be plotted.  One plot is
##  created for each column.
## pdffilePrefix: text name of pdf file to be saved.  If NULL, plotted on
##  default device.
## data: optional data.frame, which may be provided in lieu of pvalfile.
histqq <- function(pvalfile = NULL, pdffilePrefix = NULL,
                   colList = 2,
		   plotName = "",
                   data = NULL)
{

##### eliminate NA from pvals
  require(MASS)
  topquant <- 1
  CIconf  <- 0.95
  
  if(is.null(data))
    pvaldata_orig <- read.table(pvalfile, header = T, sep = "\t",
                                na.string = c("NA","na"))
  else
    pvaldata_orig <- data
  
  n <- names(pvaldata_orig)
  
  for( i in colList) {
    pvaldata <- pvaldata_orig[!is.na(pvaldata_orig[[n[i]]]),]
    pvals <- pvaldata[, n[i]]
    snpnames <- pvaldata[, n[1]]
    
    if(length(snpnames)>0 & length(snpnames)!=length(pvals)) 
      stop("SNP names and p-values do not have the same length!")
    if(is.null(snpnames)){
      snpnames <- paste("m",c(1:length(pvals)),sep="")
    }
    if(!is.null(pdffilePrefix)) {
      outfile  <-  paste(pdffilePrefix,n[i],"qq.ps", sep=".")	
      postscript(outfile,  height = 6.5, width = 9, paper = 'special', horizontal = FALSE, onefile = FALSE, family = "ComputerModern")
    }
    
    mainhist  <-  paste(n[i],"histogram", sep=" ")
    mainqq <-   paste(n[i]," QQ (", plotName, ")", sep="")
#    par(mfrow = c(1, 2), mar=c(6,5,3.5,1), pty = "s")
#    
#    truehist(pvals, main = mainhist,
#             breaks = seq(0, 1, by = 0.05),  # Specify breaks for consistent look
#             xlab = n[i], ylab = "Density", 
#             xlim = c(0, 1),cex.lab=1.5,cex.axis=1.25,cex.main=1.25) # ylim = c(0, 1)) # Can't safely pre-specify ylim
#    abline(1, 0, lwd = 3, col = "red")
    ## nsp is the number of sample points
    nsp <- floor((2*length(pvals))^(1/2.1)) 
### sample more towards low pvals
    ranks <- (c(1:floor((2*length(pvals))^(1/2.1))/nsp))^2 
    ## make sure the rank is not below 1/length(pvals)
    ranks <- apply(cbind(ranks,rep((1+10^(-10))/length(pvals),length(ranks))),1,max)
    exp <- c(1:length(pvals))/(length(pvals) + 1)
    quants <- unique(floor(sort(c(1:floor(topquant*length(pvals)/1000),length(pvals)*ranks))))
    quants <- quants[quants>0]
    o <- order(pvals)
    data <- data.frame(cbind(exp[quants], sort(pvals)[quants]))
    dimnames(data)[[2]] <- c("expected","observed")
    data$snpnames <- snpnames[o][quants]
    varexp <- data$expected*(1-data$expected)/length(pvals) 
    data$liminf   <- apply(cbind(data$expected-qnorm((1-CIconf)/2,lower=F)*sqrt(varexp),rep(  1/length(pvals)/10^5,length(unique(quants))) ),1,max)
#    data$liminf   <- data$expected-qnorm((1-CIconf)/2,lower=F)*sqrt(varexp)
    data$limupper <- apply(cbind(data$expected+qnorm((1-CIconf)/2,lower=F)*sqrt(varexp),rep(1-1/length(pvals)/10^5,length(unique(quants))) ),1,min)
#    data$limupper <- data$expected+qnorm((1-CIconf)/2,lower=F)*sqrt(varexp)
    
    qqplot(-log10(data$expected), -log10(data$observed),
           main = mainqq, xlab = "-Log10 Expected P-values",
           ylab = "-Log10 Observed P-values",
           pch = 20)
    lines(-log10(data$expected),-log10(data$expected),lwd=2.5,col = "purple")
    lines(-log10(data$expected),-log10(data$liminf),lwd=2,col="red")
    lines(-log10(data$expected),-log10(data$limupper),lwd=2,col="blue")
    legend("bottomright", c("Expected", paste("Lower Bound ",100*CIconf," CI",sep=""),
                            paste("Upper Bound ",100*CIconf," CI",sep="")), 
           col = c("purple","red","blue"), lty = 1, lwd = 2)

    if(!is.null(pdffilePrefix))
      dev.off()
  }
}
