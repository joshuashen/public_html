### input types:
# 1. HLA typing: comma delimited
# 2. HLA freq in HapMap

# !! todo: 
## 1. use de Bakker MHC data ! 
## 2. do fisher's exact test on fly

# convert to format required at http://www.hiv.lanl.gov/content/immunology/hla/hla_compare.html
# example:
# 13W038510 A1101 A3401 B1521 B1801 C0403 C0704
# 13W038511 A0201 A1101 -  -  C0403 C0801
# 13W038507 A0101 A1101 B3502 B5106 - -

#  genes = ["A", "B", "C", "DPB1","DQA1", "DQB1", "DRB1", "DRB3", "DRB4", "DRB5"]

class Hla
  def initialize()
    @hlaGenes = {"A" => "A" , "B" => "B", "C" => "C","DQA1" => "DQA", "DQB1" => "DQB", "DRB1" => "DRB"}    
    @twoDigit = {}
    @fourDigit = {}
    
  end
  
  def readComma(file)
    fh = File.new(file,'r')
    header = fh.readline.chomp.split(',')
    i = 0
    genes = {}
    0.upto(header.size - 1) do |i|
      col = header[i]
      if col =='SampleID'
        1
        # ignore
      else # a gene
        genes[i] = col[0..-2]
      end
    end

    while line = fh.gets do
      cols = line.chomp.split(',')
      sample = cols[0]
      @twoDigit[sample] = {}
      @fourDigit[sample] = {}
      genes.values.each do |gene|
        @twoDigit[sample][gene] = ''
        @fourDigit[sample][gene] = ''
      end
      1.upto(cols.size - 1 ) do |i|
        col = cols[i]
        next unless genes.key?(i)
        gene = genes[i]
        next unless @hlaGenes.key?(gene)  # only consider the genes listed
        geneString = @hlaGenes[gene]
        if col == '' or col == "0000"
          @twoDigit[sample][gene] += "- "
          @fourDigit[sample][gene] += "- "
        else
          @twoDigit[sample][gene] += "#{geneString}#{col[0..1]} "
          @fourDigit[sample][gene] += "#{geneString}#{col[0..3]} "
        end
      end
    end
    fh.close
  end

  def readDbdump(file)
    File.new(file,'r').each do |line|
      cols = line.chomp.split(/\s+/)
      if cols[-1] == "N"  # not excluded
        sample , gene, a1, a2 = cols[0],cols[1],cols[4], cols[5]
        @twoDigit[sample] = {} unless @twoDigit.key?(sample)
        @fourDigit[sample] = {} unless @fourDigit.key?(sample)
        if gene=~ /HLA\-(\S+)/
          g = $1
          next unless @hlaGenes.key?(g)
          geneString = @hlaGenes[g]
          if a1 != '-'
            @twoDigit[sample][g] = "#{geneString}#{a1[0..1]} "
            @fourDigit[sample][g] = "#{geneString}#{a1[0..3]} "
          else  
            @twoDigit[sample][g] = "- "
            @fourDigit[sample][g] = "- "
          end
          if a2 !=  '-'
            @twoDigit[sample][g] += "#{geneString}#{a2[0..1]}"
            @fourDigit[sample][g] += "#{geneString}#{a2[0..3]}"
          else
            @twoDigit[sample][g] += "- "
            @fourDigit[sample][g] += "- "
          end
        end
      end
    end
    
  end
  
  def output(prefix)
    outfile2 = prefix + "_2-digit.txt"
    outfile4 = prefix + "_4-digit.txt"
    out2 = File.new(outfile2, 'w')
    out4 = File.new(outfile4, 'w')
    @twoDigit.keys.sort.each do |sample|
      out2.print "#{sample} "
      out4.print "#{sample} "

      @hlaGenes.keys.sort.each do |gene|
        if @twoDigit[sample].key?(gene)
          out2.print "#{@twoDigit[sample][gene]} "
        else
          out2.print "- - "
        end
        
        if @fourDigit[sample].key?(gene)
          out4.print "#{@fourDigit[sample][gene]} "
        else
          out4.print "- - "
        end
      end
      out2.print "\n"
      out4.print "\n"
    end
    out2.close
    out4.close
  end
  
end

def help
  $stderr.puts "Usage: ruby #{File.basename($0)} -g HLA-genotypes [-t fileType] [-s suffix_of_Output]"
end

if __FILE__ == $0 
  require 'getoptlong'
  opts = GetoptLong.new(
         ["--hla", "-g",GetoptLong::REQUIRED_ARGUMENT],
         ["--filetype", "-t", GetoptLong::OPTIONAL_ARGUMENT],
         ["--suffix", "-s", GetoptLong::OPTIONAL_ARGUMENT],
         ["--help", "-h", GetoptLong::NO_ARGUMENT]
   )
   optHash = {}
   opts.each do |opt, arg|
     optHash[opt] = arg
   end
   
   if optHash.key?("--help")
     help()
     exit
   end

   suffix = "reformated.txt"
   if optHash.key?("--suffix")
     suffix = optHash["--suffix"]
   end

   hla = Hla.new()
   if optHash.key?("--filetype") and optHash["--filetype"] == "dump"
      # such as ~/HapMap/uploads/HapMap_HLA_from_GSK/HapMapHLA.txt
     hla.readDbdump(optHash["--hla"])
   else
     hla.readComma(optHash["--hla"])
  end
    prefix = optHash["--hla"] + "_" + suffix 
    hla.output(prefix)
end
