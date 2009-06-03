##
# item: fever-> F, rash -> R, Eosinophilia in peripheral blood -> E

# order: R, F, A, E, C
input = ARGV[0]

File.new(input, 'r').each do |line|
  cols = line.split(',')
  fid, fever, rash, e = cols[0],cols[1].upcase, cols[2].upcase, cols[3].upcase

  extra = []
  if rash == "YES"
    extra << "R"
  end

  if fever == "YES"
    extra << "F"
  end
  
  if e == "YES"
    extra << "E"
  end
  puts "#{fid}\t#{extra.join(', ')}"
end
