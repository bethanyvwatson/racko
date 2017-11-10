class PlayRacko
  require 'yaml'

  require_relative 'lib/display_manager.rb'
  require_relative 'lib/input_manager.rb'
  require_relative 'lib/player.rb'
  require_relative 'lib/game_turn.rb'
  require_relative 'lib/racko_turn.rb'
  require_relative 'lib/player_manager.rb'
  require_relative 'lib/decks_manager.rb'
  require_relative 'lib/rules_manager.rb'

  TEXT = YAML.load_file('text.yml')
  MAX_CARDS = 9

  def initialize
    @player_manager = PlayerManager.new
    @decks_manager = DecksManager.new
    @rules_manager = RulesManager.new
  end

  def play    
    greeting
    setup_game
    run_game
    end_game
  end

  private

  def check_for_winner
    if @player_manager.current_player.rack.is_ordered?
      @winning_player = @player_manager.current_player 
    end
  end
  
  # each player gets 9 cards. 
  # They are ordered in a rack. Cards are taken FROM the draw pile.
  def deal_cards
    MAX_CARDS.times do |d|
      @player_manager.players.each do |player| 
        player.rack.add_card(@decks_manager.draw_pile.draw_card)
       end
    end

    # prep the discard pile with one card from the top of the draw pile
    @decks_manager.discard_top_card
  end

  def end_game
    puts "#{@player_manager.current_player.name} wins!!!"
    abort(TEXT['exit'])
  end

  def greeting
    @rules_manager.go_over_the_rules
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

  PlayRacko.new.play
end
