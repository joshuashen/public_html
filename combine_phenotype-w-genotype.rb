# input: 1. phenotype file, comma delimited
# 2. genotype file: "recodeA" ped output from PLINK

phenof = ARGV[0]
genof = ARGV[1]  

if phenof == nil  # no argument provided
  $stderr.puts "Usage: ruby __.rb phenotype_file genotype_recodeA_output"
  exit
end

header = []
pheno = {}
headerSize = 0

File.new(phenof, 'r').each do |line|
  cols = line.chomp.split(',')
  if cols[0] == "FID" 
    if cols[1] == "SUBJECTS"
      header += cols
      headerSize = cols.size
    end
    next
  end

  fid = cols[0]
  pheno[fid] = []
  cols.each do |col|
    if col == "" # empty
      col = "NA"
    end
    pheno[fid] << col
  end
end


File.new(genof, 'r').each do |line|
  cols = line.strip.split(/\s+/)
  fid, gender, status, genotypes = cols[0], cols[4], cols[5], cols[6..-1]
  if cols[0] == "FID" and cols[1] =="IID"  # header
    header += cols[4..-1]
    headerSize = header.size
  end
  next if status == "1"  # ignore controls
  next unless pheno.key?(fid) 
  pheno[fid] +=  [gender, status] 
  pheno[fid] += genotypes
end

puts header.join(",")
pheno.keys.sort.each do |fid|
  if pheno[fid].size >= headerSize
    puts pheno[fid].join(",")
  end
end

  
