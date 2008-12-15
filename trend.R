tabletrend=function(x,transpose=FALSE) 
{ 
  if (any(dim(x)==2)) 
    { 
      if (transpose==TRUE) { 
        x=t(x) 
      } 
      
      if (dim(x)[2]!=2){stop("Cochran-Armitage test for trend must be used with 
a (R,2) table. Use transpose argument",call.=FALSE) } 
      
      nidot=apply(x,1,sum) 
      n=sum(nidot) 
     #  Ri=scores(x,1,"table")
      Ri = 1:dim(x)[1]
      Rbar=sum(nidot*Ri)/n 
      
      s2=sum(nidot*(Ri-Rbar)^2) 
      pdot1=sum(x[,1])/n 
      T=sum(x[,1]*(Ri-Rbar))/sqrt(pdot1*(1-pdot1)*s2) 
      p.value.uni=1-pnorm(abs(T)) 
      p.value.bi=2*p.value.uni 
      out=list(estimate=T,dim=dim(x),p.value.uni=p.value.uni,p.value.bi=p.value.bi,name="Cochran-Armitage 
test for trend") 
      return(out) 
      
    } 
  else {stop("Cochran-Armitage test for trend must be used with a (2,C) or a 
(R,2) table",call.=FALSE) } 
} 

