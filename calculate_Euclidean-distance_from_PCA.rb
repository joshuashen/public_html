## 

# input: 
# 1. case of interest
# 2. entire fam file -- controls of interest
# 3. PCA evec out

ca = ARGV[0]
all = ARGV[1]
evec = ARGV[2]

$num = 4  ## num of eigen vectors considered important

$cases = {}
$controls = {}

$eigenvals = []
$eigenscore = {}

File.new(ca, 'r').each do |line|
  cols = line.strip.split(/\s+/)
  fid, flag = cols[0], cols[-1]
  if flag == '2'
    $cases[fid] = 1
    $eigenscore[fid] = []
  end
end

File.new(all, 'r').each do |line|
  cols = line.strip.split(/\s+/)
  fid, flag = cols[0], cols[-1]
  if flag == '1'
    $controls[fid] = 1
    $eigenscore[fid] = []
  end
end

File.new(evec, 'r').each do |line|
  cols = line.strip.split(/\s+/)
  if line=~/\#eigvals\:/ ## header line
    $eigenvals = cols[1,$num].map {|i| (i.to_f)**0.5}
  else
    fid= cols[0]
    if $cases.key?(fid) or $controls.key?(fid) 
      $eigenscore[fid] = cols[1,$num].map {|i| i.to_f}
    end
  end
end

def euclidean(a1, a2, ev, num)
  dist = 0
  0.upto(num-1) do |i|
    dist += (a1[i]*ev[i] - a2[i]*ev[i] )**2
  end
  return (dist**0.5*10000).round/10000.0
end

$cases.each_key do |ca|  
  d = {}
  $controls.each_key do |co|
    d[co] = euclidean($eigenscore[ca], $eigenscore[co], $eigenvals, $num)
  end
  array = d.keys.sort {|a,b| d[a] <=> d[b]}[0,10]
  1.upto(10) do |i|
    co = array[i-1]
    puts "#{ca}\tiid\t#{i}\t#{d[co]}\tz\t#{co}\tiid"
  end
end

