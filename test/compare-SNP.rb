##

f1 = ARGV[0]

f2 = ARGV[1]

snp = {}
co = 0
s2 = 0
File.new(f1,'r').each do |line|
  if line=~ /^(\S+)\s+(\d+)/
    s= $1 + '_' + $2
    snp[s] = 1
  end
end

File.new(f2,'r').each do |line|
  if line=~ /^(\S+)\s+(\d+)/
    s= $1 + '_' + $2
    if snp.key?(s)
      co += 1
    else
      s2 += 1
    end
  end
end

s1 = snp.size - co

puts "common: #{co}"
puts "unique to 1st:  #{s1}"
puts "unique to 2nd:  #{s2}"
