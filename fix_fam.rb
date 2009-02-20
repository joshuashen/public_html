## 
targetFam = ARGV[0]
goodFam = ARGV[1]

strings = {}
File.new(goodFam, 'r').each do |line|
  cols=line.chomp.split(/\s+/)
  strings[cols[0]] = cols[1..4].join(" ")
end

File.new(targetFam, 'r').each do |line|
  cols = line.chomp.split(/\s+/)
  puts "#{cols[0]} #{strings[cols[0]]} #{cols[5]}"
end

