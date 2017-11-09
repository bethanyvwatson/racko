require_relative "../lib/player.rb"
require_relative "../lib/rack.rb"

class PlayerManager
  attr_reader :current_player, :players

  TEXT = YAML.load_file('text.yml')

  def initialize(players = [])
    @current_player = nil
    @players = players
  end

  # get the names of each player
  # initialize player objects
  def get_player_info
    waiting_init_players = true
    while waiting_init_players
      invalid_count = nil

      # get num players
      waiting_for_player_num = true
      while waiting_for_player_num
        system('clear')
        @players = []

        puts 'Just a bit more setup before we start.'
        puts InputManager.display_options({ player_counts: "How many players?" }, invalid_count)
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
        system('clear')

        print_roster
        puts "Enter a name for Player #{i + 1}:"
        name = InputManager.get

        @players << new_player(name)
      end

      # confirm players are correct
      waiting_confirm_players = true
      invalid_confirmation = nil
      while waiting_confirm_players
        system('clear')
        print_roster
        puts "Are you ready to play with these players?"
        puts InputManager.display_options({ affirmative: 'Confirm Players', negative: 'Redo Players' }, invalid_confirmation)
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

  def init_current_player
    raise if @players.nil? || @players.empty?
    @current_player = @players.first
  end

  def new_player(name)
    Player.new(name, Rack.new)
  end

  def print_roster
    @players.each.with_index(1) { |p, i| puts "Player #{i}: #{p.name}" }
  end
end