# two files: use the first column of one file to grep the other file, then combine

f1 = ARGV[0]
f2 = ARGV[1]

strings = {}

File.new(f1,'r').each do |line|
  cols = line.strip.split(/\s+/)
  strings[cols[0]] = line
end

File.new(f2, 'r').each do |line|
  if f2=~/^(\S+)/
    name = $1
    strings.keys.each do |s|
      if name.grep(s)
