## make ped and map file 

def main
  report = ARGV[0]
#   fam = ARGV[1]
  map = ARGV[1]
  if map == nil
   map = "/ifs/home/c2b2/af_lab/saec/data/GenotypingPlatforms/Illumina1M/illumina1M.sorted.map"
#    map = "/ifs/home/c2b2/af_lab/saec/data/GenotypingPlatforms/Illumina1M/illumina1M-Duov3.sorted.map"
  end

  snps = readSNPMap(map)
  $stderr.puts "# of SNPs: #{snps.size}"
  
#  samples = readFam(fam)
  readReport(report,snps)
end

def readSNPMap(map)
  snps = [] 
  File.new(map, 'r').each do |line|
    snps << line.split(/\s+/)[1]
  end
  return snps
end

def readReport(report,snps)
  lastName = ''
  gtype = {}
  File.new(report,'r').each do |line|
    cols =line.split(',')
    next unless cols.size > 8
    if cols[1] =~ /\S+/
      name = cols[1].tr(' ', '')
#       next unless samples.key?(name) 
      if name != lastName  ## a new sample
        printOne(gtype, lastName, snps)
        lastName = name
        gtype = {}
      end
      gt = "#{cols[4]} #{cols[5]}".tr('_', '0').tr('-', '0')  # replace no-calls with 0
      gtype[cols[0]] = gt
    end
  end
  printOne(gtype, lastName,  snps)  # the last samples
end

def printOne(gtype, id, snps)

  return if gtype.size < 10
#  return unless samples.key?(id)
  $stderr.puts "Sample: #{id}"
#  print samples[id], "\s"
  print "#{id} 1 0 0 1 1 "
  snps.each do |rs|
    if gtype.key?(rs)
      print gtype[rs], "\s"
    else
      print "0 0 "
    end
  end
  print "\n"
end

main()
