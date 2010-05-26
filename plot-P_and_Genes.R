plotgenes <- function(data = NULL, gene = NULL)
{
 # plot p-values
  unit = 1000000;
  max = -log10(min(data$P))
  plot(data$BP/unit, -log10(data$P), pch=5, ylim=range(c(0, max + 5)), xlab="Position (Mb)", ylab="-log10(p-value)", col='blue')
  text(gene$START/unit, max+5, gene$LOCUS, srt = 90, adj=1)
}


