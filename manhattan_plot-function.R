plotManhattan <- function(input=NULL, data=NULL)
{
  if (is.null(data)) {
    assoc <- read.table(input, header=TRUE, na.strings = "NA")
  } else {
    assoc <- data
  }
  chrs   <- c("1","2", "3", "4", "5", "6", "7", "8", "9" , "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23")
  chrsLabel   <- c("1","2", "3", "4", "5", "6", "7", "8", "9" , "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "X")
  maxs   <- c(0  ,0  ,0   ,0   ,0   ,0   ,0   ,0   ,0    ,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,   0)
  tics   <- c(0  ,0  ,0   ,0   ,0   ,0   ,0   ,0   ,0    ,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,   0)
  
  j=0
  for (i in chrs){
    j = j + 1
    maxs[j+1] <- maxs[j] +  max(subset(assoc,assoc$CHR==i)$BP)
    tics[j] <- maxs[j] + max(subset(assoc,assoc$CHR==i)$BP)/2
  }
  maxs
  
  m<-max(maxs)

  ymaxx = max(-log10(assoc$P)) + 0.5
  if (ymaxx < 8 ) {
    ymaxx = 8
  }
  
  par(cex.lab=1.2)
  par(cex.axis=1.2)
  par(mar=c(5, 5, 2, 2)) # margins, bottom, left, top, right
  plot(c(0,0),c(0,0), xlim=c(0,m), ylim=c(0,ymaxx), type="o", col="1",  axes=FALSE, xaxs="i",yaxs="i",  xlab="Chromosome", ylab="-log10(p-value)")
  axis(1, labels=chrsLabel, at=tics)
  axis(2, labels=T)

  abline(h = -1 * log10(0.00000005), lty="dashed", col='gray')
  
  par(new=T)
  j=0
  for (i in chrs){
    j = j + 1
    tt<-subset(assoc,assoc$CHR==i)
    if ( (j %% 2) == 1) {
      coll <- "lightblue"
    }else{ coll <- "darkblue"}
    
    ## big p-values:
    bigp = tt[tt$P>0.000001, ]
    
    points(maxs[j]+bigp$BP,-log10(bigp$P), type="p", col=coll, pch = 20)
    
    xx = tt[tt$P<=0.000001, ]
    yy = tt[tt$P<=0.0000001, ]
    
    points(maxs[j]+xx$BP, -log10(xx$P),  type="p", col="green", pch=20)
    points(maxs[j]+yy$BP, -log10(yy$P),  type="p", col="red", pch=20)
  
    par(new=T)
  }
}
