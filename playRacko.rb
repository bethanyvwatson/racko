class PlayRacko
  require 'yaml'

  require_relative 'lib/player.rb'
  require_relative 'lib/game_turn.rb'
  require_relative 'lib/racko_turn.rb'
  require_relative 'lib/player_manager.rb'
  require_relative 'lib/decks_manager.rb'

  TEXT = YAML.load_file('text.yml')
  MAX_CARDS = 9

  def initialize
    @player_manager = PlayerManager.new
    @decks_manager = DecksManager.new
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
      @player_manager.players.each { |player| player.rack.add_card(@decks_manager.draw_pile.draw_card) }
    end

    # initialize the discard pile with one card from the top of the draw pile
    @decks_manager.discard_top_card
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

  def init_players
    @player_manager.init_players
    @winning_player = nil
  end

  def run_game
    while @winning_player.nil?
      @player_manager.switch_players

      if @decks_manager.draw_pile.is_empty?
        @decks_manager.reshuffle_discard_into_draw 
        @decks_manager.let_players_shuffle_draw_pile
        @decks_manager.discard_top_card
      end

      RackoTurn.new(@player_manager.current_player, @decks_manager).take_turn

      check_for_winner
    end
  end 

  def setup_game
    @player_manager.get_player_info
    @decks_manager.let_players_shuffle_draw_pile
    deal_cards
  end

  def show_state
    system('clear')

    puts <<-TABLE
    #{@decks_manager.discard_pile.cards.any? ? @decks_manager.discard_pile.cards.first.show : 'N/A'}          |*?*|
    TABLE
    print @player_manager.current_player.printable_player

    puts "Newest Card: #{@selected_card.show} #{'* you cannot discard this card' if @drew_from_discard}" unless @selected_card.nil?
  end

  PlayRacko.new.play
end
