## 

while line=ARGF.gets do 
  if line=~ /^(\S+)\_204600(\d+\_\S+)/ 
    puts "20460-#{$2}"
  end
end
