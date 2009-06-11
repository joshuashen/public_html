## calculate minimum OR or MAF required to achieve power >= 0.95

# input format: 

# NumCases      NumControls     MAF     OR      power   p-value_CutOff
# 49      4900    0.01    20      0.96    cutoff:5e-8
# 49      4900    0.025   11      0.96    cutoff:5e-8

cutoff = 0.90

minOR = {}
minMAF = {}
while line= ARGF.gets do 
  cols = line.split(/\s+/)
  maf, oddsRatio, power = cols[2].to_f, cols[3].to_f, cols[4].to_f

  if power >= cutoff
    if minOR.key?(maf) 
      if oddsRatio < minOR[maf]
        minOR[maf] = oddsRatio
      end
    else
      minOR[maf] = oddsRatio
    end

    if minMAF.key?(oddsRatio) 
      if maf < minMAF[oddsRatio]
        minMAF[oddsRatio] = maf
      end
    else
      minMAF[oddsRatio] = maf
    end
  end
end

minOR.keys.sort.each do  |maf|
  puts "#{maf}\t#{minOR[maf]}"

end
        
