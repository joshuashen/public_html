## 

pos = ARGV[0]

model = ARGV[1]

snp = {}

File.new(pos, 'r').each do |line|
  if line=~ /^(\S+)\s+(\d+)/
    snp[$1] = $2
  end
end

mf = File.new(model, 'r')

header = mf.readline
puts "#{header.chomp}\tBP"

while line=mf.gets
  cols= line.strip.split(/\s+/)
  rs = cols[1]
  if snp.key?(rs)
    puts "#{line.chomp}\t#{snp[rs]}"
  end
end


  
