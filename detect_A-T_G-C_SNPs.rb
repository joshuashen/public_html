# input file: .bim
# output: SNP id

while line=ARGF.gets do 
  cols= line.strip.split(/\s+/)
  rs,a1,a2 = cols[1], cols[4], cols[5]
  
  if (a1 == "A" and a2 == "T") or (a1 =="T" and a2 =="A") or (a1 =="G" and a2 =="C") or (a1=="C" and a2 =="G") 
    puts rs
  end
end


    
