## make rank statistics

f1 = ARGV[0]
f2 = ARGV[1]

stat1 = {}
stat2 = {}
rank1 = {}
rank2 = {}
File.new(f1,'r').each do |line|
  if line=~ /^(\S+)\s+(\S+)/
    stat1[$1]=$2.to_f
  end
end

File.new(f2, 'r').each do |line|
  if line=~ /^(\S+)\s+(\S+)/
    if stat1.key?($1)
      if stat2.key?($1)
        if stat2[$1] > $2.to_f
          stat2[$1]  = $2.to_f
        end
      else
        stat2[$1]  = $2.to_f
      end
    end
  end
end

n = 1
stat1.keys.sort {|a,b| stat1[a] <=> stat1[b]}.each do |rs|
  rank1[rs] = n
  n += 1
end
n = 1
stat2.keys.sort {|a,b| stat2[a] <=> stat2[b]}.each do |rs|
  rank2[rs] = n
  n += 1
end

$stderr.puts "#{rank1.size}\t#{rank2.size}\t#{stat1.size}\t#{stat2.size}"
rank1.each_key do |rs|
  if rank2.key?(rs)
    puts "#{rs}\t#{rank1[rs]}\t#{rank2[rs]}\t#{stat1[rs]}\t#{stat2[rs]}"
  end
end
