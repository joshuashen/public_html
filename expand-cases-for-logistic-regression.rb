# expand the case according the ratio of SNP gentypes

# DR2 carriers

dr2 = ARGV[0]
nonDr2 = ARGV[1]
original = ARGV[2]

carriers = []
nonCar = []

File.new(original, 'r').each do |line|
  cols = line.chomp.split(/\s+/)
  fid, status, dqb1, dr2, inter = cols[0..-1]
  
  if status == "1" 
    if dr2 == "1" # carriers
      carriers << [fid, status, dqb1, dr2, inter]
    else
      nonCar << [fid, status, dqb1, dr2, inter]
    end
  end
  puts line
    
end


newdr2 = dr2.to_i - carriers.size

