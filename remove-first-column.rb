while line=ARGF.gets do 
  cols = line.chomp.split(/\s+/)
  
  puts cols[0..5].join(" ") + " " + cols[7..-1].join(" ") 
end
