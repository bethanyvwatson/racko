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
    deck = (1..60).to_a.shuffle
    rack1 = deck.sample(10)
    deck = deck - rack1
    rack2 = deck.sample(10)
    deck = deck - rack2
    rack1_orig = rack1.to_s
    rack2_orig = rack2.to_s
    deck_orig = deck.to_s
    discard = []

    while rack1.sort != rack1 && rack2.sort != rack2 && @reshuffle_counts[game_num] <= RESHUFFLE_COUNT
      @turn_counts[game_num] += 1

      if deck.length < 1
        deck = discard.shuffle
        discard = []
        @reshuffle_counts[game_num] += 1
      end

      newest_card = deck.shift

      #rack 1
      i = @brain.index_to_replace(newest_card, rack1)

      if i == -1
        discard << newest_card
      else
        discard << rack1[i]
        rack1[i] = newest_card
      end

      if deck.length < 1
        deck = discard.shuffle
        discard = []
        @reshuffle_counts[game_num] += 1
      end

      #rack 2
      newest_card = deck.shift
      i2 = @brain.index_to_replace(newest_card, rack2)

      if i2 == -1
        discard << newest_card
      else
        discard << rack2[i]
        rack2[i] = newest_card
      end
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