class Card
  attr_reader :number

  def initialize(num)
    @number = num
  end

  def show
    "|*#{@number.to_s.length < 2 ? '0'+ @number.to_s : @number.to_s}*|"
  end
end