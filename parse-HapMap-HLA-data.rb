## input data is from GSK typed HapMap CEU subjects: ~/HapMap/uploads/HapMap_HLA_from_GSK/HapMapHLA.txt 

# output format: 
# Pedigree    Individual    NCI_HLAA   NCI_HLAC  NCI_HLAB  NCI_HLADRB  NCI_HLADQB  NCI_HLADQA
# 884 884M02 0201 0201  0602 0602  5701 3701  0401 1101   0302 0301  0301 0501

input = ARGV[0]

genotypes = {}

if input== nil
  input = "/ifs/home/c2b2/af_lab/saec/HapMap/uploads/HapMap_HLA_from_GSK/HapMapHLA.txt"
end

File.new(input, 'r').each do |line|
  cols = line.chomp.split(/\s+/)
  next if cols[0] =~ /^Subject/  # header line

  fid, gene, allele1, allele2, flag = cols[0], cols[1], cols[4][0..3], cols[5][0..3], cols[-1]
  next unless flag == 'N'
  if !genotypes.key?(fid)
    genotypes[fid] = {"HLA-A" => '- -', "HLA-B" => '- -', "HLA-C" =>'- -', "HLA-DRB1" => '- -', "HLA-DQB1" => '- -', "HLA-DQA1" => '- -'}
  end
  
#  allele1.tr!('A-Z', 'x')
#  allele2.tr!('A-Z', 'x')
  if allele1 =~ /^\d\d\d\d/
    1
  else
    allele1 = '-'
  end

  if allele2 =~ /^\d\d\d\d/
    1
  else
    allele2 = '-'
  end

  
  genotypes[fid][gene] = allele1 + " " + allele2
end

## order: A, C, B, DRB, DQB, DQA
genotypes.keys.sort.each do |fid|
  puts "#{fid}\t#{fid}\t#{genotypes[fid]["HLA-A"]}\t#{genotypes[fid]["HLA-C"]}\t#{genotypes[fid]["HLA-B"]}\t#{genotypes[fid]["HLA-DRB1"]}\t#{genotypes[fid]["HLA-DQB1"]}\t#{genotypes[fid]["HLA-DQA1"]}"
end

  
  
  

