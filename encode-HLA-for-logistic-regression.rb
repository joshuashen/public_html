## encode HLA genotypes for logistic regression
# input:
# 1. HLA data: such as
## 24196   0       A0201   A2501   B0702   B1801   DRB1401 DRB0404 DQA0101 DQA0301 ...
#
# 2. PCA scores

# 3. allele(s) of interest


# note: ID mapping: id_map-second-step

alleles = ["A0201", "A2301","A3201", "B1801", "B0702", "B5301", "DRB1501",  "DRB0701", "DQB0202", "DQB0602", "DQB0402", "DQA0102"]

hlaf = ARGV[0]
pcaf = ARGV[1]

gt = {}
status  = {}
score = {}
File.new(hlaf, 'r').each do |line|
  cols = line.chomp.split(/\s+/)
  
  fid = cols.shift
  status[fid] = cols.shift
  gt[fid] = {}
  alleles.each do |a|
    gt[fid][a] = 0
  end

  cols.each do |a|
    if gt[fid].key?(a)
      gt[fid][a] += 1
    end
  end
end

File.new(pcaf, 'r').each do |line|
  cols = line.chomp.split(/\s+/)
  fid = cols[0]
  if gt.key?(fid)
    score[fid] = cols[1..2].join("\t")
  end
end

# header line

print "ID\tstatus"
  
alleles.each do |a|
  print "\t#{a}"
end

print "\tPC1\tPC2\n"


# subjects
gt.keys.each do |fid|
  print "#{fid}\t#{status[fid]}"
  alleles.each do |a|
    print "\t#{gt[fid][a]}"
  end
  print "\t#{score[fid]}\n"
end



