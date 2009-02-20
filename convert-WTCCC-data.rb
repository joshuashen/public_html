## 
# without supporting file, randomly assign male/female 

require 'zlib'

$hardCodedMap = "/ifs/home/c2b2/af_lab/saec/data/GenotypingPlatforms/Illumina1M/illumina1M.sorted.map"

class Genotype
  attr_accessor :firstGTCol 

  def initialize(gtFile, snpMap, firstGTCol)
    @snps = []
    @map = {}
    @genotype = {}
    @firstGTCol = firstGTCol.to_i
  
    readMap(snpMap)
    $stderr.puts "Number of SNPs in map:  #{@map.size}"
    readGT(gtFile)
    
  end

  def readMap(snpMap)
    
    File.new(snpMap,'r').each do |line|
      line.chomp!
      cols = line.split(/\s+/)
      rs = cols[1].chomp.strip
      @map[rs] = line
    end
  end

  def output(prefix)
    pedOut = File.new(prefix + '.ped', 'w')
    mapOut = File.new(prefix + '.map', 'w')
    nn = 0
    @snps.each do |snp|
      if @map.key?(snp)
        mapOut.puts @map[snp] 
        nn += 1
#      else
#        puts "#{snp}"
      end
    end
    
    $stderr.puts "Number of SNPs in common: #{nn}"

    @genotype.keys.sort.each do |s|
      if rand() >= 0.5
        gender = '2'
      else
        gender = '1'
      end
      pedOut.print "#{s} 1 0 0 #{gender} 1"
      
      @snps.each do |snp|
        next unless @map.key?(snp)
        #    gt[s].keys.sort.each do |snp|
        pedOut.print " #{@genotype[s][snp][0]} #{@genotype[s][snp][1]}"
      end
      pedOut.print "\n"
    end
    pedOut.close
    mapOut.close
  end

  def readGT(cfile)
    fh = nil
    if cfile =~ /.gz$/ 
      fh = Zlib::GzipReader.open(cfile)
    else
      fh = File.new(cfile, 'r')
    end

    nameHash = {}
    fh.each do |line|
      line.chomp!
      cols=line.split(/\s+/)
      if cols[0] == '' # first line
        @firstGTCol.upto(cols.size - 1) do |i|
          nameHash[i] = cols[i]
          @genotype[cols[i]] = {}
        end

      else # GT lines
        rs = cols[0].chomp
        @snps << rs.strip
        @firstGTCol.upto(cols.size - 1) do |i| 
          gtString = cols[i].tr('N', '0').tr('-', '0').tr('_', '0')
        
          @genotype[nameHash[i]][rs] = gtString.split(';')[0]
        end
      end
    end
    fh.close
  end
end


if __FILE__ == $0 
  gtFile = ARGV[0]
  prefix = ARGV[1]
  snpMap = ARGV[2]

  
  if snpMap == nil
    snpMap = $hardCodedMap
  end

  gt = Genotype.new(gtFile, snpMap, 1)
  gt.output(prefix)
end


