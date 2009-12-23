# input: 1. cases FID  2. strata
# strata format: 
# 2008040808      1       13
# 0660-11C_41884  1       13
# 0660-09H_44942  1       13
# 0660-12C_29824  1       13
# 0661-03A_38803  1       13
# 0660-04F_49440  1       13

casef = ARGV[0]
strataf = ARGV[1]

cases = {}
File.new(casef, 'r').each do |line|
  if line=~ /^(\S+)/
    cases[$1] = []
  end
end

flag = 0
str = -1
File.new(strataf, 'r').each do |line|
  cols = line.chomp.split(/\s+/)
  fid, iid, strata = cols[0], cols[1], cols[2]
  if cases.key?(fid)
    puts "#{fid}\t#{iid}"
    flag = 1
    str = strata
  else
    if strata == str # control
      puts "#{fid}\t#{iid}"
    else
      flag = 0
    end
  end
end

