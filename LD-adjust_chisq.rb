##

# input: 
# 1. .assoc file from PLINK -- chisq values for each SNP
# 2. LD file downloaded from HapMap.org

assoc = ARGV[0]
ldf = ARGV[1]

rsq = Hash.new {|h,k| h[k]= Hash.new}

rcutoff = 0.1  # only pairs with R^2 > rcutoff will be considered

if ldf == nil
  ldf = ""  # default path
end

File.new(ldf, 'r').each do |line|
  cols = line.split(/\s+/)
  rs1, rs2, r2 = cols[3], cols[4], cols[6].to_f
  next if r2 < rcutoff ## ignore pairs that have r^2 < 0.01
  rsq[rs1][rs] = r2
end

File.new(assoc,'r').each do |line|
  cols = line.split(/\s+/)
  next unless cols[1] =~ /^rs/
  snp[cols[1]] 


  
