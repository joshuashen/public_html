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
pQQplot <- function(pvalfile=NULL, data = NULL)
{

##### eliminate NA from pvals
  require(MASS)
  topquant <- 1
  CIconf  <- 0.95
  
  if(is.null(data))
    pvaldata <- read.table(pvalfile, header = T, na.string = c("NA","na"))
  else
    pvaldata <- data
  
#  n <- names(pvaldata_orig)
  
  pvaldata <- pvaldata[!is.na(pvaldata$P),]
  pvals <- as.vector(pvaldata$P)
     
 
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
 # data$snpnames <- snpnames[o][quants]

  par(cex.lab=1.2)
  par(cex.axis=1.2)
  par(mar=c(5, 5, 2, 2)) # margins, bottom, left, top, right
  
  qqplot(-log10(data$expected), -log10(data$observed),
           # main = mainqq,
         xlab = "-Log10 Expected P-values",
         ylab = "-Log10 Observed P-values", col='red',
         pch = 19)

  explimit = data$expected[data$expected > 0.00000005]
  
 # varexp <- data$expected*(1-data$expected)/length(pvals) 
 # data$liminf   <- apply(cbind(data$expected-qnorm((1-CIconf)/2,lower=F)*sqrt(varexp),rep(  1/length(pvals)/10^5,length(unique(quants))) ),1,max)
 # data$limupper <- apply(cbind(data$expected+qnorm((1-CIconf)/2,lower=F)*sqrt(varexp),rep(1-1/length(pvals)/10^5,length(unique(quants))) ),1,min)

  varexp <- explimit*(1-explimit)/length(pvals)
  liminf   <- apply(cbind(explimit-qnorm((1-CIconf)/2,lower=F)*sqrt(varexp),rep(  1/length(pvals)/10^5,length(unique(quants))) ),1,max)
  limupper <- apply(cbind(explimit+qnorm((1-CIconf)/2,lower=F)*sqrt(varexp),rep(1-1/length(pvals)/10^5,length(unique(quants))) ),1,min)
  
  lines(-log10(explimit),-log10(explimit),lwd=2.5,col = "black")
  lines(-log10(explimit),-log10(liminf),lwd=1.5,lty="dashed",col="blue")
  lines(-log10(explimit),-log10(limupper),lwd=1.5,lty="dashed",col="blue")
#  legend("bottomright", c("Expected", paste("Lower Bound ",100*CIconf," CI",sep=""),
#                          paste("Upper Bound ",100*CIconf," CI",sep="")), 
#         col = c("black","blue","blue"), lty = 1, lwd = 1)
}

