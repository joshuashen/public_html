## count IBD pairs among case-case, case-control, and control-control


fam = ARGV[0]
matchf = ARGV[1]
minLength = ARGV[2]

if minLength == nil
  minLength = 4.0
else
  minLength = minLength.to_f
end

cases = {}
controls = {}

pairs = [0,0,0]

File.new(fam, 'r').each do |line|
  cols = line.strip.split(/\s+/)
  fid, pheno = cols[0], cols[5]
  if cols[5] == '1' # control
    controls[fid] = 0
  elsif cols[5] == '2'
    cases[fid] = 0
  end
end

File.new(matchf, 'r').each do |line|
  cols = line.strip.split(/\s+/)
  f1, f2, numM, l = cols[0], cols[2], cols[9].to_i, cols[10].to_f
  
  next unless l >= minLength

  n = 0
  if cases.key?(f1) and controls.key?(f2)
    n = 1
    cases[f1] += 1
    controls[f2] += 1
  elsif cases.key?(f1) and cases.key?(f2)
    n =2
    cases[f1] += 1
    cases[f2] += 1
  elsif controls.key?(f1) and cases.key?(f2)
    n =1
    cases[f2] += 1
    controls[f1] += 1
  elsif controls.key?(f1) and controls.key?(f2)
    n = 0
    controls[f1] += 1
    controls[f2] += 1
  else 
    n = -1 
  end
  
  if n >= 0 
    pairs[n] += 1
  end
end

ncase = 0
ncontrol = 0

poscase = 0
poscontrol  = 0 
cases.keys.each do |c|
  ncase += cases[c]
  if cases[c] > 0
    poscase += 1
  end
end

controls.keys.each do |c|
  ncontrol += controls[c]
  if controls[c] > 0
    poscontrol += 1
  end
end

$stderr.puts "case\tctrl\tca-ca\tctrl-ctrl\tca-ctrl\ttotalIBD-case\ttotalIBD-control\tinputFile"
puts "#{cases.keys.size}\t#{controls.keys.size}\t#{pairs[2]}\t#{pairs[0]}\t#{pairs[1]}\t#{ncase}\t#{ncontrol}\t#{matchf}"

# 
# puts "cases:   \t#{cases.keys.size}\tIBD-segments: #{ncase}\tpositive: #{poscase}"
# puts "controls:\t#{controls.keys.size}\tIBD-segments: #{ncontrol}\tpositive: #{poscontrol}"

# puts "\n\n"
# puts "control-control: #{pairs[0]}"
# puts "control-case:    #{pairs[1]}"
# puts "case-case:       #{pairs[2]}"







