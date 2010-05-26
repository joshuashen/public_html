# also consider the power of SNV detection

# gsize = 3000000000  # genome size
depthCov = 50
targetSamples = 20
totalBp = depthCov * targetSamples

controlCarr = 0  # number of carriers in controls for a particular variant

gshape = 0.6  ## shape parameters in Gamma distribution

minDepth = 3  # min Depth-coverage of a haploid for SNV detection

minRefDepth = 0

minPooledDepthInd = 1
minPooledDepth = 3

#numCases <- c(20,40,60)
numCases <- c(20:160)
# numCases <- c(20,30,40,50,60,70,80,90,100,)

totalCases <- 200
#totalCases <- 70

numControls <- 400

# typeIerror <- 0.00000005
typeIerror <- 0.000005

maxShare = 100

m <- matrix(,nrow=0, ncol=maxShare+2)
colnames(m) = c("cov", "minCarriers" , 1:maxShare)


# simulation = 1000 

# count = 0
for (case in numCases){
  depthCov = totalBp / case
  # count = count + 1
#  rn[count] = paste(rn[count], round(depthCov,2), "-")
 #  rn[count] = round(depthCov,2)
  ## chance of having 3 or more reads covering the alternative allele and 2 or more reads covering the ref allele
#  palter = (1 - pnbinom(minDepth - 1, mu = depthCov/2, size = depthCov * gshape / 2)) *(1- pnbinom(minRefDepth - 1, mu = depthCov/2, size = depthCov * gshape / 2 ))
  palter = 1 - pnbinom(minDepth - 1, mu = depthCov/2, size = depthCov * gshape / 2)

  
  b = c(controlCarr, numControls - controlCarr)	
  
                                        # calculate min number of cases sharing a variant in order to get p-value < typeIerror 
  minSharing = 1
  for (i in 1:case) {
    a = c(i, case - i)
    p = fisher.test(cbind(a,b))$p.value
    if (p <= typeIerror) {
      minSharing = i
      break
    }
  }
  
  power = c(round(depthCov, 2), minSharing, rep(0,maxShare))
  
  
  for (i in minSharing:maxShare) {
 #   if (i < minSharing) {
 #     power[i] = 0 
 #   } else {
      # pdf of getting j carriers
#      pd = dbinom(1:case, i, case/totalCases)
    for (j in minSharing:case)  {
                                        # for each instance of j carriers, compute the prob of having k detected
      for (k in minSharing:j) {
####  !! should be hypergeometric distribution: draw without replacement. 
                                        # modeled as binomial: j trials, p  = palter
     #   power[i+2] = power[i+2] + dbinom(j, i, case/totalCases) *dbinom(k, j, palter)
         power[i+2] = power[i+2] + dhyper(j, i, totalCases -i, case) *dbinom(k, j, palter)
        
 #       }
      }
      
      
      power[i+2] = round(power[i+2], 3)
    }
  }
  m <- rbind(m, power)
}

rownames(m) = numCases


write.table(t(m), "power-vs-rare_variants.txt", quote=FALSE, sep = "\t", row.names = T, col.names = T)
