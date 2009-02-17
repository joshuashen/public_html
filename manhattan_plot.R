args <- commandArgs(TRUE)

# SNP location
# chrFP <- "/nfs/apollo/2/c2b2/users/saec/SJS/usr/bernd/data/Human1M_chrom_loc.txt"

## args[1] should be the PLINK --assoc output

assocf <- args[1]
# gpName <- args[2]

assoc <- read.table(assocf, header=TRUE, na.strings = "NA")
# fp <- args[2]


fp <- paste(assocf, "Manhattan.png", sep="_")

# chr <- read.delim(chrFP, sep=" ", header=TRUE,colClasses=c("character","character","numeric"))

# asschr <- merge.data.frame(chr,assoc,by.x="SNP", by.y="V1")


chrs   <- c("1","2", "3", "4", "5", "6", "7", "8", "9" , "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23")
chrsLabel   <- c("1","2", "3", "4", "5", "6", "7", "8", "9" , "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "X")
maxs   <- c(0  ,0  ,0   ,0   ,0   ,0   ,0   ,0   ,0    ,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,   0)
tics   <- c(0  ,0  ,0   ,0   ,0   ,0   ,0   ,0   ,0    ,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,   0)

j=0
for (i in chrs){
  j = j + 1
  maxs[j+1] <- maxs[j] +  max(subset(assoc,assoc$CHR==i)$BP)
  tics[j] <- maxs[j] + max(subset(assoc,assoc$CHR==i)$BP)/2
}
maxs

m<-max(maxs)

ymaxx = max(-log10(assoc$P)) + 0.5 

# plTitle <- paste("Assoc. p-value vs chromosomal position (ALL, ", gpName, ")", sep="")
# postscript(file = fp, paper = 'special', width = 18, height = 6, horizontal = FALSE, onefile = FALSE, family = "ComputerModern")

# png(filename = fp, width=2400, height=800 )
png(filename = fp, width=1200, height=800 )

# plot(c(0,0),c(0,0), xlim=c(0,m), ylim=c(0,ymaxx), type="o", col="1",  axes=FALSE, xaxs="i",yaxs="i", main=plTitle, xlab="Chromosome", ylab="-log10(P)")

par(cex.lab=2)
par(cex.axis=2)
par(mar=c(5, 5, 2, 2)) # margins, bottom, left, top, right
plot(c(0,0),c(0,0), xlim=c(0,m), ylim=c(0,ymaxx), type="o", col="1",  axes=FALSE, xaxs="i",yaxs="i",  xlab="Chromosome", ylab="-log10(p-value)")
axis(1, labels=chrsLabel, at=tics)
axis(2, labels=T)
# title(main=plTitle, xlab="Chromosome", ylab="-log10(P)")
par(new=T)
j=0
for (i in chrs){
  j = j + 1
  tt<-subset(assoc,assoc$CHR==i)
  if ( (j %% 2) == 1) {
    coll <- "lightblue"
  }else{ coll <- "darkblue"}

  ## big p-values:
  bigp = tt[tt$P>0.000001, ]
  
  points(maxs[j]+bigp$BP,-log10(bigp$P), type="p", col=coll, pch = 20)

  xx = tt[tt$P<=0.000001, ]
  yy = tt[tt$P<=0.0000001, ]

  points(maxs[j]+xx$BP, -log10(xx$P),  type="p", col="green", pch=20)
  points(maxs[j]+yy$BP, -log10(yy$P),  type="p", col="red", pch=20)
  
  par(new=T)
}
dev.off()



## histqq(args[1], args[2])

