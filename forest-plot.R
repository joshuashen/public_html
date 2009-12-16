forest <- function(data = NULL)
  {


    library(rmeta)

#    y = c("", "OR")
    x = matrix(data$V1)
    x = cbind(x, data$V2)
 #   x = rbind(y,x)
#    colnames(x) = c("", "Odds Ratio")

    # plot
    forestplot(mean=data$V2, lower=data$V3, upper=data$V4, x, is.summary=F, xlab="Odds Ratio", col=meta.colors(box="royalblue", line="darkblue", summary="red"), zero = 1, xticks = c(0,1,5,10,15, 20))
  }
