class Deck
  attr_accessor :cards 

  def initialize
    @cards = []
  end

  def add_to_deck(card)
    @cards.unshift(card)
  end

  def draw_card
    @cards.shift
  end

  def shuffle
    @cards.shuffle!
  end

  def print_cards
    printable_cards = @cards.map(&:number)
    print printable_cards
  end
end