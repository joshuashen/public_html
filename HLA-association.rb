### input:
# 1. HLA typing: comma delimited
# 2. HLA freq in HapMap
# 3. Case categories

# convert to format required at http://www.hiv.lanl.gov/content/immunology/hla/hla_compare.html
# example:
# 13W038510 A1101 A3401 B1521 B1801 C0403 C0704
# 13W038511 A0201 A1101 -  -  C0403 C0801
# 13W038507 A0101 A1101 B3502 B5106 - -

def main()
  file = ARGV[0]
  
  format = ARGV[1]
  genotype = nil
  
  if format == '1'  # comma delimited
    genotype = comma(file)
##     $stderr.puts genotype.size
  elsif format == '0'  # each line is one sample with one gene
    genotype = dbdump(file)  # such as ~/HapMap/uploads/HapMap_HLA_from_GSK/HapMapHLA.txt
  end

  output(genotype)
end

def dbdump(file)

  genotype = Hash.new {|h,k| h[k] = {}}
  File.new(file,'r').each do |line|
    cols = line.chomp.split(/\s+/)
    if cols[-1] == "N"  # not excluded
      sample , gene, a1, a2 = cols[0],cols[1],cols[4], cols[5]
      if gene=~ /HLA\-(\S+)/
        g = $1
        if a1 != '-'
          a1 = "#{g}#{a1}"
        end
        if a2 !=  '-'
          a2 = "#{g}#{a2}"
        end
        genotype[sample][g] = "#{a1} #{a2} "
      end
    end
  end
  return genotype
end

def comma(file)
  fh = File.new(file,'r')
  header = fh.readline.chomp.split(',')
  genes = {}
  i = 0
  genotype= {}
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
    genotype[sample] = {}
    genes.values.each do |gene|
      genotype[sample][gene] = ''
    end
    1.upto(cols.size - 1 ) do |i|
      col = cols[i]
      next unless genes.key?(i)
      gene = genes[i]
      if col == ''
        genotype[sample][gene] += "- "
      else
        genotype[sample][gene] += "#{gene}#{col} "
      end
    end
  end
  return genotype
end


def output(genotype)
  genotype.keys.sort.each do |sample|
    print "#{sample} "
    genotype[sample].keys.sort.each do |gene|
      allele = genotype[sample][gene]
      print "#{allele} "
    end
    print "\n"
  end
end

main()



