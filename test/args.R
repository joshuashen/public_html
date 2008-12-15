args <- commandArgs(TRUE)

a <- 2 

b <- args[1]

paste(a, "  Hello", sep="_" )

if(is.na(b)) {
  paste("b is null")
  b = 3
} else {
  b = as.numeric(b)
}

c = a/b

paste(c)
