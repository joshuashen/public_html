forest <- function(data = NULL)
  {


    library(rmeta)

#    y = c("", "OR")
    x = matrix(data$V1)
    x = cbind(x, data$V2)
 #   x = rbind(y,x)
#    colnames(x) = c("", "Odds Ratio")

# ticks
  xt = c(0,2,4,6,8,10,12)
   # plot
    forestplot(mean=data$V2, lower=data$V3, upper=data$V4, x, is.summary=F, xlab="Odds Ratio", col=meta.colors(box="royalblue", line="darkblue", summary="red"), zero = 1, xticks = xt)
  }
