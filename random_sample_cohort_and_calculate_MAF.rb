#  input: a ped file and number of subjects

class Genotype
  attr_accessor :subjects, :minorAllele, :maf

  def initialize(ped)
    @minorAllele = ''
    @maf = 0
    @subjects = []
    loadPed(ped)
  end
  
  def loadPed(ped)
    alleles = {}
    File.new(ped,'r').each do |line|
      cols=  line.chomp.split(/\s+/)
      a1 = cols[-1]
      a2 = cols[-2]
      
      next if a1 == '-' or a1 == '0' or a2 =='-' or a2 == '0'
      
      @subjects << [a1, a2]
      if alleles.key?(a1)
        alleles[a1] += 1
      else
        alleles[a1] = 1
      end

      if alleles.key?(a2)
        alleles[a2] += 1
      else
        alleles[a2] = 1
      end
      
    end
#    $stderr.puts alleles
    x = alleles.keys.sort {|a,b| alleles[b] <=> alleles[a]}
    @minorAllele = x[1]
    @maf = alleles[@minorAllele] / @subjects.size.to_f / 2 
  end

  def randomPick(n)
    return  (@subjects.sort_by {rand})[0,n]
  end
end 

def computeMAF(s, minor)
  total = s.size * 2
  mac = 0
  s.each do |gt|
    gt.each do |g|
      if g == minor
        mac += 1
      end
    end
  end

  maf = mac / total.to_f
end


ped = ARGV[0]
num = ARGV[1]
group = ARGV[2]
if num == nil
  num = 100
else
  num = num.to_i
end

if group == nil
  group = 100
else
  group = group.to_i
end

gt = Genotype.new(ped)

# number of random groups 
# group = 5* gt.subjects.size / num + 1

$stderr.puts "overall MAF: #{gt.maf}"  
1.upto(group) do |i|
  subset = gt.randomPick(num)
  freq = computeMAF(subset, gt.minorAllele)
  puts freq
end




