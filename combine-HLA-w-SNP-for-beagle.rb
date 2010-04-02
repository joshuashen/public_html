# input: 1. HLA 2. SNP

hlaf = ARGV[0]
snpf = ARGV[1]

if hlaf == nil
  $stderr.puts "Usage: ruby __.rb HLA_gt.txt SNP_gt.txt > combined.txt"
  exit
end

header = ''
subjects = {}
File.new(hlaf, 'r').each do |line|
  cols = line.strip.split(/\s+/)
  if line=~ /^Id\s+HLA/ # header
    header = line.chomp
  else
    subjects[cols[0]] = line.chomp
  end
end

File.new(snpf, 'r').each do |line|
  cols = line.strip.split(/\s+/)
  if cols[0] == 'ID' # header
    cols[1..-1].each do |snp|  # repeat twice for each SNP  to represent two haplotypes
      header += "\t#{snp}\t#{snp}"

    end
    puts header
  else  # non-header
    s = cols[0]
    if subjects.key?(s) #
      cols[1..-1].each do |gt|
        if gt == '2'  # homo minor
          subjects[s] += "\t1\t1"
        elsif gt == '1' # het
          subjects[s] += "\t1\t0"
        elsif gt == '0' # homo major
          subjects[s] += "\t0\t0"
        else
          subjects[s] += "\t?\t?"
        end
        
      end
      puts subjects[s]
    end
  end
end

