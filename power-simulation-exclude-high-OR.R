## post hoc power simulation for SJS study

# conditions:
# Number of cases: 49 or 70
# number of population controls :  increase from 143 to 4900:
#  143 1600 4900

# ADR prevalence: 0.0005
# ADR risk allele frequency   0.01 - 0.5, 50 levels

## case expected MAF is determined by population MAF and OR

# sample MAF: binomial(n, maf)

# Odds ratio: 2, 4, 8, 16, 32
# genetic model: additive, dominant, recessive

# caseVec <- c(9, 12, 21, 30, 49, 60, 70, 80)
caseVec <- c(9, 12, 49)
# controlVec <- c(100, 143,200, 400,800, 1600,3200, 4900, 6400)
controlVec <- c(4900)

prevalence = 0.001

# mafVec <- 2:100/200
mafVec <- c(0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1, 0.11, 0.12, 0.13, 0.14, 0.15, 0.16, 0.17, 0.18, 0.19, 0.2, 0.225, 0.25, 0.275, 0.3, 0.325,0.35, 0.375, 0.4, 0.45,  0.5, 0.6, 0.7, 0.8, 0.9)

#oddsVec <- c(2, 2.5, 3, 3.25, 3.5 , 3.75,  4 , 4.25, 4.5, 4.75, 5, 5.5, 6,7,8,9,10, 11, 12,13)
oddsVec <- c( 3, 3.5, 4, 4.1, 4.2,4.3, 4.4, 4.5, 4.6,  4.7, 4.8,  5, 5.2, 5.4, 5.6, 5.8, 6,7, 8, 9,11, 15, 20, 25, 30, 40, 50)

## PAF :population attributable faction
# PAF = p*(RR-1) / (p*(RR-1) + 1)   or PAF = 

simulation = 5000

output = "power_simulation.csv"

write.table(t(c("# NumCases", "NumControls", "MAF", "OR", "power", "p-value_CutOff")), file = output, quote = F, sep = "\t", row.names = F, col.names = F)

pCutOff = 0.00000005   # genome-wide significance 5x10^-8

for (maf in mafVec) {
  for (oddsratio in oddsVec ) {
    for (control in controlVec) {

      ## because OR = x * (1-MAF) / [(1-x) * MAF]
      caseMaf = oddsratio * maf / (1-maf + oddsratio * maf)
      
      caseinControls = round(control * prevalence )
      
    ## a is the case alleles, b is the control alleles
      bVec = rbinom( simulation ,round(control * (1 - prevalence)) * 2, maf) + rbinom(simulation, caseinControls * 2, caseMaf)

      for (case in caseVec) {
        aVec = rbinom(simulation, case * 2, caseMaf)
        
        # a = c(case*2*caseMaf, case*2 * (1-caseMaf))
        times = 0
        for (i in 1:simulation) {
          a = c(aVec[i], case*2 - aVec[i])
          b = c(bVec[i], control*2 - bVec[i])
          p = fisher.test(cbind(a,b))$p.value
          if (p < pCutOff) {
            times = times + 1
          }
        }
        power = round(times / simulation, digits = 3)
        write.table(t(c(case, control, maf, oddsratio, power, "cutoff:5e-8")), file = output, append = T , quote = F, sep = "\t", row.names = F, col.names = F)

        

        
       # print(c(case, control, maf, oddsratio, power[1], "cutoff:1e-7"))
       # print(c(case, control, maf, oddsratio, power[2], "cutoff:5e-8"))
                           #          print(c(case, control, maf, oddsratio, -log10(p)))
      }
    }
  }
}
