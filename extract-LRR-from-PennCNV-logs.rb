puts "#Sample\tLRR_mean\tLRR_SD"
while line = ARGF.gets do 
  if line=~ /quality\s+summary\s+for\s+(\S+)\.txt\:\s+LRR\_mean\=(\S+)\s+LRR\_median\=(\S+)\s+LRR\_SD\=(\S+)\s+/
    sample, mean, sd = $1, $2.to_f, $4.to_f
    puts "#{sample}\t#{mean}\t#{sd}"
  end
end
    
