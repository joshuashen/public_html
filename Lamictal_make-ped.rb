## input: genotypes, id mapping, and gender
require 'getoptlong'

$illumina1M = "/ifs/home/c2b2/af_lab/saec/DILI/data/all_DILI.map"

def main
  	optHash = getArguments()
  	if optHash.key?("--help") 
    	help()
    	exit
  	end
  
	if optHash.key?("--map")
		$illumina1M = optHash["--map"]
	end

	snps = getAllSNPs($illumina1M)
	
	cases = getCases(optHash["--cases"])
	gender = getGender(optHash["--sex"])
	
	File.new(optHash["--genotypes"], 'r').each do |line|
		if line=~ /^(\S+)/
			gt = $1
			readOneGT(gt, cases, gender,snps)
		end
	end
end

def getAllSNPs(m)
	snps = []
	File.new(m,'r').each do |line|
		cols=line.split(/\s+/)
		snps << cols[1]  # this is not very good in terms of computing performance.  A better way is to declare snps = Array.new(NUMBER_of_elements), so that adding new elements would not require allocating extra memory
	end
	return snps
end

def getArguments() 
  opts = GetoptLong.new(
                        ["--cases", "-c", GetoptLong::REQUIRED_ARGUMENT],
                        ["--sex", "-s", GetoptLong::REQUIRED_ARGUMENT],
                        ["--genotypes", "-g", GetoptLong::REQUIRED_ARGUMENT],
                        ["--map", "-m", GetoptLong::OPTIONAL_ARGUMENT],
                        ["--help", "-h", GetoptLong::NO_ARGUMENT]
                        )
  
  optHash = {}
  opts.each do |opt, arg|
    optHash[opt] = arg
  end
  return optHash
end

def help()
  $stderr.puts "Usage: ruby __.rb -c cases_ID -s gender_file -g list_of_genotype_file [-m 1M.map ]" 
end


def getCases(pheno)
	cases = {}
	File.new(pheno,'r').each do |line|
  		if line=~ /^(\S+)/
    		cases[$1] = 1
		end
	end
	return cases
end

def getGender(gfile)
	gender = {}
	File.new(gfile,'r').each do |line|
  		cols= line.chomp.split(',')
  		h = {}
  		h[:id] = cols[1]
  		h[:gender] = cols[2]
  		gender[cols[0]] = h
	end

	return gender
end


def readOneGT(gt, cases, gender,snps)
	name = ''
	sampleID = ''
	gg = 0
	genotype = {}
	
	if gt=~ /^(\S+)\.csv/
    	name = $1
	else
		return 
	end

	if gender.key?(name)
		sampleID = gender[name][:id]
		if gender[name][:gender] == "Male"
                  gg = 1
		else
                  gg = 2
		end

		if cases.key?(sampleID)
			pp = 2  # phenotype
		else
			pp = 1
		end
		print "#{sampleID}\t1\t0\t0\t#{gg}\t#{pp}\t"
	else
		$stderr.puts "no such subject #{name}"
		return
	end


	File.new(gt, 'r').each do |line|
		cols = line.split(',')
#	rs, a,b = cols[0], cols[2], cols[3]
		genotype[cols[0]] = "#{cols[2]} #{cols[3]}"
	end
	snps.each do |rs|
		if genotype.key?(rs)
			print genotype[rs].tr('-', '0'), "\t"
		else	
			print "0 0\t"
		end
	end
	print "\n"
	return
end

main()
