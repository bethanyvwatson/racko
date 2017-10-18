class PlayRacko
  require 'yaml'

  require_relative 'lib/deck.rb'
  require_relative 'lib/racko_deck.rb'
  require_relative 'lib/player.rb'
  require_relative 'lib/rack.rb'
  require_relative 'lib/card.rb'
  require_relative 'lib/game_turn.rb'
  require_relative 'lib/racko_turn.rb'
  require_relative 'lib/player_manager.rb'

  TEXT = YAML.load_file('text.yml')
  MAX_CARDS = 9

  def initialize
    @player_manager = PlayerManager.new
  end

  def play    
    greeting
    go_over_the_rules
    setup_game
    run_game
    end_game
  end

  private

  def check_for_winner
    @winning_player = @player_manager.current_player if @player_manager.current_player.rack.is_ordered?
  end
  
  # each player gets 9 cards. 
  # They are ordered in a rack. Cards are taken FROM the draw pile.
  def deal_cards
    MAX_CARDS.times do |d|
      @player_manager.players.each { |player| player.rack.add_card(@draw_pile.draw_card) }
    end

    @discard_pile.add_to_deck(@draw_pile.draw_card)
  end

  def end_game
    puts "#{@player_manager.current_player.name} wins!!!"
    puts TEXT['game_over']
  end

  # player chooses if they want to see the rules
  def go_over_the_rules
    wants_rules = ''
    while !['yes', 'no'].include? wants_rules.downcase
      print TEXT['intro']['ask_rules']
      wants_rules = gets.chomp.downcase
      system('clear')
      if ['yes'].include? wants_rules
        print TEXT['rules']
        player_still_reading = true
        while player_still_reading
          puts 'Are you ready to play?'
          player_ready = gets.chomp.downcase
          player_still_reading = false if ['yes'].include?(player_ready)
        end
      elsif wants_rules == 'no'
      else 
        print TEXT['no_comprende']
      end 
    end
  end 

  def greeting
    print TEXT['intro']['greeting']
  end

  def init_decks
    @draw_pile = RackoDeck.new
    @discard_pile = Deck.new

    system('clear')
    print TEXT['time_to_shuffle']
    @draw_pile.shuffle

    shuffle_decks
  end

  def init_players
    @player_manager.init_players
    @winning_player = nil
  end

  def run_game
    while @winning_player.nil?
      @player_manager.switch_players

      validate_draw_pile

      RackoTurn.new(@player_manager.current_player, @draw_pile, @discard_pile).take_turn

      check_for_winner
    end
  end 

  def setup_game
    init_players
    init_decks
    deal_cards
  end

  def show_state
    system('clear')

    puts <<-TABLE
    #{@discard_pile.cards.any? ? @discard_pile.cards.first.show : 'N/A'}          |*?*|
    TABLE
    print @player_manager.current_player.printable_player

    puts "Newest Card: #{@selected_card.show} #{'* you cannot discard this card' if @drew_from_discard}" unless @selected_card.nil?
  end

  # allow the players to shuffle the deck as many times as they want
  def shuffle_decks
    keep_shuffling = true
    while keep_shuffling
      system('clear')
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

  # ensure there are cards in the draw pile
  # if not, reshuffle the discard pile and make that the new draw pile
  def validate_draw_pile
    if @draw_pile.is_empty?

      system('clear')
      puts TEXT['game_turn']['reshuffle']
      @draw_pile = @discard_pile
      @discard_pile = Deck.new

      shuffle_decks

      @discard_pile.add_to_deck(@draw_pile.draw_card)
    end
  end

  PlayRacko.new.play
end
