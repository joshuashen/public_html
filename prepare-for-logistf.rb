## prepare for penalized logistic regression association 

# use R package logistf: useful for correcting p-values/OR when 
# sample size is small in association study

# input: plink .ped, .map, .covar

# genotype: homo_minor/het/homo_major ==> 2/1/0


def main()
  ped = ARGV[0]
  map = ARGV[1]
  covar = ARGV[2]

  subjects = {}

  readPed(ped, subjects)
  snps = readMap(map)
  numCovar = readCovar(covar, subjects)
  encode(subjects)
  $stderr.puts "Number of subjects :  #{subjects.size}" 
  output(subjects, snps, numCovar)
end

def output(s, snps, num)
  covars = "covar1"
  2.upto(num) do |i|
    covars += "\tcovar#{i}"
  end
  puts "FID\tstatus\t#{snps.join('    ')}\t#{covars}" # header 
  s.each do |fid, subject|
    puts "#{subject[:fid]}\t#{subject[:pheno]}\t#{subject[:encoded].join('  ')}\t#{subject[:covar].join('    ')}"
  end

end

def encode(s)
  fids = s.keys
  dim = s[fids[0]][:genotype].size
  
  convert = {}
  
  controls = s.values.select {|i| i[:pheno] == 0}  # select controls 
   
  0.upto(dim - 1) do |i|
    
  # define minor allele first  
    gt = {}
    controls.each do |subject|
      next if subject[:genotype][i] == "00"
      if !gt.key?(subject[:genotype][i]) 
        gt[subject[:genotype][i]] = 0
      end
      gt[subject[:genotype][i]] += 1
    end
    
    array = gt.keys.sort {|a,b| gt[b] <=> gt[a]}
    0.upto(2) do |j|
      convert[array[j]] = j
    end
  
    # convert gt to 0/1/2
    s.each do |fid, subject|
      gstr = subject[:genotype][i]
      if convert.key?(gstr)
        subject[:encoded][i] = convert[gstr]
      else
        subject[:encoded][i] = "NA"
      end
    end
  end
end

def readCovar(covar, subjects)
  num = 0
  File.new(covar,'r').each do |line|
    cols=line.strip.split(/\s+/)
    fid, vars = cols[0], cols[2..-1]
    next unless subjects.key?(fid)
    subjects[fid][:covar] = vars
    num = vars.size if num == 0
  end
  return num

end

def readPed(ped, subjects)
  File.new(ped,'r').each do |line|
    cols = line.strip.split(/\s+/)
    #    $stderr.puts cols[6..-1].join("\t")
    
    # pheno: in PLINK format, 2->case, 1-> control;  here we change it to 1 and 0, respectively.
    fid, pheno, gtArray = cols[0],cols[5].to_i - 1, cols[6..-1]
    gt = []
    
    0.upto(gtArray.size/2-1) do |i|
      gt << gtArray[i*2..(i*2+1)].join("")
    end
    if gt.size > 0
      s = {:fid => fid, :pheno => pheno, :genotype => gt, :encoded => [], :covar => []}
      subjects[fid] = s
    end
  end
  return 1
end

def readMap(map)
  snpNames = []
  File.new(map, 'r').each do |line|
    rs=line.strip.split(/\s+/)[1]  # the second column is the rs number of the SNP
    snpNames << rs
  end
  return snpNames
end

main()
