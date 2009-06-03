## input: ID with covariants; fam

covar = ARGV[0]
fam = ARGV[1]

name = {}

File.new(fam, 'r').each do |line|
  cols = line.chomp.split(/\s+/)
  fid, iid = cols[0], cols[1]
  if fid =~ /^(\S+)\_(\S+)/
    name[$2] = "#{fid}\t#{iid}"
  end
end


File.new(covar, 'r').each do |line|
  cols = line.chomp.split(/\s+/)
  if name.key?(cols[0])
    puts "#{name[cols[0]]}\t#{cols[1..-1].join("\t")}"
  end
end

