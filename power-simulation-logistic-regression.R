## given the cases and controls,
# randomly sample some cases and combine with all controls, then do glm and anova

powerGlm <- function(data=Null, cases = 10, numSimu=1000)
  {
    case = data[data$V2 == 1, ]
    control = data[data$V2 ==0, ]
    numCases = dim(case)[1]

    
    count = 0
    for (i in 1:numSimu) {
      ii = sample(1:numCases, cases)
      sam = case[ii,]

      a = rbind(sam, control)

      a.l = glm(a$V2 ~ a$V3 + a$V5, family="binomial")
      a.a = anova(a.l, test="Chisq")
      pValue = a.a[,"P(>|Chi|)"][3]
      if (pValue < 0.05) {
        count = count + 1
      }
    }

    power = count / numSimu
    print(power)
  }
