# numCases <- c(20,40,60)
numCases <- c(20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100)
totalCases <- 200

numControls <- 400

maxShare = 100

# typeIerror <- 0.00000005                                                                                                                     
typeIerror <- 0.000005

# first column is the power of overall cases                                                                                                   
m <- matrix(,nrow=0, ncol=maxShare)

colnames(m) = c(1:maxShare)
rn = c("p-value", numCases)

power=rep(0,maxShare)

for (i in 1:maxShare ) {
  p = fisher.test(cbind(c(i, totalCases - i ), c(0,numControls)))$p.value
  power[i] = signif(p,2)
}

m <- rbind(m, power)

for (case in numCases){
  power = rep(0,maxShare)
  b = c(0, numControls)
  
  
  for (i in 1:maxShare) {
  #               n = rbinom(simulation, i , case / totalCases)
    
#    pd = dbinom(0:case, i, case/totalCases)
    
    p = 0
    for (j in 0:case) {
      a = c(j, case - j)
      
      pvalue = fisher.test(cbind(a,b))$p.value
      if (pvalue < typeIerror) {
        p = 1 - pbinom(j-1,i, case/totalCases)
        break
#        cump = cump + pd[j]
      }
      
    }
    power[i] = round(p, 2)
  }
  m <- rbind(m, power)
}

rownames(m) = rn

write.table(t(m), "power-vs-rare_variants.txt", quote=FALSE, sep = "\t", row.names = T, col.names = T)

