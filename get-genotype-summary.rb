
bfile = ARGV[0]
snp = ARGV[1]
fidList = ARGV[2]



plink = `which plink`
ped = "#{snp}-GT.ped"
if !File.exist?(ped)
  system("plink --bfile #{bfile} --snp #{snp}  --recode --out #{snp}-GT")
end


if fidList != nil
  cmd = "fgrep -f #{fidList} -w #{snp}-GT.ped | awk \'{print $7,$8}\' | sort | uniq -c | sort -k1n "
  puts cmd
  system(cmd)
else
  cmd = "awk \'{print $7,$8}\' < #{snp}-GT.ped  | sort | uniq -c | sort -k1n "
  puts cmd
  system(cmd)
end

