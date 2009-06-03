# input file: 1. .ped  2. enzyme file

# enzyme file: ...../meta-data/DILI_covariants_enzymes.csv 

## format of enzyme file: DU0001,DUNDEE,COAMOXICLAV,CHOLESTATIC,20,445,642

## the last three columns are peak bilirubin, peak alt values, and peak ALP values

# genotype: homo_minor/het/homo_major ==> 2/1/0


def main()
  ped = ARGV[0]
  enz = ARGV[1]
  subjects = readPed(ped)
  enzLevel= readEnzyme(enz)
  encode(subjects)
  output(subjects, enzLevel)
end

def readEnzyme(enz)
  enzLevel = {}
  File.new(enz, 'r').each do |line|
    cols = line.chomp.split(',')
    next if cols.size < 7
    fid,alt,alp=cols[0],cols[5],cols[6]
    
    next if cols[-2] == '' or cols[-1] == ''
    enzLevel[fid] = [alt, alp]
  end
  return enzLevel
end

def output(s, e)
  puts '#' + "FID\tpheno\tgenotypes...\talt\talp" 
  s.each do |subject|
#    $stderr.puts subject
    if e.key?(subject[:fid])
      puts "#{subject[:fid]}\t#{subject[:pheno]}\t#{subject[:encoded].join('  ')}\t#{e[subject[:fid]].join('  ')}"
    end
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
  fid = ''
  File.new(ped,'r').each do |line|
    cols = line.strip.split(/\s+/)
    #    $stderr.puts cols[6..-1].join("\t")
##    next if cols[5] == '1'  ## ignore controls
    name, pheno, gtArray = cols[0],cols[5], cols[6..-1]
    if name =~ /^(\S+)\_(\S+)$/
      fid = $2
    end
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

