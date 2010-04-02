## transpose HLA genotype from subject per row to allele per row. For Beagle


input = ARGV[0]

gt = {}

rnum = 0
cnum = 0

header = []
genes = {}

File.new(input, 'r').each do |line|
  cols = line.strip.split(/\s+/)
  
  if cols[0] == 'Id' # header
    header = cols[1..-1]
  else
    fid = cols.shift

    gt[fid] = {}
    
    num = 0
    cols.each do |c|
      gene = header[num]
      if !gt[fid].key?(gene)
        gt[fid][gene] = []
      end
      gt[fid][gene] << c
      num += 1
    end
  end

end

print "I\tid\t"

gt.keys.sort.each do |fid|
  print "#{fid}\t#{fid}\t"
end
print "\n"

header.each do |gene|
  genes[gene] = 1
end

genes.keys.sort.each do |gene|
  print "M\t#{gene}\t"
  gt.keys.sort.each do |fid|
    print gt[fid][gene].join("\t") + "\t"
  end
  print "\n"
end

