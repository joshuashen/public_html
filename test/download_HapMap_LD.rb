prefix = "http://ftp.hapmap.org/ld_data/2008-06/ld_chr"
suffix = "_CEU.txt.gz"   

1.upto(22) do |i|
	file = prefix + i.to_s + suffix
	puts file
	system("wget #{file}")
end
	
