##
def getPrefix(ff)
  if ff=~/^(\S+)\.bed/
    return $1
  end
end

beds = ARGV[0]
outp = ARGV[1]
arr = []
File.new(beds, 'r').each do |bb|
  arr << getPrefix(bb)
end
# beds = `ls *.bed`.to_a

first = arr.shift

mf = outp + '_mergelist'
mergelist = File.new(mf, 'w')

arr.each do |pp|
  mergelist.puts "#{pp}.bed #{pp}.bim #{pp}.fam"
end
mergelist.close
cmd = "plink --bfile #{first} --merge-list #{mf} --make-bed --out #{outp} --geno 0.8 --mind 0.8 --hwe 0.0 --maf 0.0001" 
puts cmd
system(cmd)
