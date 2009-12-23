# change ID from 0471002G_QU0046 back to 0471-02G_QU0046

inputf = ARGV[0]
oldidf = ARGV[1]

map = {}
File.new(oldidf, 'r').each do |line|
  if line=~ /^(\S+)/
    ori =  $1
    mut = ori.tr('-', '0')
    map[mut] = ori
  end
end

File.new(inputf, 'r').each do |line|
  cols = line.chomp.split(/\s+/)
  fid = cols[1]
  if map.key?(fid)
    fid = map[fid]
  end
  puts "#{cols[0]}\t#{fid}\t#{cols[2..-1].join("\t")}"
end

