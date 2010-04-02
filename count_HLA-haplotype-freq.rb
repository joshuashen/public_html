

# input: (1) haplotypes of all subjects (2) haplotype of interest

hapf = ARGV[0]
gt = ARGV[1]

haps = []
hcount = {}  # haplotype count
carrier = {}  # carrier s

File.new(hapf, 'r').each do |line|
  if line=~ /^(\S+)/
    haps << $1
    hcount[$1] = 0
    carrier[$1] = {}
   end
end

total = 0
File.new(gt, 'r').each do |line|
  cols = line.strip.split(/\s+/)
  fid, hap = cols[0], cols[1]
  if hcount.key?(hap) 
    hcount[hap] += 1
    carrier[hap][fid] = 1
  end
  total += 1
end

haps.each do |hap|
  afreq = hcount[hap] / total.to_f
  cfreq = carrier[hap].keys.size / total.to_f * 2
  puts "#{hap}\t#{hcount[hap]}\t#{carrier[hap].keys.size}\t#{afreq.round(4)*100}% (#{cfreq.round(4)*100}%)"
end

  
