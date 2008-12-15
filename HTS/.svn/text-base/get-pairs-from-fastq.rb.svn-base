## input: 1. source fastq file prefix;  2. a file containing list of pairs

prefix = ARGV[0]
pairs = ARGV[1]

# 1 reads

source1 = prefix + '.read1.fastq'
list1 = pairs + '.read1'
out1 = list1 + ".fastq"

system("awk '{print \"@\"$1\"/1\"}' #{pairs} > #{list1}")
# fgrep
system("fgrep -f #{list1}  --mmap -A 3 #{source1} | sed  -e '/^\-\- *$/d' > #{out1}")

source2 = prefix + '.read2.fastq'
list2 = pairs + '.read2'
out2 = list2 + ".fastq"

system("awk '{print \"@\"$1\"/2\"}' #{pairs} > #{list2}")
# fgrep
system("fgrep -f #{list2}  --mmap -A 3 #{source2} | sed  -e '/^\-\- *$/d' > #{out2}")

