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
caseVec <- c(49, 55, 60,  65, 70, 75, 80, 85, 90)
# controlVec <- c(100, 143,200, 400,800, 1600,3200, 4900, 6400)
controlVec <- c(143, 400,  4900)

prevalence = 0.001

# mafVec <- 2:100/200
mafVec <- c(0.05, 0.1)

#oddsVec <- c(2, 2.5, 3, 3.25, 3.5 , 3.75,  4 , 4.25, 4.5, 4.75, 5, 5.5, 6,7,8,9,10, 11, 12,13)
oddsVec <- c(3,  3.5 ,  4 )

simulation = 1000

output = "power_simulation.csv"

write.table(t(c("# NumCases", "NumControls", "MAF", "OR", "power", "p-value_CutOff")), file = output, quote = F, sep = "\t", row.names = F, col.names = F)

pCutOff = c(0.000001, 0.00000005)   # genome-wide significance 5x10^-8

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
        times = c(0,0)
        for (i in 1:simulation) {
          a = c(aVec[i], case*2 - aVec[i])
          b = c(bVec[i], control*2 - bVec[i])
          p = fisher.test(cbind(a,b))$p.value
          if (p < pCutOff[2]) {
            times[1] = times[1] + 1
            times[2] = times[2] + 1
          } else if (p < pCutOff[1]) {
            times[1] = times[1] + 1
          }
        }
        power = round(times / simulation, digits = 2)
        write.table(t(c(case, control, maf, oddsratio, power[1], "cutoff:1e-6")), file = output, append = T , quote = F, sep = "\t", row.names = F, col.names = F)
        write.table(t(c(case, control, maf, oddsratio, power[2], "cutoff:5e-8")), file = output, append = T , quote = F, sep = "\t", row.names = F, col.names = F)
        

        
       # print(c(case, control, maf, oddsratio, power[1], "cutoff:1e-7"))
       # print(c(case, control, maf, oddsratio, power[2], "cutoff:5e-8"))
                           #          print(c(case, control, maf, oddsratio, -log10(p)))
      }
    }
  }
}
