# input: 1. cases FID. 2. strata

casesf = ARGV[0]
strataf = ARGV[1]
num = ARGV[2]

fid = {}
strata = {}

if casesf == nil
  $stderr.puts "Usage: ruby __.rb cases_FID strata_file [control/case_ratio]"
  exit
end

if num ==nil
  num = 2 # default 1:2 
else
  num = num.to_i
end

File.new(casesf, 'r').each do |line|
  if line=~ /^(\S+)/
    fid[$1] = []
  end
end

File.new(strataf, 'r').each do |line|
  cols = line.chomp.split(/\s+/)
  subj, index = cols[0], cols[2]
  if fid.key?(subj) # a case of interest
    strata[index] = subj
  else
    if strata.key?(index)
      caseID = strata[index]
      fid[caseID] << subj
    end
  end
end


fid.keys.sort.each do |caseID|
  arr = fid[caseID].shuffle
  if arr.size >=2
    puts "#{arr[0]}\t#{caseID}"
    puts "#{arr[1]}\t#{caseID}"
  elsif arr.size > 0
    puts "#{arr[0]}\t#{caseID}"
    $stderr.puts "Warning: #{caseID} does not have two matching controls"
  end
end



