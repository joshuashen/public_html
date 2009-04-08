## input: a ped-like file

file = ARGV[0]
allele1 = ARGV[1]
allele2 = ARGV[2]

matrix = [0,0,0,0]
total = 0
File.new(file, 'r').each do |line|
  total += 2
  if line.match(allele1) 
    if line.match(allele2)
      matrix[0] += 1
    else
      matrix[1] += 1
    end
  else
    if line.match(allele2)
      matrix[3] += 1
    else
      matrix[4] += 1
    end
  end
end

