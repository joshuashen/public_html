## make ped and map file 


idmap = "/nfs/apollo/2/c2b2/users/saec/DILI/diliID_illuminaID.map"

# "/nfs/apollo/2/c2b2/users/saec/SJS/usr/ys/data/mapping_info.txt"

included = "/nfs/apollo/2/c2b2/users/saec/DILI/data/all_DILI_white_pruned.fam"

# "/nfs/apollo/2/c2b2/users/saec/SJS/usr/ys/data/R1/whitesR1.fam"

map = "/nfs/apollo/2/c2b2/users/saec/SJS/usr/ys/data/illumina1M.sorted.map"

$sample = {}
$diliid = {}

$snps = []


File.new(included, 'r').each do |line|
  if line=~ /^(\S+)\s+/
    $sample[$1] = line.chomp
  end
end

File.new(idmap, 'r').each do |line|
  if line=~ /^(\S+)\s+(\S+)/
    if $sample.key?($1)
      $diliid[$2] = $1
    end
  end
end

$stderr.puts "# of samples: #{$diliid.keys.size}"

File.new(map, 'r').each do |line|
  $snps << line.split(/\s+/)[1]
end

$stderr.puts "# of SNPs: #{$snps.size}"

def printOne(gtype, id)
  $stderr.puts "ID on the chip: #{id}"
  return if gtype.size < 1
  return unless $diliid.key?(id)
  print $sample[$diliid[id]], "\s"
  $stderr.puts $diliid[id]
  $snps.each do |rs|
    if gtype.key?(rs)
      print gtype[rs].tr('_', '0'), "\s"
    else
      print "0 0 "
    end
  end
  print "\n"
  return
end


id = ''
gtype = {}
while line=ARGF.gets do
  cols =line.split(',')
  if cols[1] =~ /^\S+\_A/ 
    if cols[1] != id ## a new sample
      printOne(gtype, id)

      id = cols[1]
      gtype = {}
    end
    
    gtype[cols[0]] = "#{cols[2]} #{cols[3]}"
  end
end

printOne(gtype, id)

    
   
