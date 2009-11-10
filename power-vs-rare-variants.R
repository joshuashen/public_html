# numCases <- c(20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100)
numCases <- c(20,40,60,80)
totalCases <- 100

numControls <- 400

maxShare = 60

# typeIerror <- 0.00000005
typeIerror <- 0.000005

# first column is the power of overall cases
m <- matrix(,nrow=0, ncol=40)

simulation = 5000 

for (i in 1:(maxShare-1) ) {
  power=rep(0,(maxShare-1))

  p = fisher.test(cbind(c(i + 1, totalCases - i -1), c(0,numControls)))$p.value
  power[i] = round(p, 2)
  m <- rbind(m, power)

}

write.table(t(m), "power-vs-rare_variants.txt", quote=FALSE, sep = "\t", row.names = F, col.names = F)



for (case in numCases){
	power = rep(0,(maxShare-1))
	b = c(0, numControls)

  
	for (i in 1:(maxShare -1)) {
#		n = rbinom(simulation, i , case / totalCases)
		
                pd = dbinom(c(0:numCases), i + 1, case/totalCases)

                cump = 0
                for (j in 0:numCases) {
                  a = c(j, case - j)
                  
                  p = fisher.test(cbind(a,b))$p.value
                  if (p < typeIerror) {
                    cump = cump + pd[j]
                  }

                }
                  
#		for (j in 1:simulation) {
#			a = c(n[j], case - n[j])
#			p = fisher.test(cbind(a,b))$p.value
#			if (p < typeIerror) {
#				nn = nn + 1	
#				}
#			
#			}
		power[i] = round(cump, 2)
		}
	m <- rbind(m, power)
	}
	
# write.table(t(m), "power-vs-rare_variants.txt", quote=FALSE, sep = "\t", row.names = F, col.names = F)
