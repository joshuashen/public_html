# input:
# QU0085  1       A0101   A1101   B0801   B4001   DRB0301 DRB1302 DQA0102 DQA0501 DQB0201 DQB0604

# output:
# Id    HLA-A          HLA-B         HLA-DRB1 ...
# QU0085 0101   1101   0801   4001   0301  1302 ...

input = ARGV[0]

ca = File.new(input + ".cases", "w")
co = File.new(input + ".controls", 'w')

ca.puts "Id\tHLA-A\t\tHLA-B\t\tHLA-DRB1\t\tHLA-DQA1\t\tHLA-DQB1\t\t"
co.puts "Id\tHLA-A\t\tHLA-B\t\tHLA-DRB1\t\tHLA-DQA1\t\tHLA-DQB1\t\t"


File.new(input, "r").each do |line|
  cols = line.split(/\s+/)
  id, pheno  = cols[0], cols[1]
  
    
  string = "#{id}\t"
  
  cols[2..5].each do |c1|
    string += "#{c1[1,4]}\t"
  end
  cols[6..11].each do |c2|
    string += "#{c2[3,4]}\t"
  end
  
  if pheno == "1" # case
    ca.puts string
  else
    co.puts string
  end
end

ca.close
co.close

