## via Richard Jackson's email:
# R = Ratio of LFT1 (either ALT in IU/L or AST in IU/L) / LFT2 (either APH in IU/L or Bilirubin in mg/dl)
# If R<2 = cholestatic
# If 2<=R<=5 = mixed
# If R>5 = Hepatocellular

# input: comma-delimited file, with columns:
# ID,peakALT,peakBilirubin



input = ARGV[0]

File.new(input, 'r').each do |line|
  cols = line.strip.split(',')
  if cols[2] =~ /^\d+/ and cols[1] =~ /^\d+/ # no missing value
    r = cols[1].to_f / cols[2].to_f
    puts "#{cols[0]}\t#{r}\t#{cols[1]}\t#{cols[2]}"
  end
end

