plotgenes <- function(data1 = NULL, data2= NULL, data3=NULL, gene = NULL, recom = NULL, shape = 19)
{
 # plot p-values
  unit = 1000000;
  
#  max = -log10(min(data$P))
   max = 14
   
   data1 = data1[data1$P < 0.05, ]
   data2 = data2[data2$P < 0.05, ]
   data3 = data3[data3$P < 0.05, ]

   par(mar=c(5,5,8,5))
   plot(data1$BP/unit, -log10(data1$P), ylim=range(c(0, max + 2)), xlab="Chromosome 6 Position (Mb)", ylab="-log10(p-value)", col='white' )
   lines(recom[,1]/unit, recom[,2]/60 * max, col='lightblue')
   
   axis(4, at = c(0,20/(60/max),40/(60/max),60/(60/max)),  labels=c("0","20","40","60"), las=1)
   mtext("Recombination rate (cM/Mb)", side=4, line=3)

  points(data1$BP/unit, -log10(data1$P), col='black', pch=19)
  points(data2$BP/unit, -log10(data2$P), col='blue', pch=1)
  points(data3$BP/unit, -log10(data3$P), col='red', pch=5)	

  abline(h= -log10(0.00000005), col = 'gray', lty="dashed")

  mtext(gene$LOCUS, side=3, at=gene$START/unit, las=2, adj=0, font=3, line=0.2)


  

}


