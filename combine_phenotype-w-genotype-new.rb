# input: 1. phenotype file, comma delimited
# 2. genotype file: "recodeA" ped output from PLINK

phenof = ARGV[0]
genof = ARGV[1]  

if phenof == nil  # no argument provided
  $stderr.puts "Usage: ruby __.rb phenotype_file genotype_recodeA_output"
  exit
end

header = ''
pheno = {}

File.new(phenof, 'r').each do |line|
  cols = line.chomp.split(',')
  if cols[0] == "ID" 
    header += cols[1..-1].join("\t")
  else
    fid = cols.shift
    pheno[fid] = []
    cols.each do |col|
      if col == "" # empty
        col = "NA"
      end
      pheno[fid] << col
    end
  end
end

File.new(genof, 'r').each do |line|
  cols = line.strip.split(/\s+/)
  # fid, gender, status, genotypes = cols[0], cols[4], cols[5], cols[6..-1]
  if cols[0] == 'ID' # header
    puts cols.join("\t") + "\t" + header
  else
    if pheno.key?(cols[0])
      puts cols.join("\t") + "\t" + pheno[cols[0]].join("\t")
    else
      $stderr.puts "warning: #{cols[0]}'s phenotype is missing"
    end
  end
end
