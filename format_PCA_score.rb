# input: 1. PCA score, 2. subject cohort info
#


pca = ARGV[0]
info = ARGV[1]

eigen = {}
File.new(pca, 'r').each do |line|
  cols = line.strip.split(/\s+/)
  eigen[cols[0]] = cols[1..4].join("\t") # only care about first 4 PCs
end

File.new(info, 'r').each do |line|
  cols = line.strip.split(/\s+/)
  fid, sid, cohort = cols[0], cols[1], cols[2]
  if eigen.key?(fid)
    puts line.strip + "\t" + eigen[fid]
  else
    $stderr.puts "Warning: #{fid} is not included in the PCA file"
  end
end


    
