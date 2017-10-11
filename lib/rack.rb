class Rack
  attr_reader :ordered_cards

  def initialize
    @ordered_cards = []
  end

  def add_card(card)
    @ordered_cards.unshift(card)
  end

  def print_cards
    printable_cards = @ordered_cards.map(&:number)
    print printable_cards
  end
end