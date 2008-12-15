f = [] 
f << "/nfs/apollo/2/c2b2/users/saec/SJS/usr/ys/data/R1/whitesR1_plink.assoc"
f <<  "/nfs/apollo/2/c2b2/users/saec/SJS/usr/ys/data/R1/AB/SJS_White-R1_AB_DILI-control_prune1_assoc.assoc"
f <<  "/nfs/apollo/2/c2b2/users/saec/SJS/usr/ys/data/R1/PopulationControls/FinalSets/whiteR1_HapMap_III_CEU_final_assoc.assoc"

f << "/nfs/apollo/2/c2b2/users/saec/SJS/usr/ys/data/R1/PopulationControls/iControl/whiteR1_CEU_iControl550V1_pruned_new_assoc.assoc"



input = ARGV[0]

$snps = {}
File.new(input, 'r').each do |line|
  if line=~ /^(\S+)/
    $snps[$1] = {:chr => '', :pos => 0, :odds => 0, :pvalue => [1,1,1,1]}
  end
end



c = 0
f.each do |file|
  File.new(file, "r").each do |line|
    cols = line.lstrip.split(/\s+/)
    rs, chr, pos, pvalue, odds = cols[1], cols[0], cols[2], cols[8].to_f, cols[9].to_f
    
    if $snps.key?(rs)
      $snps[rs][:chr] = chr
      $snps[rs][:pos] = pos
      $snps[rs][:pvalue][c]= pvalue

      if $snps[rs][:odds] < odds
        $snps[rs][:odds] = odds
      end
    end
  end
  c += 1
end

$snps.keys.sort {|a,b| $snps[b][:odds] <=> $snps[a][:odds]}.each do |rs|
  puts "#{rs}\t#{$snps[rs][:chr]}\t#{$snps[rs][:pos]}\t#{$snps[rs][:odds]}\t#{$snps[rs][:pvalue].join("\t")}"
end
