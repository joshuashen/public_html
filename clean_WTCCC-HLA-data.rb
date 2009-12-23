## input: tab delimited WTCCC HLA data

# clean steps:
# 1. convert 3/4 digit to 4 digit 
# 2. convert 1/2 digit to 0000


# header line:  #sangerid       hlaa_4digit_1   hlaa_4digit_2   hlac_4digit_1   hlac_4digit_2   hlab_4digit_1   hlab_4digit_2   drb1_4digit_1   drb1_4digit_2   DQA1_4digit_1   DQA1_4digit_2   dqb1_4digit_1   dqb1_4digit_2

genes = ["A", "A", "Cw", "Cw", "B", "B", "DRB", "DRB", "DQA", "DQA", "DQB", "DQB"]

while line=ARGF.gets do 
  if line=~ /^\#/ # header line
    $stderr.puts line
  else
    cols = line.chomp.split(/\s+/)
    id = cols.shift
    print "#{id}\t0"
    
    index = 0
    cols.each do |gt|
      newgt = gt
      if gt.size < 3 
        newgt = "0000"
      elsif gt.size == 3
        newgt = "0#{gt}"
      elsif gt.size > 4
        newgt = gt[0,4]
      end
      print "\t#{genes[index]}#{newgt}"
      index += 1
    end
    print "\n"
  end
end
