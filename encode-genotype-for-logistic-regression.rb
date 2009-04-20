# input file: .ped

# genotype: homo_minor/het/homo_major ==> 2/1/0


def main()
  ped = ARGV[0]
  
  subjects = readPed(ped)
  encode(subjects)
  output(subjects)
end

def output(s)
  s.each do |subject|
    puts "#{subject[:fid]}\t#{subject[:pheno]}\t#{subject[:encoded].join('  ')}"
  end

end

def encode(s)
  dim = s[0][:genotype].size
  
  convert = {}
  
  controls = s.select {|i| i[:pheno] == "1"} 
   
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
    s.each do |subject|
      gstr = subject[:genotype][i]
      if convert.key?(gstr)
        subject[:encoded][i] = convert[gstr]
      else
        subject[:encoded][i] = "NA"
      end
    end
  end
end
  
def readPed(ped)
  subjects = []
  File.new(ped,'r').each do |line|
    cols = line.strip.split(/\s+/)
#    $stderr.puts cols[6..-1].join("\t")
    fid, pheno, gtArray = cols[0],cols[5], cols[6..-1]
    gt = []

    0.upto(gtArray.size/2-1) do |i|
      gt << gtArray[i*2..(i*2+1)].join("")
    end
    if gt.size > 0
      s = {:fid => fid, :pheno => pheno, :genotype => gt, :encoded => []}
      subjects << s
    end
  end
  return subjects
end

main()

