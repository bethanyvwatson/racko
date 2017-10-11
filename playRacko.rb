class PlayRacko
  require 'yaml'

  require_relative 'lib/deck.rb'
  require_relative 'lib/racko_deck.rb'
  require_relative 'lib/player.rb'
  require_relative 'lib/rack.rb'
  require_relative 'lib/card.rb'

  TEXT = YAML.load_file('text.yml')

  def play
    # Greeting
    print TEXT['intro']['greeting']
    
    # Offer Rules
    go_over_the_rules
    
    # Get Player 1
    # Get Player 2
    init_players

    # Shuffle Cards
    init_decks
    # Deal Cards
    # Init Discard Pile

    # Begin Turns
    # Select a Deck to Draw From
    # Regular:
    # Draw Card. Choose discard or exchange. Discard.
    # Get Discarded: Exchange. Discard.
    # Check for win.
    # No Win:
    # End Turn. Next Player.
    # Win: Display winner. Display both hands.
    puts "Bye bye!"
  end

  private

  def init_decks
    @draw_pile = RackoDeck.new
    @discard_pile = Deck.new

    print TEXT['time_to_shuffle']
    @draw_pile.shuffle

    keep_shuffling = true
    while keep_shuffling
      puts ['Do you want to', 'Should we', 'Shall we'].sample + [' keep shuffling', ' shuffle'].sample + [' the cards',''].sample + [' again?', ' some more?', '?'].sample
      response = gets.chomp.downcase
      if ['yes'].include? response.downcase
        @draw_pile.shuffle
      elsif ['no'].include? response
        keep_shuffling = false
      else 
        print TEXT['no_comprende']
      end 
    end
  end

  def init_players
    player1_name = ''
    player2_name = ''

    print TEXT['intro']['get_player_info']
    
    while player1_name.empty?
      print TEXT['intro']['player1']
      player1_name = gets.chomp
    end

    print "Nice to meet you, #{player1_name}.\n"

    while player2_name.empty?
      print TEXT['intro']['player2']
      player2_name = gets.chomp
    end

    print "Ok, #{player2_name}! Got it.\n"

    @player1 = Player.new(player1_name, Rack.new)
    @player2 = Player.new(player2_name, Rack.new)
  end

  def go_over_the_rules
    wants_rules = ''
    while !['yes', 'no'].include? wants_rules.downcase
      print TEXT['intro']['ask_rules']
      wants_rules = gets.chomp.downcase
      if ['yes'].include? wants_rules
        print TEXT['rules']
      elsif wants_rules == 'no'
      else 
        print TEXT['no_comprende']
      end 
    end
  end 

  PlayRacko.new.play
end 
