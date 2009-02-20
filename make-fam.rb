# input: a sample table

# assume the samples to be all cases or all controls

table = ARGV[0]
status = ARGV[1]  # case/control status for all samples

File.new(table,'r').each do |line|
  cols = line.split(',')
  sampleID, gender = cols[1], cols[2]
  if sampleID=~ /\_(\S+)$/
    if gender == "Male"
      sex = 1
    else
      sex = 2
    end

    name = $1
    puts "#{name}\s1\s0\s0\s#{sex}\s#{status}"
  end
end
