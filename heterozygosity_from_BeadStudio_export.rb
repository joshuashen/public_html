## format:
# Name    0630-08C_DU0009.Log R Ratio     0630-08C_DU0009.B Allele Freq
# 200003  -0.0632 0.0000
# 200006  -0.0985 0.4919
# ...

indi = ARGV[0]
col = 2  # which column is B Allele Freq? 

class Numeric
  def square ; self * self ; end
end

class Array
  def sum ; self.inject(0){|a,x|x+a} ; end
  def mean ; self.sum.to_f/self.size ; end
  def median
    case self.size % 2
    when 0 then self.sort[self.size/2-1,2].mean
    when 1 then self.sort[self.size/2].to_f
    end if self.size > 0
  end
  def histogram ; self.sort.inject({}){|a,x|a[x]=a[x].to_i+1;a} ; end
  def mode
    map = self.histogram
    max = map.values.max
    map.keys.select{|x|map[x]==max}
  end
  def squares ; self.inject(0){|a,x|x.square+a} ; end
  def variance ; self.squares.to_f/self.size - self.mean.square; end
  def deviation ; Math::sqrt( self.variance ) ; end
end


a = Array.new

File.new(indi, 'r').each do |line|
  next if line=~ /^\#/
  cols = line.strip.split(/\t/)
  baf = cols[col].to_f
  a << (baf - 0.5).abs
end

puts "#{indi}\t#{a.mean}\t#{a.median}\t#{a.deviation}"

