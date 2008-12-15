## change phenotype in ped files

while line=ARGF.gets do 
  cols = line.split(/\s+/)
  puts "#{cols[0..4].join("\s")} 1 #{cols[6..-1].join("\s")}"
end
