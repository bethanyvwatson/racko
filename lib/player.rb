class Player
  attr_accessor :name, :rack

  def initialize(name, rack)
    @name = name
    @rack = rack
  end 

  def printable_player
    <<-PLAYER
    ====================
    #{@name}
    ====================
    #{@rack.printable_rack}
    PLAYER
  end
end