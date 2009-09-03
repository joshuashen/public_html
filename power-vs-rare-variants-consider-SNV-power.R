# also consider the power of SNV detection

gsize = 3000000000  # genome size
depthCov = 60
targetSamples = 20
totalBp = depthCov * gsize * targetSamples
gshape = 8  ## shape parameters in Gamma distribution
minDepth = 3  # min Depth-coverage of a haploid for SNV detection

numCases <- c(20,40,60)
totalCases <- 70

numControls <- 400

typeIerror <- 0.00000005
#typeIerror <- 0.00005

m <- matrix(,nrow=0, ncol=19)

simulation = 1000 

for (case in numCases){
	depthCov = totalBp / gsize / case  
	power = rep(0,19)
	b = c(0, numControls)	
	for (i in 1:19) {
		# number of cases that are carriers
		n = rbinom(simulation, i + 1, case / totalCases)
	
		# number of carriers detected separately
		
			
	
		nn = 0
		for (j in 1:simulation) {
			# number of carriers 
			carriers = n[j]
			carriersDetected = 0
			
			# depth-coverage 
			dv = rgamma(n[j], gshape, 2 * gshape / depthCov )
	
			if (sum(dv) >= minDepth ) {
				
				## pooled 
			#	carriersDetected = length(dv[dv >= 1])
				
				# separately 
				carriersDetected = length(dv[dv >= minDepth])
				}
			
			
	#		carriersDetected = length(dv[dv >= minDepth])
	#		pooled = length(dv[dv >= 1])	 	
	#		for (k in 1:n[j]) {
	#			dv[k]
	#			if (dv[k] >= minDepth ) {
	#				
	#				hapDepth = rbinom(1, dv[k], 0.5);	#				if ( minDepth <= hapDepth  ) {
	#					carriersDetected = carriersDetected + 1
	#					}
	#				}
	#			}
			
			a = c(carriersDetected, case - carriersDetected)
			p = fisher.test(cbind(a,b))$p.value
			if (p < typeIerror) {
				nn = nn + 1	
				}
			
			}
		power[i] = round(nn / simulation, 2)
		}
	m <- rbind(m, power)
	}
	
write.table(t(m), "power-vs-rare_variants.txt", quote=FALSE, sep = "\t", row.names = F, col.names = F)