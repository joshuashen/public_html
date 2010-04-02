### add genetic  distances to .map file

mapf = ARGV[0]
stdmap = ARGV[1]

if mapf == nil
  $stderr.puts "Usage: ruby __.rb foo.map [standard] > foo.map.new"
  exit
end

if stdmap == nil
  stdmap = "/ifs/home/c2b2/af_lab/saec/data/GenotypingPlatforms/Illumina1M/illumina1M.sorted.map"
end


geneticDis = {}

File.new(stdmap, 'r').each do |line|
  cols=line.strip.split(/\s+/)
  rs,gd = cols[1], cols[2]
  geneticDis[rs] = gd
end

File.new(mapf, 'r').each do |line|
  cols = line.strip.split(/\s+/)
  chr,rs,gd,pos = cols[0..-1]
  if geneticDis.key?(rs)
    gd = geneticDis[rs]
  end
  puts "#{chr}\t#{rs}\t#{gd}\t#{pos}"
end

