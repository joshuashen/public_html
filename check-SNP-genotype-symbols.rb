
gtf = ARGV[0]

snps = {}

File.new(gtf,'r').each do |line|
  cols = line.chomp.split(',')
  next if cols[1] == '-' or cols[2] == '-'
  
  if !snps.key?(cols[0])
    snps[cols[0]] = {}
  end

  if !snps[cols[0]].key?(cols[3])
    snps[cols[0]][cols[3]] = cols[1]
  end
  
  if !snps[cols[0]].key?(cols[4])
    snps[cols[0]][cols[4]] = cols[2]
  end
  
end

snps.keys.sort.each do |rs|
  if snps[rs].key?("A") and snps[rs].key?("B")
    puts "#{rs}\t#{snps[rs]["A"]}\t#{snps[rs]["B"]}"
  end
end


  
