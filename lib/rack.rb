class Rack
  attr_reader :ordered_cards

  RACK_MARKERS = %w(a b c d e f g h i)

  def initialize
    @ordered_cards = []
  end

  def add_card(card)
    @ordered_cards.unshift(card)
  end

  def formatted_markers
    RACK_MARKERS.join('    ')
  end

  def get_card(place_indicator)
    @ordered_cards[location(place_indicator)]
  end

  def is_ordered?
    nums = @ordered_cards.map(&:number)
    nums == nums.sort
  end

  def replace_card(place_indicator, new_card)
    replaced_card = get_card(place_indicator)
    set_card(place_indicator, new_card)
    replaced_card
  end

  def set_card(place_indicator, new_card)
    @ordered_cards[location(place_indicator)] = new_card
  end

  def location(place_indicator)
    RACK_MARKERS.index(place_indicator)
  end

  def to_placeholder
    to_s.gsub(/\d/, '?')
  end

  def to_s
    @ordered_cards.map(&:to_s).join(' / ')
  end
end