

f = {}
c = {}
p = {}

File.new("illuminaID.Flucloxacillin-all", 'r').each do |line|
  if line=~ /\S+\s+(\S+)\_A/
    f[$1] = 1
  end
end

File.new("illuminaID.Coamoxiclav-only", 'r').each do |line|
  if line=~ /\S+\s+(\S+)\_A/
    c[$1] = 1
  end
end

File.new("illuminaID.nEU_POPRES", 'r').each do |line|
  if line=~ /\S+\s+(\S+)\_A/
    p[$1] = 1
  end
end

File.new("temp", 'r').each do |line|
  line.chomp!
  cols=line.split(/\s+/)
  if f.key?(cols[2]) 
    puts "#{line}\tFlucloxicillin"
  elsif c.key?(cols[2])
    puts "#{line}\tCo-amoxiclav"
  elsif p.key?(cols[2])
    puts "#{line}\tnEU_POPRES"
  else
    puts line
  end
end
