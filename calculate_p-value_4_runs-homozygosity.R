##

args <- commandArgs(TRUE)

input <- args[1]

case <- as.numeric(args[2])
control <- as.numeric(args[3])

output = paste(input, "stat", sep=".")
a <- read.table(input)

z <- dim(a)[1]  # number of lines

b <- rep(1, z)

for (i in 1:z) {
  x <- cbind(c(a[i,2], case - a[i,2]), c(a[i,3], control - a[i,3]))
  y <- fisher.test(x)
  b[i] <- y[1]$p.value
}

write.table(cbind(a,b), output, quote=F, col.names=F, row.names=F)
