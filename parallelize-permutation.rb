prefix = ARGV[0] # the prefix of .bed etc files

times = ARGV[1]

if times == nil
  times = 500
else
  times = times.to_i
end

targetDir = "Permutations"

system("mkdir #{targetDir}") unless File.exist?(targetDir)

plink = "/ifs/home/c2b2/af_lab/saec/Software/plink-1.04-x86_64/plink"

targetPath = File.expand_path(targetDir)
absPath = File.expand_path(prefix)

$stderr.puts targetPath

1.upto(times) do |i| 
  qsubfile = targetPath + "/" + "qsub_#{i}.sh"
  fh = File.new(qsubfile, 'w')
  fh.puts '#!/bin/sh' + "\n" + '#$ -cwd' + "\n"

  cmd = "#{plink} --bfile #{absPath} --assoc --mperm 2000 --mperm-save --out #{targetPath}/permute_#{i}"
#  $stderr.puts cmd
  fh.puts cmd
  fh.close
  
end

