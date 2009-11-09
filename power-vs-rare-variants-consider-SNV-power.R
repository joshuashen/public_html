# also consider the power of SNV detection

gsize = 3000000000  # genome size
depthCov = 30
targetSamples = 20
totalBp = depthCov * gsize * targetSamples
gshape = 8  ## shape parameters in Gamma distribution
minDepth = 3  # min Depth-coverage of a haploid for SNV detection

minPooledDepthInd = 1
minPooledDepth = 3

numCases <- c(20,40,60)
totalCases <- 70

numControls <- 400

# typeIerror <- 0.00000005
typeIerror <- 0.000005

m <- matrix(,nrow=0, ncol=19)

simulation = 1000 

for (case in numCases){
  depthCov = totalBp / gsize / case  
  b = c(0, numControls)	

# calculate min number of cases sharing a variant in order to get p-value < typeIerror 
  minSharing = 1
  for (i in 2:case) {
      a = c(i, case - i)
      p = fisher.test(cbind(a,b))$p.value
      if (p < typeIerror) {
      	 minSharing = i
      	 break
      }
  }
  
  power = rep(0,19)
  

  for (i in 1:19) {
      if (i+1 < minSharing) {
      	 power[i] = 0 
      } else {
		# number of cases that are carriers
	 n = rbinom(simulation, i + 1, case / totalCases)

         nn = 0
         for (j in 1:simulation) {
			# number of carriers 
	    carriers = n[j]

	    carriersDetected = 0
	    if (n[j]>= minSharing) {
	    # depth-coverage per base --> need to round
	    dv = round(rgamma(n[j], gshape,  gshape / depthCov ) )

	    hapDepth = rep(0, n[j])

	    for (k in 1:n[j]) {
	           hapDepth[k] = rbinom(1, dv[k], 0.5);
            }

            carriersDetected = length(hapDepth[hapDepth >= minDepth ])		
    #if (sum(hapDepth) >= minPooledDepth ) {
    #carriersDetected = length(hapDepth[hapDepth >= minPooledDepthInd])
     #}

     if (carriersDetected >= minSharing){
     nn = nn + 1	
        }
      }
     }
     power[i] = round(nn / simulation, 2)
   }
  }
  m <- rbind(m, power)
}

write.table(t(m), "power-vs-rare_variants.txt", quote=FALSE, sep = "\t", row.names = F, col.names = F)
