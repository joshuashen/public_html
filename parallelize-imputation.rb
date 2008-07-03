### make plink to do imputation on each chromosome separately
input = ARGV[0]

plink = "/nfs/apollo/2/c2b2/users/saec/Software/plink-1.03-x86_64/plink"

class Parallelizer
  attr_accessor 
  def initialize(inputPrefix, plinkPath)
    @oldPrefix=inputPrefix
    @divs = []
    @plink = plinkPath
  end

  def do
    splitBim(@oldPrefix + '.bim')
    makeScript()
  end

  def makeScript
    @divs.each do |list|
      outf = File.new(list + '.sh', "w")
      outf.puts '#!/bin/sh' + "\n" + '#$ -cwd' + "\n" + '#$ -j y'
#      outf.puts "PLINK=#{@plink}"
      outf.puts "#{@plink} --bfile #{@oldPrefix} --extract #{list} --make-bed --out #{list}"
      outf.puts "#{@plink} --bfile #{list} --all --proxy-impute all --proxy-replace --make-bed --out #{list}_impute"
      outf.close()
    end
  end

  # in bim, the SNPs are sorted based on chr and positions
  def splitBim(bim) 
    chr = ''
    arr = []
    
    File.new(bim, 'r').each do |line|
      if line=~ /^(\S+)\s+(\S+)/
        snp = $2
        if $1 != chr  # a
          makeChr(arr, chr)
          arr = []
        end
        arr << snp
        chr = $1
      end
    end
    arr = nil
  end
  
  def makeChr(snps, chr)
    return if snps.size < 1
    
    ofile = "Temp_chr" + chr + "_SNPs"
    out = File.new(ofile, 'w')
    out.puts snps.join("\n")
    out.close
    @divs << ofile  ## 
  end
  
end

p = Parallelizer.new(input, plink)
p.do()
