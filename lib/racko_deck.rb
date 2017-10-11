class RackoDeck < Deck
  def initialize
    super
    (1..60).each do |num|
      @cards << Card.new(num) 
    end
  end
end