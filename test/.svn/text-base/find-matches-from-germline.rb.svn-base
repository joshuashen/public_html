# germline doesn't output all-vs-all matches

# input: germline match file

# for now, assume all segments in the input are the same segment

def trace(s1, h1)
  $share[s1][h1].each_key do |s2|
    $share[s1][h1][s2].each_key do |h2|
      next if $group.key?(s2) and $group[s2].key?(h2) # already visited
      $group[s2][h2] = [s1,h1].join("\t")
      trace(s2,h2)
    end
  end
  return
end

germline = ARGV[0]

hashMaker = proc {|h,k| h[k]=Hash.new(&hashMaker)}

$share = Hash.new(&hashMaker)

# $homotype = ["0347008A_NE0040", "0347008G_NE0053"]
$homotype = "0347008A_NE0040"
$group = Hash.new(&hashMaker)

File.new(germline, 'r').each do |line|
  cols = line.split(/\s+/)
  
  s1, h1, s2, h2, chr, s, e, = cols[0], cols[1], cols[2],cols[3],cols[4],cols[5].to_i,cols[6].to_i
  
  $share[s1][h1][s2][h2] = 1
  $share[s2][h2][s1][h1] = 1
end

$share[$homotype].each_key do |hap|
  $share[$homotype][hap].each_key do |s2|
    $share[$homotype][hap][s2].each_key do |h2|
      $group[s2][h2] = $homotype
      trace(s2,h2)
    end
  end
end

$group.each_key do |s|
  $group[s].each_key do |h|
    puts "#{$homotype}\t#{s}\t#{h}\t#{$group[s][h]}"
  end
end

