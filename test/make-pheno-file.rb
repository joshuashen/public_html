# input: 1. .fam  2. pheno info

fam = ARGV[0]

pinfo = ARGV[1]

header = []
info = {}
array = []

c = 0
File.new(pinfo,'r').each do |line|
  cols=line.split(',')
  c+=1
  if c == 1 ## header line
    header = cols[1..-1].join("\t")
  else
    info[cols[0]] = cols[1..-1].join("\t")
    array << cols[0]
  end
end

puts "FID\tIID\t#{header}"

File.new(fam,'r').each do |line|
  cols = line.split(/\s+/)
  fid, iid = cols[0], cols[1]
  
  array.each do |code|
    if fid.include?(code)  # match
      puts "#{fid}\t#{iid}\t#{info[code]}"
      break
    end
  end
end

