#### 
# just merge the corresponding rows. 

f1 = ARGV[0]
f2 = ARGV[1]

cols=[]

File.new(f1, 'r').each do |line|
  line.chomp!
  cols << line
end

File.new(f2, 'r').each do |line|
  x = cols.shift
  puts "#{x}\t#{line.chomp}"
end
