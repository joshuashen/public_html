## just transpose the matrix

input = ARGV[0]

matrix = []

nrow = 0
ncol = 0

File.new(input, 'r').each do |line|
  cols = line.strip.split(/\s+/)
  
  if matrix.size == 0 # not 
    matrix = Array.new(cols.size) {|i| i = []}
    ncol = cols.size
    $stderr.puts matrix.size
  end
  0.upto(cols.size - 1) do |i|
    matrix[i] << cols[i]
  end
  nrow += 1
end

0.upto(ncol - 1) do |i|

  0.upto(nrow - 1) do |j|
    print "#{matrix[i][j]}\t"
  end
  print "\n"
end
