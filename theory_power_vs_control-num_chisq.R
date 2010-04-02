## calculate power curve : power vs control, using chisq-test

maf <- 0.1

# rr <- c(1.5, 2, 2.5, 3)  # relative risk

rr <- 1.5

caseN <- 265

maxT <- 50

controlN <- c(1:maxT) * caseN

pCut <- 0.00000005 

rsquare <- 0.8

qCut <- qchisq(1 - pCut, df = 1) # quantile cutoff 

power = rep(0, maxT)

for (i in 1:maxT) {

    caseFreq = rr * maf / (1 - maf + rr * maf)
    allFreq = (caseN * caseFreq + controlN[i] * maf) / (caseN + controlN[i])   

    nonCentral = 2 * caseN * controlN[i] * (caseFreq - maf) **2 * rsquare / (caseN + controlN[i]) / allFreq / (1-allFreq)

    power[i] = 1 - pchisq(qCut, df = 1, ncp = nonCentral)

}

power
