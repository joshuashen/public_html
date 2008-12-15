## 

while line=ARGF.gets do 
  if line=~ /^(\s*)23\s+(.*)/
    puts "#{$1}X\t#{$2}"
  else
    puts line
  end
end
