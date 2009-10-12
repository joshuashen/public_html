## 

bimf = ARGV[0]
rangesf = ARGV[1]

ranges = {}

File.new(rangesf,'r').each do |line|
  cols= line.split(/\s+/)
  chr, s, e = cols[0], cols[1], cols[2]
  s = (s.to_f * 1000000).to_i
  e = (e.to_f * 1000000).to_i
  
  if !ranges.key?(chr)
    ranges[chr] = []
  end

  ranges[chr] << [s,e]
end

File.new(bimf, 'r').each do |line|
  cols = line.strip.split(/\s+/)
  chr, rs, pos = cols[0], cols[1], cols[3].to_i
  if ranges.key?(chr)
    ranges[chr].each do |seg|
      if pos > seg[0] and pos < seg[1]
        puts line
        break
      end
    end
  end
end

