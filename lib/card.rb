class Card
  attr_reader :number

  def initialize(num)
    @number = num
  end

  def show
    print @number
  end
end