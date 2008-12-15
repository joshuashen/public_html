scores=function(x,MARGIN=1,method="table",...)
{
	# MARGIN
	#	1 - row
	# 	2 - columns

	# Methods for ranks are
	#
	# x - default
	# rank
	# ridit
	# modridit
	
	if (method=="table")
	{
		if (is.null(dimnames(x))) return(1:(dim(x)[MARGIN]))
		else {
			options(warn=-1)
			if
(sum(is.na(as.numeric(dimnames(x)[[MARGIN]])))>0)
			{
				out=(1:(dim(x)[MARGIN]))
			}
			else
			{
			out=(as.numeric(dimnames(x)[[MARGIN]]))
			}
			options(warn=0)
		}
	}
else	{
	### method is a rank one
	Ndim=dim(x)[MARGIN]
	OTHERMARGIN=3-MARGIN
	
ranks=c(0,(cumsum(apply(x,MARGIN,sum))))[1:Ndim]+(apply(x,MARGIN,sum)+1)/2
	if (method=="ranks") out=ranks
	if (method=="ridit") out=ranks/(sum(x))
	if (method=="modridit") out=ranks/(sum(x)+1)
	}
	
	return(out)
}

