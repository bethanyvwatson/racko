require_relative "../lib/player.rb"
require_relative "../lib/computer_player.rb"
require_relative "../lib/rack.rb"

class PlayerManager
  attr_reader :current_player, :players

  PLAYER_COUNTS = %w(0 1 2 3 4)

  def initialize(players = [])
    @current_player = nil
    @players = players
  end

  # get the names of each player
  # initialize player objects
  def get_player_info
    waiting_init_players = true
    while waiting_init_players
      @players = []
      
      while @players.length < 1
        init_human_players
        init_computer_player
      end

      # confirm players are correct
      waiting_confirm_players = true
      invalid_confirmation = nil
      while waiting_confirm_players
        DisplayManager.prepare_pregame_display
        print_roster
        puts "Are you ready to play with these players?"
        puts InputManager.input_options({ affirmative: 'Confirm Players', negative: 'Redo Players' }, invalid_confirmation)
        invalid_confirmation = nil
        confirm_response = InputManager.get

        # if yes, ready to play
        if InputManager.affirmative?(confirm_response)
          waiting_confirm_players = false
          waiting_init_players = false 

        # if no, restart player selection
        elsif InputManager.negative?(confirm_response)
          waiting_for_player_num = true 
          waiting_confirm_players = false
        else
          invalid_confirmation = confirm_response
        end
      end
    end
    init_current_player
  end

  def switch_players
    player_index = @players.index(@current_player)
    @current_player = @players[player_index + 1] || @players[0]
  end

  private

  def init_computer_player
    could_want_cpus = true
    while @players.count < max_players && could_want_cpus
      waiting_for_computer = true
      invalid_count = nil

      while waiting_for_computer
        DisplayManager.prepare_pregame_display
        print_roster

        puts 'Would you like to add a computer player?'
        puts InputManager.input_options({ affirmative: "Add Computer Player", negative: "No" }, invalid_count)
        invalid_count = nil

        cpu_player_response = InputManager.get

        if InputManager::INPUTS[:affirmative].include?(cpu_player_response)
          waiting_for_computer = false
          @players << new_computer_player
        elsif InputManager::INPUTS[:negative].include?(cpu_player_response)
          could_want_cpus = false
          waiting_for_computer = false
        else
          invalid_count = cpu_player_response
        end
      end
    end
  end

  def init_current_player
    raise if @players.nil? || @players.empty?
    @current_player = @players.first
  end

  def init_human_players
    waiting_for_player_num = true
    invalid_count = nil

    while waiting_for_player_num
      DisplayManager.prepare_pregame_display

      puts 'We need some players!'
      puts InputManager.input_options({ player_counts: "How many human players?" }, invalid_count)
      invalid_count = nil

      num_players_response = InputManager.get

      if InputManager::INPUTS[:player_counts].include?(num_players_response)
        waiting_for_player_num = false
        num_players = num_players_response.to_i
      else
        invalid_count = num_players_response
      end
    end 

    # init that many players
    num_players.times do |i|
      DisplayManager.prepare_pregame_display

      print_roster
      puts "Enter a name for Player #{i + 1}:"
      name = InputManager.get

      @players << new_player(name)
    end
  end

  def max_players
    @_max_players ||= PLAYER_COUNTS.map(&:to_i).max
  end

  def new_computer_player
    ComputerPlayer.new(Rack.new)
  end

  def new_player(name)
    Player.new(name, Rack.new)
  end

  def print_roster
    @players.each.with_index(1) { |p, i| puts "Player #{i}: #{p.name} #{'(cpu)' if p.is_a?(ComputerPlayer)}" }
  end

  def test_init_players(count = 2)
    count.times { |x| @players << new_computer_player }
    init_current_player
  end
end