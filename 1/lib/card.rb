class Card
  CLUBS    = 0
  DIAMONDS = 13
  HEARTS   = 26
  SPADES   = 39

  SUITS = [ CLUBS, DIAMONDS, HEARTS, SPADES, ] 

  ACE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING = (1..13).to_a

  FACES = [ ACE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING, ]

  JOKER_A = 'JOKER_A'
  JOKER_B = 'JOKER_B'

  def initialize(suit, face)
    @suit = suit
    @face = face
  end

  def to_i
    return 53 if is_joker?
    @suit + @face
  end

  def to_char
    return nil if is_joker?
    ((self.to_i % 26) + '@'.ord).chr
  end

  def to_s
    return @face if is_joker?
    face = case @face
        when 1 then 'ace'
        when 2..10 then @face.to_s
        when 11 then 'jack'
        when 12 then 'queen'
        when 13 then 'king'
        end
    
    suit = case @suit
      when CLUBS then 'clubs'
      when DIAMONDS then 'diamonds'
      when HEARTS then 'hearts'
      when SPADES then 'spades'
      end

    "#{face} of #{suit}"
  end

  def is_joker?
    true if @face.eql?(JOKER_A) || @face.eql?(JOKER_B)
  end
end
