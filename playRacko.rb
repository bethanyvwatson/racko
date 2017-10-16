class PlayRacko
  require 'yaml'

  require_relative 'lib/deck.rb'
  require_relative 'lib/racko_deck.rb'
  require_relative 'lib/player.rb'
  require_relative 'lib/rack.rb'
  require_relative 'lib/card.rb'
  require_relative 'lib/game_turn.rb'
  require_relative 'lib/racko_turn.rb'

  TEXT = YAML.load_file('text.yml')
  MAX_CARDS = 9

  def play    
    greeting
    go_over_the_rules
    setup_game
    run_game
    end_game
  end

  private

  def check_for_winner
    @winning_player = @current_player if @current_player.rack.is_ordered?
  end
  # each player gets 9 cards. 
  # They are ordered in a rack. Cards are taken FROM the draw pile.
  def deal_cards
    MAX_CARDS.times do |d|
      @player1.rack.add_card(@draw_pile.draw_card)
      @player2.rack.add_card(@draw_pile.draw_card)
    end

    @discard_pile.add_to_deck(@draw_pile.draw_card)
  end

  def end_game
    puts "#{@current_player.name} wins!!!"
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

  # get the names of each player
  # initialize player objects
  def init_players
    system('clear')
    player1_name = ''
    player2_name = ''

    print TEXT['intro']['get_player_info']
    
    while player1_name.empty?
      print TEXT['intro']['player1']
      player1_name = gets.chomp
    end

    system('clear')

    print "Nice to meet you, #{player1_name}.\n"

    while player2_name.empty?
      print TEXT['intro']['player2']
      player2_name = gets.chomp
    end

    system('clear')

    print "Ok, #{player2_name}! Got it.\n"

    @player1 = Player.new(player1_name, Rack.new)
    @player2 = Player.new(player2_name, Rack.new)

    @current_player = @player1
    @winning_player = nil
  end

  def run_game
    while @winning_player.nil?
      switch_players

      validate_draw_pile

      RackoTurn.new(@current_player, @draw_pile, @discard_pile).take_turn

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
    print @current_player.printable_player

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

  def switch_players
    @current_player = @current_player == @player1 ? @player2 : @player1
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
