## 

file = ARGV[0]

flag = ARGV[1] or flag = "18"   # 18 means good pairs for FR reads
# SOLiD is FF, flag should be 17 for good pairs

cov = {"chrI" => [], }

File.new(file, 'r').each do |line|
  cols = line.split(/\s+/)
  chr, pos, flag, size = cols[1], cols[2], cols[5],cols[13].to_i
  
