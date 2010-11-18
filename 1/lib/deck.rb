class Deck < Array
  attr_reader :joker_a, :joker_b
  def initialize
    Card::SUITS.each do |s|
      Card::FACES.each do |f|
        self.push(Card.new(s, f))
      end
    end

    @joker_a = Card.new(nil, Card::JOKER_A)
    @joker_b = Card.new(nil, Card::JOKER_B)
    self.push(@joker_a)
    self.push(@joker_b)
  end

  def bubble_card_at_position(position)
    next_position = (position + 1) % self.length
    next_position = 1 if next_position == 0

    card = self.delete_at(position)
    self.insert(next_position, card)
  end

  def move_joker_a_one_card_down
    bubble_card_at_position(self.index(@joker_a))
  end

  def move_joker_b_two_cards_down
    bubble_card_at_position(self.index(@joker_b))
    bubble_card_at_position(self.index(@joker_b))
  end

  def triple_cut_around_jokers
    top_joker_position, bottom_joker_position = [ self.index(@joker_a), self.index(@joker_b) ].sort
    #puts("top joker position #{top_joker_position}, bottom joker position #{bottom_joker_position}")

    cards_above_top_joker = self[0..(top_joker_position-1)]
    cards_below_bottom_joker = self[(bottom_joker_position+1)..self.length]

    self.replace(self - cards_above_top_joker - cards_below_bottom_joker)
    self.push(cards_above_top_joker)
    self.unshift(cards_below_bottom_joker)
    #we just pushed arrays onto the start and end of our array, so....
    self.flatten!
  end

  def count_cut_using_bottom_card
    bottom_card_value = self[-1].to_i
    top_n_cards = self[0..(bottom_card_value-1)]
    self.replace(self - top_n_cards)
    self.insert(-2, top_n_cards)
    self.flatten!
  end

  def find_output_letter
    cards_to_count_down = self[0].to_i
    self[cards_to_count_down].to_char
  end

  def generate_keystream(length)
    keystream = ''
    until keystream.length == length
      self.move_joker_a_one_card_down
      self.move_joker_b_two_cards_down
      self.triple_cut_around_jokers
      self.count_cut_using_bottom_card
      next unless self.find_output_letter

      keystream << self.find_output_letter
    end

    keystream.scan(/\w{1,5}/).join(' ')
  end
end
