class PlayRacko
  STOP_STRING = 'donesies'

  def initialize
    @still_playing = true
  end

  def play
    while @still_playing == true
      puts "Still Playing"
      @still_playing = gets.chomp.to_s != STOP_STRING
    end
  end

  PlayRacko.new.play
end 