## 

# remove 6th column, 
# change 7th column to 1

while line=ARGF.gets do 
  if line=~ /^(\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+)\S+\s+\S+\s+(\S+.*)$/
    puts "#{$1}1\t#{$2}"
  end
end
