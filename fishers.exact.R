ftest <- function(a=0, b=0, m=0, n=0)
{
	x <- c(a,b)
	y <- c(m,n)
	z = cbind(x,y)
	return (fisher.test(z))
	
}