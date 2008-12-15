## calling SNPs from Maq pileup format

## 
def strand(h)
  a = h.keys.sort {|a,b| h[b] <=> h[a]}


  s1, s2,s3, s4 = 0,0,0,0
#  $stderr.puts h
  if a.size == 1
    s1 += h[a[0]]
  elsif a.size >= 2
    s1 += h[a[0]]
    (1..(a.size - 1)).each do |i|
#      $stderr.puts a[i]
      if a[i].upcase == a[0].upcase 
        s2 = h[a[i]]
      else
        if h[a[i]] > s3
          s3 = h[a[i]]
        end
      end
    end
  end
# return NumReads on either stand, and other variation, and the top variation  
  return [s1, s2, s3, a[0]]
end

snplist = ARGV[0]
pileup = ARGV[1]
$snps = Hash.new {|h,k| h[k]=Hash.new}
File.new(snplist, "r").each do |line|
  cols=line.split(/\s+/)
  chr,pos,mapQual, avgHits, maxQual, minQual = cols[0],cols[1],cols[4],cols[6],cols[7], cols[8]
  $snps[chr][pos] = "#{mapQual}\t#{avgHits}\t#{maxQual}\t#{minQual}"
end

# header
puts "#chrom\tposition\trefBase\tDepthCov\tSNP\tNumVar+\tNumVar-\tNumVarOther\tNutRefBase\tmapQual\tavgHits\tmaxQual\tminQual"

File.new(pileup,"r").each do |line|
  cols = line.split(/\s+/)
  chr, pos, refBase, cov, seq = cols[0], cols[1], cols[2], cols[3], cols[4]
  next unless $snps.key?(chr) and $snps[chr].key?(pos)
  strings = seq.split("")
  hash = {}
  ref = 0
  strings.shift
  strings.each do |s|
    if s=="," or s == '.' 
      ref += 1
    else
      if !hash.key?(s)
        hash[s] = 1
      else
        hash[s] += 1
      end
    end
  end
  
  sinfo = strand(hash)
  puts "#{chr}\t#{pos}\t#{refBase}\t#{cov}\t#{sinfo[-1]}\t#{sinfo[0]}\t#{sinfo[1]}\t#{sinfo[2]}\t#{ref}\t#{$snps[chr][pos]}"
  
end


  

  
