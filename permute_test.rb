## permutation, test the significance of find blocks of significant SNPs

##
# 1. randomly switch case and control labels
# 2. compute single-locus chisq/p-value via PLINK
# 3. compute weighted "LD-adjusted" chisq by  SUM(chisq * (r^2)) / SUM(r^2) , r^2 is LD; 
## only look for SNPs within 0.5cm, and r^2 > 0.1


prefix = ARGV[0]

output = ARGV[1]

fam = prefix + '.fam'

cases = 0
samples = []

File.new(fam, 'r').each do |line|
  cols = line.chomp.split(/\s+/)
  if cols[-1] == '2' # case
    cases += 1
  end

  samples << cols[0..4].join(" ")
end

bed = output + '.bed'
ofam = File.new(output + '.fam', 'w')
bim = output + '.bim'
system("ln -s #{prefix}.bed #{bed}")
system("ln -s #{prefix}.bim #{bim}")

## randomly choose cases:

neworder = (0..samples.size-1).to_a.sort_by {rand}

neworder[0..cases-1].each do |i|
  samples[i] += " 2"  # cases
end

neworder[cases..samples.size-1].each do |i|
  samples[i] += ' 1'  # controls
end

ofam.puts samples.join("\n")

ofam.close
