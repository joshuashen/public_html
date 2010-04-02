## input: 1. bad fam, 2. good fam
# output: replace phenotype info in bad fam with that from good fam


bfam = ARGV[0]
gfam = ARGV[1]

pheno = {}
File.new(gfam, 'r').each do |line|
  cols = line.strip.split(/\s+/)
  pheno[cols[0]] = line.chomp
end

File.new(bfam, 'r').each do |line|
  cols = line.strip.split(/\s+/)
  if pheno.key?(cols[0])
    puts pheno[cols[0]]
  else
    puts line.chomp
  end
end
