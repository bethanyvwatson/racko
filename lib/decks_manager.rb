class DecksManager
  require 'yaml'  

  require_relative '../lib/deck.rb'
  require_relative '../lib/racko_deck.rb'
  require_relative '../lib/card.rb'

  TEXT = YAML.load_file('text.yml')

  AFFIRMATIVE = %w(1 y yes)
  NEGATIVE = %w(0 n no)

  SHUFFLE_INPUTS = <<-SHUFFLE
  Shuffle (#{AFFIRMATIVE.join('/')})
  Start Playing (#{NEGATIVE.join('/')})
  SHUFFLE

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
    while keep_shuffling
      system('clear')
      puts 'The cards have been shuffled!' 
      puts "#{ask_to_shuffle_string}"
      puts SHUFFLE_INPUTS
      response = gets.chomp.to_s.downcase
      if AFFIRMATIVE.include?(response)
        @draw_pile.shuffle
      elsif NEGATIVE.include?(response)
        keep_shuffling = false
      else 
        print TEXT['no_comprende']
      end 
    end
  end

  # reshuffle the discard pile and make that the new draw pile
  def reshuffle_discard_into_draw
    system('clear')
    puts TEXT['game_turn']['reshuffle']
    @draw_pile = @discard_pile
    @discard_pile = Deck.new 
  end

  private

  def ask_to_shuffle_string
    ['Do you want to', 'Should we', 'Shall we'].sample + 
      [' keep shuffling', ' shuffle'].sample + 
      [' the cards',''].sample +
      [' again?', ' some more?', '?'].sample
  end
end