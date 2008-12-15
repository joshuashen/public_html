### 

while line = ARGF.gets do 
  if  line=~ /^\S+\_(20460)0(\d+\_\S+)/  # control
    puts "#{$1}-#{$2}"
  elsif line=~ /^\S+\_(\S+\s+.*)/  # cases
    puts $1
  end
end

