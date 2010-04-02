# input:
# ped files and map files

# output:
# combined ped;  map

ped1 = ARGV[0] 
map1 = ARGV[1]

ped2 = ARGV[2]
map2 = ARGV[3]

markers1 = {}
markers2 = {}

File.new(map1, 'r').each do |line|
  cols = line.strip.split(/\s+/)
  snp = cols[1]
  markers1[snp] = line.chomp
end
