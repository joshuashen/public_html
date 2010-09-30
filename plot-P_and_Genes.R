plotgenes <- function(data = NULL, gene = NULL, shape = 19)
{
 # plot p-values
  unit = 1000000;
  
#  max = -log10(min(data$P))
   max = 15
   
#   data = data[data$P < 0.01, ]

  lt8 = data[data$P >= 0.00000005, ]

# p larger than 10^-6
  lt6 = data[data$P >= 0.000001, ]  
# p larger than 5x10^-8 but smaller than 10^-6
  subs = lt8[lt8$P <  0.000001, ]
# genome-wide significant SNPs
  gs  = data[data$P < 0.00000005, ]

  plot(data$BP/unit, -log10(data$P), ylim=range(c(0, max + 7)), xlab="Position (Mb)", ylab="-log10(p-value)", col='white' )
  points(lt6$BP/unit, -log10(lt6$P), col='blue', pch=shape)
  points(subs$BP/unit, -log10(subs$P), col='green', pch=shape)
  points(gs$BP/unit, -log10(gs$P), col='red', pch=shape)	
  abline(h= -log10(0.00000005), col = 'gray', lty="dashed")

  text(gene$START/unit, max+7, gene$LOCUS, srt = 90, adj=1, font=3)


  

}


