
$subjects = []
$numCases = 0

def main
  prefix = ARGV[0]  # prefix of the genotype file (PLINK)
  
  num = ARGV[1]  # number of permutations
  
  if num == nil
    num = 1000
  else
    num = num.to_i
  end
  
  readFam(prefix+".fam")
  permute(prefix, num)

end

def permute(prefix, n)
  a = (0..$subjects.size-1).to_a
  1.upto(n) do |i|
    b = a.sort_by {rand}  # shuffle the array
    cases = b[0..($numCases - 1)]  # take the first $numCases elements as the cases 
    status = Array.new($subjects.size)
    status.fill(1)   # default be controls
    cases.each do |j| 
      status[j] += 1  # set to be cases
    end

    system("ln -s #{prefix}.bed permu_#{i}_GT.bed")
    system("ln -s #{prefix}.bim permu_#{i}_GT.bim")
    output = File.new("permu_#{i}_GT.fam", 'w')
    0.upto($subjects.size-1) do |j|
      output.puts "#{$subjects[j]} #{status[j]}"
    end
    output.close
  end
end

def readFam(fam)
  
  File.new(fam, 'r').each do |line|
    line.chomp!
    cols = line.split(/\s+/)
    $subjects << cols[0..4].join(" ")  # ignore case/control status
    if cols[5] == '2'  # case
      $numCases += 1
    end
  end
end

main()
