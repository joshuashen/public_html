args <- commandArgs(TRUE)

source("~/script/qqplot.R")

histqq(args[1], args[2])

# print(args[1])
# print(args[2])
