
files = []

query = []

# batch 1 of DILI
files << "/ifs/home/c2b2/af_lab/saec/DILI/uploads/June3_2008/Data_from_ExpressionAnalysis.csv"

# batch 2 of DILI, 19 eudragene cases and 4 diligen cases
files << "/ifs/home/c2b2/af_lab/saec/DILI/uploads/Feb-17-2009_Eudragene/DVD1/EA07017 2008-04-23 23 specimens/EA07017 2008-04-23 23 specimens_FinalReport.csv"

# batch 3 of DILI cases
files << "/ifs/home/c2b2/af_lab/saec/DILI/uploads/EA07017_May04-2009/Final Analysis EA07017 March 2009_31MAR09_corrected specimens_FinalReport_1-50.csv"
files << "/ifs/home/c2b2/af_lab/saec/DILI/uploads/EA07017_May04-2009/Final Analysis EA07017 March 2009_31MAR09_corrected specimens_FinalReport_51-100.csv"
files << "/ifs/home/c2b2/af_lab/saec/DILI/uploads/EA07017_May04-2009/Final Analysis EA07017 March 2009_31MAR09_corrected specimens_FinalReport_101-150.csv"
files << "/ifs/home/c2b2/af_lab/saec/DILI/uploads/EA07017_May04-2009/Final Analysis EA07017 March 2009_31MAR09_corrected specimens_FinalReport_151-199.csv"

# batch 4, mostly POPRES controls
files << "/ifs/home/c2b2/af_lab/saec/DILI/uploads/EA07017_June1-2009_POPRES-etc/EA07017 2009-05-15 Final Analysis_FinalReport_1-40.csv"

files << "/ifs/home/c2b2/af_lab/saec/DILI/uploads/EA07017_June1-2009_POPRES-etc/EA07017 2009-05-15 Final Analysis_FinalReport_41-80.csv"
files << "/ifs/home/c2b2/af_lab/saec/DILI/uploads/EA07017_June1-2009_POPRES-etc/EA07017 2009-05-15 Final Analysis_FinalReport_81-120.csv"
files << "/ifs/home/c2b2/af_lab/saec/DILI/uploads/EA07017_June1-2009_POPRES-etc/EA07017 2009-05-15 Final Analysis_FinalReport_121-160.csv"
files << "/ifs/home/c2b2/af_lab/saec/DILI/uploads/EA07017_June1-2009_POPRES-etc/EA07017 2009-05-15 Final Analysis_FinalReport_161-200.csv"
files << "/ifs/home/c2b2/af_lab/saec/DILI/uploads/EA07017_June1-2009_POPRES-etc/EA07017 2009-05-15 Final Analysis_FinalReport_201-218.csv"


query << "/ifs/home/c2b2/af_lab/saec/DILI/uploads/DILIGEN.cases.FID"
query << "/ifs/home/c2b2/af_lab/saec/DILI/uploads/EUDRAGENE.cases.FID"
query << "/ifs/home/c2b2/af_lab/saec/DILI/uploads/MALAGA.cases.FID"

files.each do |f|
  if File.exist?(f)
    puts "Good: #{f}"
  else
    puts "!Bad: #{f}"
  end
  query.each do |q|
    out = q + "_genotype.txt"
    cmd = "fgrep -f \"#{q}\" -w \"#{f}\" >> #{out}"
    puts cmd
#    system(cmd)
  end
  
end
    
