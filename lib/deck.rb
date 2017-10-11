class Deck
  attr_accessor :cards

  def initialize
    @cards = []
  end

  def add_to_deck(card)
    @cards.unshift!(card)
  end

  def draw_from_deck
    @cards.shift!
  end

  def shuffle
    @cards.shuffle!
  end
end