## 


while line=ARGF.gets do 
  if line=~ /^(\S+)\s+(\S+.*)$/
    puts $2
  end
end

