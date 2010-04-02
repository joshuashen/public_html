# encode DASH (http://www.cs.columbia.edu/~gusev/dash/) output for association test

# input: 
# (1) .fam , indicating case/control status

# (2) DASH output, format is tab-delimited:
# c2      23381312        24431837        0661-11A_13454 1        0464005D_20460003_D05 1 0463008A_20460002_A08 1 0464003B_20460003_B03 1

fam = ARGV[0]
dash = ARGV[1]

status = {}  # case/control status
File.new(fam, 'r').each do |line|
  cols = line.split(/\s+/)
  status[cols[0]] = cols[5]
end

File.new(dash, 'r').each do |line|
  cols = line.strip.split(/\t/)  # 
  ca, co = 0,0
  cols[3..-1].each do |sub| 
    fid = sub.split(/\s+/)[0]
    if status.key?(fid) 
      if status[fid] == '2'  # case
        ca += 1
      else
        co += 1
      end
    end
  end

  puts cols[0..2].join("\t") + "\t#{ca}\t#{co}"
end

