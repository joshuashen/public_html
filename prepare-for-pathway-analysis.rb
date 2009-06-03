## input: 1. trend result  2. SNP to gene mapping  3. gene name to entrez mapping

class Snp
  attr_accessor :rs, :ca, :co, :p, :geneName, :distance, :entrez, :refseq
  
  def initialize()
    @rs = ''
    @ca, @co, @p, @geneName, @distance, @entrez, @refseq = '','',1,'N/A',-1,'N/A','N/A'
  end
  
  def printInfo
    puts "#{@rs}\t#{@geneName}\t#{@entrez}\t#{@refseq}\t#{p}\t#{distance}\t#{ca}\t#{co}"
  end
  
end

def main()
  trend = ARGV[0]
  snp2genef = ARGV[1]  # such as ~/Software/Gengen/hhall.hg18.snpgenemap
  gene2entrezf = ARGV[2]  # such as ~/data/Refseq/hgnc_geneNames.txt.Column2-32-34.clean
  
  pcut = ARGV[3]

  if pcut == nil
    pcut = 0.05
  else
    pcut = pcut.to_f
  end
  
  snps = readTrend(trend, pcut)
  annotate(snps, snp2genef, gene2entrezf)
  
  # header line
  puts "#SNP-Name\tgeneName\tentrez\trefseq\tp-value\tdistance(bp)\tcase_GT\tcontrol_GT"
  snps.keys.sort.each do |rs|
    snps[rs].printInfo
  end
end

def annotate(snps, snp2genef, gene2entrezf)
  genes = {}
  File.new(snp2genef, 'r').each do |line|
    cols=line.strip.split(/\s+/)
    rs,gene,dist = cols[0], cols[1], cols[2].to_i
    if snps.key?(rs)
      snp = snps[rs]
      snp.geneName = gene
      snp.distance = dist
      
      gene.split(',').each do |g|
        if !genes.key?(g)
          genes[g] = []
        end
        genes[g]  << snp
      end
    end
  end

  File.new(gene2entrezf, 'r').each do |line|
    cols=line.strip.split(/\t/)
    name, entrez, refseq = cols[0], cols[1], cols[2]
    if genes.key?(name)
      genes[name].each do |snp|
        snp.entrez = entrez
        snp.refseq = refseq
      end
    end
  end
end

def readTrend(f, cut)
  snps = {}
  File.new(f, 'r').each do |line|
    # column 10th is the p-value
    cols = line.strip.split(/\s+/)
    snp = Snp.new
    snp.rs, snp.ca, snp.co, snp.p = cols[1], cols[5], cols[6], cols[9].to_f
    if snp.p <= cut && snp.rs != "SNP"
      snps[snp.rs] = snp
    end
  end
  return snps 
end

main()
