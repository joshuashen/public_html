## 

male = ARGV[0]
fam = ARGV[1]

hash = {}
File.new(male,'r').each do |line|
  if line=~ /^(\S+)/
    hash[$1] = 1
  end
end

File.new(fam,'r').each do |line|
  line.chomp!
  cols=line.split(/\s+/)
  if hash.key?(cols[0])  # change to male
    puts "#{cols[0..3].join(" ")} 1 #{cols[5]}"
  else
    puts line
  end
end


