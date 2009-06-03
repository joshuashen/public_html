## input:
# 1. target SNP list
# 2. all SNPs on a chip -- bim file, 
# 3. LD

targetFile = ARGV[0]
bimFile = ARGV[1]
ldFile = ARGV[2]

targets = {}
onchip = {}

File.new(targetFile,'r').each do |line|
  if line=~ /^(\S+)/
    targets[$1] = {}
  end
end

File.new(bimFile, 'r').each do |line|
  cols = line.strip.split(/\s+/)
  onchip[cols[1]] = 1
end

File.new(ldFile,'r').each do |line|
  cols = line.strip.split(/\s+/)
  s1, s2, r2 = cols[3], cols[4], cols[6].to_f
  if targets.key?(s1) and onchip.key?(s2)
    
    targets[s1][s2] = r2
  end
  
  if targets.key?(s2) and onchip.key?(s1)
    targets[s2][s1] = r2
  end
end

targets.each_key do |snp|
  if onchip.key?(snp)
    puts "#{snp}\t#{snp}\tNA"
  elsif targets[snp].keys.size > 0 
    bestProxy = targets[snp].keys.sort {|a,b| targets[snp][b] <=> targets[snp][a]}[0]
    puts "#{snp}\t#{bestProxy}\t#{targets[snp][bestProxy]}"
  else
    puts "#{snp}\tNA\tNA"
  end
end


