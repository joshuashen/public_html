## only take trend test result; 

# and filter SNPs based on control MAF

cutoff = ARGV[0]

if cutoff == nil
  cutoff = 0.04   # default
else
  cutoff = cutoff.to_f
end

while line = ARGF.gets do 
  cols = line.strip.split(/\s+/)
  
  if cols[4] == "TREND"
    if cols[6] =~ /(\d+)\/(\d+)/
      maf = $1.to_f / ($2.to_f + $1.to_f )
      
      if maf >= cutoff
        puts line
      end
    end
  elsif cols[4] == "TEST" 
    puts line
  end
end

