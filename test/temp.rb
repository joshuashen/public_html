
gender = {}
while line=ARGF.gets do 
  cols= line.chomp.split(',')
  h = {}
  h[:id] = cols[1]
  h[:gender] = cols[2]
  puts "#{cols[2]} x"
  gender[cols[0]] = h
end
