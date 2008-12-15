## combine two files

f1 = ARGV[0]
f2 = ARGV[1]


common={}

File.new(f1,'r').each do |line|
  if line=~ /^\s*(\S+)\s+/
    common[$1] = line.chomp
  end
end


File.new(f2,'r').each do |line|
  line.chomp
  if line=~ /^\s*(\S+)\s+(.*)$/
    if common.key?($1)
      puts "#{common[$1]}\t#{$2}"
    end
  end
end

