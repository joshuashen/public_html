chr = (1..22).to_a.map {|i| i.to_s}
chr.concat(["X", "Y", "M"])

urlBase = "http://ftp.hapmap.org/genotypes/2009-02_phaseII+III/forward/"

chr.each do |c|
  fileName = "genotypes_chr" + c + "_TSI_r27_nr.b36_fwd.txt.gz"
  file = urlBase + fileName
  cmd = "wget #{file}"
  puts cmd
  system("wget #{file}")
end


