### robot to do WGA: association, qq-plot, manhattan plot

prefix = ARGV[0]

assoc = prefix + '_assoc' 

# PLINK
system("plink --bfile #{prefix} --geno 0.05 --maf 0.01 --hwe 0.0000001 --mind 0.1 --assoc --adjust --out #{assoc}")

out = assoc + '.assoc'

# qq-plot
Process.fork {
  system("Rscript ~/script/qqplot_chisq.R #{out} Chi-square");
}

# manhattan
system("Rscript ~/script/manhattan_plot.R #{out} Manhattan");

