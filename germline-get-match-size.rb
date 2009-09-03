## take the match file from germline, count the size of longest matches

matchf = ARGV[0]

gtf = ARGV[1]

subjects  = {}
homo = {}

hap = Hash.new {|h,k| h[k]=Hash.new }
ss = {}

File.new(gtf, 'r').each do |line|
  if cols=line.chomp.split(/\s+/)
    fid, status, gt = cols[0], cols[1].to_i, cols[2].to_i
    next unless gt > 0

    if gt > 1 # homozygous
      homo[fid] = status
    end
    subjects[fid] = status
    
  end
end

# first find all matches that are relevant to the haplotype
File.new(matchf, 'r').each do |line|
  cols=line.chomp.split(/\s+/)
  f1, h1, f2, h2, s,e = cols[0], cols[1], cols[2], cols[3], cols[5].to_i, cols[6].to_i
  next unless homo.key?(f1) or homo.key?(f2)
  next unless subjects.key?(f1) and subjects.key?(f2)

  hap[f1][h1] = 1
  hap[f2][h2] = 1
  ss[f1] = {}
  ss[f2] = {}
end

# 
File.new(matchf, 'r').each do |line|
  cols=line.chomp.split(/\s+/)
  f1, h1, f2, h2, s,e = cols[0], cols[1], cols[2], cols[3], cols[5].to_i, cols[6].to_i
  if hap.key?(f1) and hap.key?(f2) and hap[f1].key?(h1) and hap[f2].key?(h2)
#    status = subjects[f1] + subjects[f2]
    
    l = e - s + 1
    if ss[f1].key?(f2) 
      if l > ss[f1][f2]
        ss[f1][f2] = l
      end
    else
      ss[f1][f2] = l
    end
  end
end

puts "Status\tSize\tSubject1\tSubject2"
ss.keys.sort.each do |f1|
  ss[f1].keys.each do |f2|
    l = ss[f1][f2]
    status = subjects[f1] + subjects[f2]  
    puts "#{status}\t#{l}\t#{f1}\t#{f2}"
  end
end
