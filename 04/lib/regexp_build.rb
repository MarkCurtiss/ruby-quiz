class Regexp
  def self.build(*int)
    integers = []
    int.each { |i| 
      if i.is_a? Integer
        integers.push(i)
      elsif i.is_a? Range
        integers.push(i.to_a)
      else
        raise ArgumentError.new('Arguments must all be of type Integer or Range')
      end
    }

    Regexp.new(/^(0*#{integers.join('|0*')})$/)
  end
end
