require 'helper'

class SolitaireCipherTest < Test::Unit::TestCase
  @@test_message = 'Code in Ruby, live longer!'
  
  def test_splitting_message_into_subgroups
    assert_equal(
      'CODEI NRUBY LIVEL ONGER',
      SolitaireCipher.new.split_message(@@test_message),
    )
  end

  def test_splitting_message_into_subgroups__pads_last_group_with_x
    assert_equal(
      'CODEI NRUBY LIVEL ONGXX',
      SolitaireCipher.new.split_message('Code in Ruby, live long!'),
    )
  end

  def test_generate_keystream
    assert_equal(
      'DWJXH YRFDG TMSHP UURXJ',
      SolitaireCipher.new.generate_keystream(20),
    )
  end

  def test_convert_message_to_numbers
    cipher = SolitaireCipher.new
    split_string = cipher.split_message(@@test_message)
    assert_equal(
      [ 3, 15, 4, 5, 9, 14, 18, 21, 2, 25, 12, 9, 22, 5, 12, 15, 14, 7, 5, 18 ],
      cipher.convert_message_to_numbers(split_string),
    )
  end

  def test_add_keystream_to_message
    cipher = SolitaireCipher.new
    message = cipher.convert_message_to_numbers(cipher.split_message(@@test_message))
    keystream = cipher.convert_message_to_numbers(cipher.generate_keystream(20))

    assert_equal(
      [ 7, 12, 14, 3, 17, 13, 10, 1, 6, 6, 6, 22, 15, 13, 2, 10, 9, 25, 3, 2 ],
      cipher.add_keystream_to_message(message, keystream),
    )
  end

  def test_convert_numbers_to_message
    cipher = SolitaireCipher.new
    message = cipher.convert_message_to_numbers(cipher.split_message(@@test_message))
    keystream = cipher.convert_message_to_numbers(cipher.generate_keystream(20))

    message = cipher.add_keystream_to_message(message, keystream)

    assert_equal(
      'GLNCQ MJAFF FVOMB JIYCB', 
      cipher.convert_numbers_to_message(message)
    )
  end

  def test_encrypt_message
    assert_equal(
      'GLNCQ MJAFF FVOMB JIYCB',
      SolitaireCipher.new.encrypt_message(@@test_message),
    )
  end

  def test_decrypt_message
    assert_equal(
      'CODEI NRUBY LIVEL ONGER',
      SolitaireCipher.new.decrypt_message('GLNCQ MJAFF FVOMB JIYCB'),
    )
  end
end
