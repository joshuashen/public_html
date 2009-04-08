##

pcaComp = ARGV[0]
bim = ARGV[1]
evec = ARGV[2]

if evec == nil
  evec  = 1
else
  evec = evec.to_i
end

$snps = {}
$intermediate = File.new(pcaComp + "_evec#{evec}_loading", "w")

File.new(bim, 'r').each do |line|
  cols= line.split(/\s+/)
  $snps[cols[1]] = cols[3]
end

$stderr.puts "# of SNPs loaded: #{$snps.size}"
  
File.new(pcaComp,'r').each do |line|
  cols = line.strip.split(/\s+/)
  if $snps.key?(cols[0])  # find position
    $intermediate.puts "#{cols[0]}\t#{cols[1]}\t#{$snps[cols[0]]}\t#{cols[2+evec]}"
  end
end

$intermediate.close

