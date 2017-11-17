require '../lib/player.rb'
require '../lib/computer_player_brain.rb'

class ComputerPlayer < Player
  attr_accessor :brain

  def initialize(rack)
    super(generated_name, rack)
    @brain = ComputerPlayerBrain.new
  end

  

  private

  def generated_name
    suffix = %w(Mr. Ms. Young Old Dr.)
    first = %w(Chris Pat Sasha Taylor Max)
    last = %w(Merchant Barber Green Brown)

    suffix.sample + first.sample + last.sample
  end
end