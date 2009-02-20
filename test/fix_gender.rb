## 

$idMap = "/ifs/home/c2b2/af_lab/saec/SJS/R1/Lamictal/Lamictal_GT.map"
$target = "/ifs/home/c2b2/af_lab/saec/SJS/R1/Lamictal/all_lamictal_binary_unique.fam"
$correct = "/ifs/home/c2b2/af_lab/saec/SJS/R1/Lamictal/Lamictal_gender.csv"

$names = {}
$gender = {}

def main
  readMap($idMap)
  readTrue($correct)
  fix($target)
end

def fix(target)
  File.new(target,'r').each do |line|
    cols=line.chomp.split(/\s+/)
    id = $names[cols[0]]

    g = $gender[id]
    sex = 2  # default female
#    print "#{id}\t#{g} ! "
    if g== 'Male'
      sex = 1
    end
    puts "#{cols[0..3].join(" ")} #{sex} #{cols[5]}"
  end
end

def readTrue(correct)
  File.new(correct,'r').each do |line|
    cols = line.chomp.split(',')
    $gender[cols[0]] = cols[-1]
  end
end

def readMap(idMap)
  File.new(idMap, 'r').each do |line|
    if line=~ /^(WG\S+)\s+(\S+)/
      $names[$2] = $1
    end
  end
end

main()

