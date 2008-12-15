##  for one SNP, input: frequency of AA/AB/BB

naa = ARGV[0].to_i
nab = ARGV[1].to_i

nbb = ARGV[2].to_i


1.upto(naa) do |i|
  puts "sample#{i} 1 0 0 2 1 A A"
end

(naa+1).upto(naa+nab) do |i|
  puts "sample#{i} 1 0 0 2 1 A B"
end

(naa+nab+1).upto(naa+nab+nbb) do |i|
  puts "sample#{i+1} 1 0 0 2 1 B B"
end

