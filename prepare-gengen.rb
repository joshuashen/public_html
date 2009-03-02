## prepare input files for gengen (path-way based GWAS analysis)

# an association results file, an association permutation results file

def main
  original = ARGV[0]
  batchSize = ARGV[1].to_i
  permutationList = ARGV[2..-1]
  
  if original == nil
    help()
    exit
  end

  system("mkdir Gengen") unless File.exist?("Gengen")
  prefix = "Gengen/batch" 

  snps = readModel(original)
  reformat = File.new("Gengen/case_control.chisq","w")
  reformat.puts "Marker\tCHI2"
  snps.keys.sort.each do |snp|
    reformat.puts "#{snp}\t#{snps[snp]}"
  end
  reformat.close

  i = 0
  newBatch = nil
  chisq = []

  permutationList.each do |pm|
    if i % batchSize == 0  ## first in a new batch
      if i> 0 
        j =  i / batchSize
        newBatch  = File.new("#{prefix}_#{j}_permu.chisq", "w")
        output(chisq, snps, newBatch)
        newBatch.close
        chisq = []
      end
    end
    readPermu(pm, chisq)
    i += 1
  end
  j =  i / batchSize
  newBatch  = File.new("#{prefix}_#{j}_permu.chisq", "w")
  output(chisq, snps, newBatch)
  newBatch.close
end

def output(chisq, snps, fh)
  fh.puts "Marker\tCHI2_PERM"
#   permutations = chisq.keys.sort
  snps.keys.sort.each do |snp|
    fh.print "#{snp}\t"
    chisq.each do |pm|
      if pm.key?(snp)
        fh.print ",#{pm[snp]}"
      else
        fh.print ",0"
      end
    end
    fh.print "\n"
  end
  return 0
end

def readPermu(pm, chisq)
    pmHash = {}
  chisq << pmHash
  File.new(pm, 'r').each do |line|
    next  unless line=~ /TREND/
    line.strip!
    cols=line.split(/\s+/)
    chi2 = cols[9]
    if chi2 != 'NA'
      pmHash[cols[1]]= chi2
    else
      pmHash[cols[1]]= 0
    end
  end
end

def readModel(file)
  chisqCol = 9
  snps = {}
  File.new(file,'r').each do |line|
    line.strip!
    cols = line.split(/\s+/)
    if cols[0] == "CHR"  # the first line
      0.upto(cols.size-1) do |i|
        if cols[i] == "CHISQ"
          chisqCol = i
        end
      end
    elsif line=~ /TREND/
      chi2 = cols[chisqCol]
      if chi2 != "NA" 
        snps[cols[1]] = chi2
      end
    end
  end
  return snps
end

def help
  puts "Usage: ruby #{File.basename($0)} case_control_PLINK_model_out batchSize permutation_model_out"
  
end

main()
