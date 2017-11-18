class SimulateRacko

  require 'yaml'

  require_relative 'lib/display_manager.rb'
  require_relative 'lib/input_manager.rb'
  require_relative 'lib/player.rb'
  require_relative 'lib/computer_player.rb'
  require_relative 'lib/computer_player_racko_turn.rb'
  require_relative 'lib/player_racko_turn.rb'
  require_relative 'lib/computer_player_brain.rb'
  require_relative 'lib/racko_turn.rb'
  require_relative 'lib/player_manager.rb'
  require_relative 'lib/decks_manager.rb'
  require_relative 'lib/rules_manager.rb'

  TEXT = YAML.load_file('text.yml')
  MAX_CARDS = 10

  MAX_SHUFFLES = 3

  def initialize
    @player_manager = PlayerManager.new
    @decks_manager = DecksManager.new
    @rules_manager = RulesManager.new

    @file_name = 'SimRacko-' + Time.now.to_i.to_s
    @turn_count = 0
    @reshuffle_count = 0
  end

  def play    
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
    open(@file_name, 'a') { |f| f.puts 'Turn Count: ' + @turn_count.to_s }
    open(@file_name, 'a') { |f| f.puts 'Shuffles: ' + @reshuffle_count.to_s }
  end

  def init_players
    @player_manager.send(:test_init_players)
    @winning_player = nil
  end

  def run_game
    @current_turn = nil
    while @winning_player.nil? && @reshuffle_count < MAX_SHUFFLES
      @player_manager.switch_players

      if @decks_manager.draw_pile.is_empty?
        @reshuffle_count += 1
        @decks_manager.reshuffle_discard_into_draw 
        @decks_manager.discard_top_card
      end

      @current_turn = new_turn
      @current_turn.send(:test_take_turn)
      open(@file_name, 'a') { |f| f.puts "#{@player_manager.current_player.name}: #{@player_manager.current_player.rack.to_s}" }

      check_for_winner
    end
  end 

  def new_turn
    @turn_count += 1
    player = @player_manager.current_player
    ComputerPlayerRackoTurn.new(player, @decks_manager)
  end

  def setup_game
    init_players
    deal_cards
  end

  SimulateRacko.new.play
end
