## test epistasis of HLA allelels (Coamoxiclav GWAS)

# this script is used to generate the controls in terms of  DQB1*0602 and DR2 genotypes
# data is 177 UK subjects: 

# DQB1*0602:  2/47/128
# DR2:        2/46/129


1.upto(177) do |i|
  if i <= 2  # homozygous
    puts "English-#{i} 0 2 2 1"
  elsif i <= 46  # het in both 
    puts "English-#{i} 0 1 1 0"
  elsif i == 47  # het in DQB, other in DR2
    puts "English-#{i} 0 1 0 0"
  else
    puts "English-#{i} 0 0 0 0"
  end
end
