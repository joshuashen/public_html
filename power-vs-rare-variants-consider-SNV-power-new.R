# also consider the power of SNV detection

# gsize = 3000000000  # genome size
depthCov = 40
targetSamples = 20
totalBp = depthCov * targetSamples

controlCarr = 1  # number of carriers in controls for a particular variant

# gshape = 0.6  ## shape parameters in Gamma distribution

minDepth = 3  # min Depth-coverage of a haploid for SNV detection

numCases <- c(4:39) * 5

numControls <- 500

# typeIerror <- 0.00000005
typeIerror <- 0.000005

# maxShare = 100
freq <- c(1:20) / 200  # from 0.005 to 0.1


m <- matrix(,nrow=0, ncol=maxShare+1)
colnames(m) = c("cov",1:maxShare)

# assume depth-coverage is Poisson, but the mean is a function of gc content

gcAdjust = 0.9  ## need to calculate the GC distribution of exons.


for (case in numCases){
  depthCov = totalBp / case
 
 # negative binomial
#  palter = 1 - pnbinom(minDepth - 1, mu = depthCov/2, size = depthCov * gshape / 2)

# or Poisson
 palter = 1 - ppois(minDepth -1 , lambda = depthCov * gcAdjust/2)

  
  b = c(controlCarr, numControls - controlCarr)	
  
                                        # calculate min number of cases sharing a variant in order to get p-value < typeIerror 
  minSharing = 1
  for (i in 1:case) {
    a = c(i, case - i)
    ## dominant model 
    p = fisher.test(cbind(a,b))$p.value
    if (p < typeIerror) {
      minSharing = i
      break
    }
  }
  
  power = c(round(depthCov, 2),rep(0,maxShare))
  
  
  for (i in minSharing:maxShare) {
      # pdf of getting j carriers
#      pd = dbinom(1:case, i, case/totalCases)
    for (j in minSharing:case)  {
                                        # for each instance of j carriers, compute the prob of having k detected
      for (k in minSharing:j) {
                                        # modeled as binomial: j trials, p  = palter
        power[i+1] = power[i+1] + dbinom(j, i, case/totalCases) *dbinom(k, j, palter)
        
 #       }
      }
      
      
      power[i+1] = round(power[i+1], 2)
    }
  }
  m <- rbind(m, power)
}

rownames(m) = numCases


write.table(t(m), "power-vs-rare_variants.txt", quote=FALSE, sep = "\t", row.names = T, col.names = T)
