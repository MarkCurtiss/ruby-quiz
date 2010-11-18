require 'helper'

class DeckTest < Test::Unit::TestCase
  def test_deck_has_all_cards
    assert_equal(54, Deck.new.size)
  end

  def test_move_joker_a_one_card_down
    deck = Deck.new

    joker_a = deck.joker_a
    joker_b = deck.joker_b

    deck.move_joker_a_one_card_down
    assert_equal(53, deck.index(joker_a))
    assert_equal(52, deck.index(joker_b))
 
    deck.move_joker_a_one_card_down
    assert_equal(1, deck.index(joker_a))
    assert_equal(53, deck.index(joker_b))

    deck.move_joker_a_one_card_down
    assert_equal(2, deck.index(joker_a))
    assert_equal(53, deck.index(joker_b))
  end


  def test_move_joker_b_two_cards_down
    deck = Deck.new

    joker_a = deck.joker_a
    joker_b = deck.joker_b

    deck.move_joker_a_one_card_down
    deck.move_joker_b_two_cards_down

    assert_equal(1, deck.index(joker_b))
    assert_equal(53, deck.index(joker_a))
    assert_equal(
      [ 1, 53, 2, 3, 4, ],
      deck[0..4].map { |c| c.to_i }
    )
  end

  def test_triple_cut_around_jokers
    deck = Deck.new

    deck.move_joker_a_one_card_down
    deck.move_joker_b_two_cards_down
    deck.triple_cut_around_jokers

    assert_equal(0, deck.index(deck.joker_b))
    assert_equal(
      [ 53, 2, 3, 4, ],
      deck[0..3].map { |c| c.to_i }
    )
    assert_equal(52, deck.index(deck.joker_a))
    assert_equal(
      [ 52, 53, 1, ],
      deck[-3, 3].map { |c| c.to_i }
    )
  end

  def test_perform_count_cut_using_bottom_card
    deck = Deck.new

    joker_a = deck.joker_a
    joker_b = deck.joker_b

    deck.move_joker_a_one_card_down
    deck.move_joker_b_two_cards_down
    deck.triple_cut_around_jokers
    deck.count_cut_using_bottom_card

    assert_equal(
      [ 2, 3, 4, ],
      deck[0..2].map { |c| c.to_i }
    )
    assert_equal(51, deck.index(deck.joker_a))
    assert_equal(52, deck.index(deck.joker_b))
    assert_equal(
      [ 52, 53, 53, 1, ],
      deck[-4, 4].map { |c| c.to_i }
    )
  end

  def test_find_output_letter
    deck = Deck.new

    deck.move_joker_a_one_card_down
    deck.move_joker_b_two_cards_down
    deck.triple_cut_around_jokers
    deck.count_cut_using_bottom_card

    assert_equal('D', deck.find_output_letter)
  end

  def test_generate_keystream
    assert_equal('DWJXH YRFDG TMSHP UURXJ', Deck.new.generate_keystream(20))
  end
end
