f = ARGV[0]

cut = ARGV[1]

if cut == nil
  cut = 0.02
else
  cut = cut.to_f
end

File.new(f,'r').each do |line|
  s = line.strip
  if s =~ /^CHR/  # first line
    puts line
  else
    cols = s.split(/\s+/)
    if cols[4] == "TREND" 
      controlGT = cols[6].split('/')
      maf = controlGT[0].to_f / (controlGT[1].to_f + 0.0001)
      if maf < cut  # this SNP has a MAF smaller than cutoff value in controls
        1
      else
        puts line
      end
    end
  end
end
        
