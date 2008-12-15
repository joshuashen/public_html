## 

$hashMaker = proc {|h,k| h[k] = Hash.new(&$hashMaker)}


$hash = Hash.new(&$hashMaker)
$probes = {}
$samples = []

def readfile(f)
  if f =~ /\S+\_(\S+)\.PennCNV/
    name = $1
  else
    name = "0"
    $stderr.puts "bad name"
  end
  $samples << name
  
  File.new(f, 'r').each do |line|
    cols=line.split(/\s+/)
    probe,pos,lrr = cols[0],cols[2].to_i, cols[4].to_f
    $hash[pos][name] = lrr
    $probes[pos] = probe
  end
  return
end


files = ARGV[0]

File.new(files, 'r').each do |line|
  if line=~ /^(\S+)/
    f  = $1
    readfile(f)
  end
end

# print header
print "probe\tchr5_position"

$samples.each do |name|
  print "\t#{name}"
end
print "\n"

# print LRR values
$hash.keys.sort.each do |pos|
  print "#{$probes[pos]}\t#{pos}"
  $samples.each do |name|
    print "\t#{$hash[pos][name]}"
  end
  print "\n"
end

    
