
while line=ARGF.gets do 
  cols=line.strip.split(/\s+/)
  genotype = []
  cols[7..-1].each do |gt|
    genotype << gt.tr('1234', 'ACGT')
  end
  puts cols[0..4].join(" ") + " 1 " + genotype.join(" ")
end
