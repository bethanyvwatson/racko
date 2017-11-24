class DecksManager
  require_relative '../decks/racko_deck'
  require_relative '../cards/card'

  attr_reader :discard_pile, :draw_pile

  def initialize
    @draw_pile = RackoDeck.new
    @discard_pile = Deck.new

    @draw_pile.shuffle
  end

  def discard_top_card
    @discard_pile.add_to_deck(@draw_pile.draw_card)
  end

  # allow the players to shuffle the deck as many times as they want
  def let_players_shuffle_draw_pile
    keep_shuffling = true
    invalid_shuffle = nil
    animate_shuffle

    while keep_shuffling
      DisplayManager.prepare_pregame_display
      puts "The cards have been shuffled! #{ask_to_shuffle_string}"
      puts InputManager.input_options({ affirmative: 'Shuffle Again', negative: 'Start Playing' }, invalid_shuffle)
      invalid_shuffle = nil

      response = InputManager.get

      if InputManager.affirmative?(response)
        @draw_pile.shuffle
        animate_shuffle
      elsif InputManager.negative?(response)
        keep_shuffling = false
      else 
        invalid_shuffle = response
      end 
    end
  end

  # reshuffle the discard pile and make that the new draw pile
  def reshuffle_discard_into_draw
    DisplayManager.prepare_pregame_display
    puts "The draw pile is empty! Let's shuffle the discard pile and make that the new draw pile."
    sleep(3)
    @draw_pile = @discard_pile
    @discard_pile = Deck.new 
  end

  def animate_shuffle
    DisplayManager.prepare_pregame_display
    puts 'Shuffling...'
    sleep(0.3)
    3.times { puts %w(S h u f f l i n g ...).shuffle.join; sleep(0.6) }
  end

  private

  def ask_to_shuffle_string
    ['Do you want to', 'Should we', 'Shall we'].sample + 
      [' keep shuffling', ' shuffle'].sample + 
      [' the cards',''].sample +
      [' again?', ' some more?', '?'].sample
  end
end