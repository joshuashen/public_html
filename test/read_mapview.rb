## test speed of reading mapview file

f = ARGV[0]

File.new(f, 'r').each do |line|
  cols = line.split(/\s+/)
  ref, pos, dir, dist, flag = cols[1], cols[2].to_i, cols[3], cols[4].to_i, cols[5]
end

