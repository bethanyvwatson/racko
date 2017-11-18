require_relative "../lib/computer_player_brain.rb"

# This is a utility simulator, made to help evaluate different player brains.
# The code is gross. It is utilitarian. You have been warned.

class BrainGamesSimulator
  # the goal is to count how many turns it takes a brain
  # to win a game of racko
  RESHUFFLE_COUNT = 100

  def initialize(num_games = 5)
    @brain = ComputerPlayerBrain.new

    @num_games = num_games
    @turn_counts = Array.new(num_games, 0)
    @reshuffle_counts = Array.new(num_games, 0)
    @file_name = "BrainGame-#{Time.now.to_i}.sim"
  end

  def run_game(game_num, debug = false)
    pm = PlayerManager.new
    player1 = pm.new_computer_player
    player2 = pm.new_computer_player

    pm.init_current_player
    dm = DecksManager.new
    
    while winning_player.nil?
      pm.switch_players

      if @decks_manager.draw_pile.is_empty?
        @decks_manager.reshuffle_discard_into_draw 
        @decks_manager.let_players_shuffle_draw_pile
        @decks_manager.discard_top_card
      end

      ComputerPlayerTurn.new(pm.current_player).take_turn
      nums = pm.current_player.rack.ordered_cards.map(&:number)

      winning_player = pm.current_player if nums == nums.sort
    end

    if debug
      results =  <<-GAME
      ---------GAME #{game_num}---------
      Original Rack1: #{rack1_orig}
      Original Rack2: #{rack2_orig}
      Original Deck: #{deck_orig}
      Reshuffle Count: #{reshuffle_count}
      Final Rack1: #{rack1.to_s}
      Final Rack2: #{rack2.to_s}
      GAME

      return results
    end
  end

  def simulate(msg, debug = false)
    @num_games.times do |n|
      if debug
        results = run_game(n, debug)
        open(@file_name, 'a') { |f| f.puts results }
      else
        run_game(n)
      end
    end
    open(@file_name, 'a') { |f| f.puts msg }
    open(@file_name, 'a') { |f| f.puts 'Turn Counts: ' + @turn_counts.to_s }
    open(@file_name, 'a') { |f| f.puts 'Avg Turns: ' + (@turn_counts.sum/@turn_counts.length).to_s }
    open(@file_name, 'a') { |f| f.puts 'Min Turns: ' + @turn_counts.min.to_s }
    open(@file_name, 'a') { |f| f.puts 'Max Turns: ' + @turn_counts.max.to_s }
    open(@file_name, 'a') { |f| f.puts 'Avg Shuffles: ' + (@reshuffle_counts.sum/@reshuffle_counts.length).to_s }
    open(@file_name, 'a') { |f| f.puts 'Max Shuffles: ' + (@reshuffle_counts.max).to_s }

  end

  BrainGamesSimulator.new(1500).simulate('Run 2 Player Test 1500 Times.', false)
end