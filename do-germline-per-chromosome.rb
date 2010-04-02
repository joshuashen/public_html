## 

prefix=ARGV[0]

chrs= Range.new(1,22).to_a 

## split by chromosome

plink=`which plink`.chomp
gline="sh /ifs/home/c2b2/ip_lab/yshen/usr/Germline/run.sh"
chrs.each do |chr|
  output = "chr_#{chr}"
  bashf = File.new("qsub_" + "#{chr}" + ".sh", 'w')
  bashf.puts '#!/bin/bash'
  bashf.puts '#$ -cwd'
##  bashf.puts '. /ifs/home/c2b2/af_lab/saec/.bashrc'
  cmd = "#{plink} --bfile #{prefix} --chr #{chr} --recode --out #{output}"
  bashf.puts cmd
  germline="#{gline} #{output}.ped #{output}.map germline_#{output}"
  bashf.puts germline
  bashf.close
end

