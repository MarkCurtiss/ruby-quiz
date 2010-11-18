require 'card'
require 'deck'

class SolitaireCipher
  def initialize
    @deck = Deck.new
  end

  def split_message(message)
    subgroups = message.gsub(/[^a-zA-Z]/, '').upcase.scan(/\w{1,5}/)
    subgroups.map! { |s| padding = 5 - s.length; s + ('X' * padding) }
    subgroups.join(' ')
  end

  def generate_keystream(keystream_length)
    @deck.generate_keystream(keystream_length)
  end

  def convert_message_to_numbers(message)
    message.scan(/[^ ]/).map { |c| (c.ord - '@'.ord) }
  end

  def convert_numbers_to_message(numbers)
    split_message(
      numbers.map { |n| (n + '@'.ord).chr }.join
    )
  end

  def add_keystream_to_message(message, keystream)
    message.fill { |i| (message[i] + keystream[i]) % 26 }
  end

  def encrypt_message(message)
    keystream = generate_keystream(message_length(message))
    numeric_keystream = convert_message_to_numbers(keystream)
    numeric_message = convert_message_to_numbers(split_message(message))

    numeric_result = add_keystream_to_message(numeric_message, numeric_keystream)
    convert_numbers_to_message(numeric_result)
  end
  
  def message_length(message)
    message.scan(/[a-zA-Z]/).length
  end

  def decrypt_message(message)
    keystream = generate_keystream(message_length(message))
    negative_keystream = convert_message_to_numbers(keystream).map { |n| n * -1 }
    numeric_message = convert_message_to_numbers(message)
    
    numeric_result = add_keystream_to_message(numeric_message, negative_keystream)
    convert_numbers_to_message(numeric_result)
  end
end
