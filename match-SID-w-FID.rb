# match sid with fid

sidf = ARGV[0]
fidf = ARGV[1]

# example: sidf: /ifs/home/c2b2/af_lab/saec/DILI/meta-data/SID_to_Cohort.txt.non-malaga.mod

# fidf: /ifs/home/c2b2/af_lab/saec/DILI/data/Genotypes/all_DILI-phase1.fam.cases-FID.mod


subs = {}

File.new(sidf, 'r').each do |line|
  if line=~ /^(\S+)/
    sid = $1
    subs[sid] = ""
  end
end

File.new(fidf, 'r').each do |line|
  line.strip!
  cols = line.split('_')
  name = cols[1]
#  $stderr.puts name
  if name =~ /LI(\d+)/  # eudrage
    if subs.key?($1)
      subs[$1] = line
    end
  elsif subs.key?(name)
    subs[name] = line
  end
end

subs.keys.sort.each do |sid|
  if subs[sid] != ""
    puts "#{sid}\t#{subs[sid]}"
  end

end

    
