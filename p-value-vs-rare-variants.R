numCases <- c(70)
numControls <- 400

m <- matrix(, nrow=0, ncol=19)

for (case in numCases) 
{
	x = 1:19
	for (i in 1:19) 
	{
		n = i + 1
		a = c(n, case - n)
		b = c(0,numControls)
		x[i] = signif(fisher.test(cbind(a,b))$p.value, 2)

	}
	m <- rbind(m,x)	
}

write.table(t(m), "temp.out", quote=FALSE, sep = "\t", row.names = F, col.names = F)