require 'helper'

class CardTest < Test::Unit::TestCase
  def test_card_to_i
    assert_equal(13 + 9, Card.new(Card::DIAMONDS, Card::NINE).to_i)
    assert_equal(26 + 11, Card.new(Card::HEARTS, Card::JACK).to_i)
  end

  def test_card_to_char
    assert_equal('V', Card.new(Card::DIAMONDS, Card::NINE).to_char)
    assert_equal('K', Card.new(Card::HEARTS, Card::JACK).to_char)

    assert_nil(Card.new(Card::CLUBS, Card::JOKER_A).to_char)
  end
end
