## input: i-ID, map, fam

iID = ARGV[0]
mapping = ARGV[1]
fam = ARGV[2]

subjects = {}
map = {}

File.new(fam, 'r').each do |line|
  line.chomp!
  if line=~/^(\S+)\s+/
    subjects[$1] = line
  end
end

File.new(mapping, 'r').each do |line|
  if line=~ /^(\S+)\s+(\S+)/
    map[$1] = $2
  end
end

File.new(iID, 'r').each do |line|
  line.chomp! 
  if line =~ /^(\S+)/
    if map.key?($1)
      oID = map[$1]
      if subjects.key?(oID)
        puts "#{line}\t#{subjects[oID]}"
      else
        $stderr.puts "#{line}\tNo fam"
      end
    else
      $stderr.puts "#{line}\tNo mapping"
    end
  end
end
