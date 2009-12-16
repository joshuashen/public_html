## replace ID and take first 4-digit for HLA typing

## gt file: /ifs/home/c2b2/af_lab/saec/DILI/data/HLA/Coamoxiclav/gt.txt.mod

# ID mapping: /ifs/home/c2b2/af_lab/saec/DILI/data/HLA/Coamoxiclav/id_map

gtf = ARGV[0]
mapf = ARGV[1]

replace={}
control= {}
File.new(mapf,'r').each do |line|
  cols = line.chomp.split(/\s+/)
  replace[cols[0]]=cols[1]
  if cols.size > 2 ## control
    control[cols[0]] = cols[2]
  end
end

File.new(gtf, 'r').each do |line|
  cols = line.chomp.split(/\s+/)
  oldi = cols.shift
  newi = oldi
  if replace.key?(oldi)
    newi = replace[oldi]
  end

  status = 1  # case
  if control.key?(oldi)  # control
    status = 0 
  end

  print "#{newi}\t#{status}"
  cols.each do |gt|
    if gt=~ /^([A|B]\S{4})\S*/
      print "\t#{$1}"
    else gt=~ /^(D\S{6})\S*/
      print "\t#{$1}"
    end
  end
  print "\n"
end


      
