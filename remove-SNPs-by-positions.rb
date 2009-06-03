## 

prefix = ARGV[0]
ranges = ARGV[1]

File.new(ranges,'r').each do |line|
  cols= line.split(/\s+/)
  
