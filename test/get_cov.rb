## 

list = ARGV[0]

file = ARGV[1]

File.new(list, 'r').each do |line|
  if line=~ /^(\S+)\s+()/
