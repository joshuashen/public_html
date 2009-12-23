absFile = ARGV[0]
absFileNew = absFile + ".fastq"
out = File.new(absFileNew, 'w')
File.new(absFile, 'r').each do |line|
  cols = line.split(/\s+/)
  readname = '@' + cols[0..4].join("_") +"/" + cols[5]
  seq = cols[6]
  qual = ''
  cols[7..41].each do |q|
#    $stderr.puts q
    ## ref: http://maq.sourceforge.net/qual.shtml                                                                                   
    # $Q = 10 * log(1 + 10 ** ($sQ / 10.0)) / log(10);                                                                              
    # ruby convert ascii and char: http://www.zenspider.com/Languages/Ruby/Cookbook/Strings/ConvertingBetweenASCIICharactersandValues.html
    qual += ((10*Math.log10(1+10**(q.to_i / 10.0))).round + 33).chr
    
  end
  out.puts "#{readname}\n#{seq}\n+\n#{qual}"
end

