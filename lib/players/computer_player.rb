class ComputerPlayer < Player
  attr_accessor :brain

  def initialize(rack)
    super(generated_name, rack)
    @brain = ComputerPlayerBrain.new
  end

  def find_useful_rack_placement(number)
    @brain.index_to_replace(number, @rack.ordered_cards.map(&:number))
  end

  private

  def generated_name
    suffix = %w(Mr. Ms. Young Old Dr.)
    first = %w(Chris Pat Sasha Taylor Max)
    last = %w(Merchant Barber Green Brown)

    [suffix.sample, first.sample, last.sample].join(' ')
  end
end