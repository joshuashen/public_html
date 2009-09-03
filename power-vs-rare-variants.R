numCases <- c(20,40,60)
totalCases <- 70

numControls <- 400

# typeIerror <- 0.00000005
typeIerror <- 0.00005

m <- matrix(,nrow=0, ncol=19)

simulation = 1000 

for (case in numCases){
	power = rep(0,19)
	b = c(0, numControls)	
	for (i in 1:19) {
		n = rbinom(simulation, i + 1, case / totalCases)
		nn = 0
		for (j in 1:simulation) {
			a = c(n[j], case - n[j])
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