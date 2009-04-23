## 

# input: 
# 1. case of interest
# 2. entire fam file -- controls of interest
# 3. nearest neighbour file

ca = ARGV[0]
all = ARGV[1]
nearest = ARGV[2]

$genderMatch = 1 # if 0, do not match gender
$cases = {}
$controls = {}
$matched = {}
$priority = []

File.new(ca, 'r').each do |line|
  cols = line.strip.split(/\s+/)
  fid, gender, flag = cols[0], cols[-2], cols[-1]
  if flag == '2'
    $cases[fid] = {:gender => gender, :queue => [], :match => []}
    $priority << fid
  end
end

File.new(all, 'r').each do |line|
  cols = line.strip.split(/\s+/)
  fid, gender, flag = cols[0], cols[-2], cols[-1]
  if flag == '1'
    $controls[fid] = gender
  end
end

File.new(nearest, 'r').each do |line|
  cols = line.strip.split(/\s+/)
  fid1, order, fid2 = cols[0], cols[2].to_i, cols[5]
  flag = 1
  if $cases.key?(fid1) and $controls.key?(fid2)  ## enter the mode
    if $genderMatch == 1  # need to match gender
      if $cases[fid1][:gender] != $controls[fid2] 
        flag = 0
      end
    end
      
    if flag == 1
      $cases[fid1][:queue] << fid2
    end
  end
end

# $cases.each_key do |ca|
$priority.each do |ca|
  $cases[ca][:queue].each do |control|
    if $cases[ca][:match].size < 2 and  !$matched.key?(control)  # not used by other cases
      $cases[ca][:match] << control
      $matched[control] = 1
      puts "#{control}\t#{ca}"
    end
  end
  if $cases[ca][:match].size < 2 
    $stderr.puts "Warning: #{ca} does not have two matching controls"
  end
end


