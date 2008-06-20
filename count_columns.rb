while line=ARGF.gets do 
	cols = line.chomp.split(/\s+/)
	puts cols.size
end
