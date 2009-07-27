## post hoc power simulation for SJS study

# conditions:
# Number of cases: 49 or 70
# number of population controls :  increase from 143 to 4900:
#  143 1600 4900

# ADR prevalence: 0.0005
# ADR risk allele frequency   0.01 - 0.5, 50 levels

## case expected MAF is determined by population MAF and OR

# sample MAF: binomial(n, maf)

# genetic model: additive, dominant, recessive

caseVec <- c(9, 12, 49)

controlVec <- c(4900)

prevalence = 0.001

# mafVec <- 2:100/200
# mafVec <- c(0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1, 0.11, 0.12, 0.13, 0.14, 0.15, 0.16, 0.17, 0.18, 0.19, 0.2, 0.225, 0.25, 0.275, 0.3, 0.325,0.35, 0.375, 0.4, 0.45,  0.5, 0.6, 0.7, 0.8, 0.9)

mafVec <- c(0.02, 0.04, 0.06, 0.08, 0.1, 0.12, 0.14, 0.16, 0.18, 0.2, 0.22, 0.24, 0.26, 0.28, 0.3, 0.35, 0.4, 0.45, 0.5 )

# mafVec <- c(0.27)

pafVec <- c(0.02, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5, 0.55,0.6,0.65,0.7,0.75,0.8,0.85, 0.9, 0.95)

# oddsVec <- 2
## PAF :population attributable faction
# PAF = p*(RR-1) / (p*(RR-1) + 1)   or

# OR = PAF / MAF(1-PAF) + 1

# maf_case = PAF + maf_control * (1-PAF)

simulation = 1000

output = "power_simulation.csv"

write.table(t(c("# NumCases", "NumControls", "MAF", "PAF", "power", "p-value_CutOff", "OR")), file = output, quote = F, sep = "\t", row.names = F, col.names = F)

pCutOff = 0.00000005   # genome-wide significance 5x10^-8

for (maf in mafVec) {
  for (paf in pafVec ) {
    for (control in controlVec) {
      oddsratio = paf / (maf * (1-paf)) + 1
      
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
        write.table(t(c(case, control, maf, paf, power, "cutoff:5e-8", oddsratio)), file = output, append = T , quote = F, sep = "\t", row.names = F, col.names = F)

        

        
       # print(c(case, control, maf, oddsratio, power[1], "cutoff:1e-7"))
       # print(c(case, control, maf, oddsratio, power[2], "cutoff:5e-8"))
                           #          print(c(case, control, maf, oddsratio, -log10(p)))
      }
    }
  }
}
