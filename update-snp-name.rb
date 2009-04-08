## 

oldMap = ARGV[0]
update = ARGV[1]

hash= {}
File.new(update,'r').each do |line|
  if line=~ /^(\S+)\s+(\S+)/
    hash[$1]= $2
  end
end

File.new(oldMap,'r').each do |line|
  cols = line.strip.split(/\s+/)
  snp = cols[1]
  if hash.key?(snp)
    snp = hash[snp]
  end

  puts "#{cols[0]}\t#{snp}\t#{cols[2]}\t#{cols[3]}"
end


