class Person
  attr_reader :first_name, :last_name, :eMail_address

  def initialize(name_string)
    @first_name, @last_name, @eMail_address = name_string.scan(/(\w+) (\w+) <(.*@\w+\.\w+)>/).flatten
  end

  def <=>(other_person)
    last_name_cmp = @last_name <=> other_person.last_name
    return last_name_cmp unless last_name_cmp == 0
    return @first_name <=> other_person.first_name
  end

  def is_related_to?(other_person)
    @last_name.eql?(other_person.last_name)
  end

  def to_s
    "#{@first_name} #{@last_name}"
  end
end
