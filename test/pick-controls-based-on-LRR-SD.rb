## the problem:
# cases have larger LRR SD by average. In order to avoid "stratification" in the CNV analysis, 
# we should pick the controls that match the cases in terms of LRR SD. 


caseLRR = ARGV[0]
controlLRR = ARGV[1]

$cutoff = 0.205

cases = {}
controls = {}

caarr = []
coarr = []

File.new(caseLRR,'r').each do |line|
  if line=~ /^(\S+)\s+(\S+)/
    l = $2.to_f
    if l <= $cutoff
      cases[$1] = l
    end
  end
end

File.new(controlLRR, 'r').each do |line|
  if line=~ /^(\S+)\s+(\S+)/
    l = $2.to_f
    if l <= $cutoff
      controls[$1] = l
    end
  end
end

# sort cases, decreasing by LRR SD
caarr = cases.keys.sort {|a,b| cases[b] <=> cases[a]}

# increasing
coarr = controls.keys.sort {|a,b| controls[a] <=> controls[b]}


caarr.each do |c|
  last = 1
  lastcn = ''
  while coarr.size > 0
    cn = coarr.pop  # get the last element
    var = (cases[c] - controls[cn]).abs
    if var >= last
      puts "#{lastcn}\t#{c}\t#{controls[lastcn]}\t#{cases[c]}"
      coarr.push(cn) 
      break
    else
      last = var
      lastcn = cn
    end
  end

end

      
      
