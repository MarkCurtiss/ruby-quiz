require 'person'
require 'net/smtp'

class SecretSanta
  def initialize(people)
    @people = people.sort
    @recipient_by_santa = {}
    num_people = @people.size

    raise(ArgumentError, 'You need at least two people to have a secret santa') if num_people < 2

    people_by_last_name = {}
    @people.each do |p|
      last_name = p.last_name
      if people_by_last_name.has_key?(last_name)
        people_by_last_name[last_name] = people_by_last_name[p.last_name] + 1
      else
        people_by_last_name[last_name] = 1
      end
    end

    people_by_last_name.each do |last_name, num_members|
      if num_members > (num_people / 2)
        raise(ArgumentError, "The #{last_name} family has too many members - over 50% of the group (#{num_members}/#{num_people})")
      end
    end
  end

  def assign_santas
    num_people = @people.size

    @people.each_index do |i|
      person = @people[i]
      until @recipient_by_santa.has_key?(person)
        i = (i + 1) % num_people
        recipient = @people[i]

        next if person.is_related_to?(recipient)
        next if @recipient_by_santa.has_value?(recipient)

        @recipient_by_santa[person] = recipient
      end
    end

    @recipient_by_santa
  end

  def notify_santas
    username, password = File.open(File.expand_path('~/.santarc')).readlines.map { |l| l.chomp }
    smtp = Net::SMTP.new('smtp.gmail.com', 587)
    smtp.enable_starttls
    smtp.start('secret@santa.com', username, password, :login) do
      @people.each do |p|
        smtp.open_message_stream(username, p.eMail_address) do |f|
          f.puts "From: #{username}"
          f.puts "To: #{p.eMail_address}"
          f.puts "Subject: Your Secret Santa Assignment"
          f.puts 
          f.puts "Hi #{p.to_s},"
          f.puts
          f.puts "You've been assigned #{@recipient_by_santa[p]} as your lucky recipient."
          f.puts
          f.puts "Happy Holidays!"
        end
      end
    end
  end
end
