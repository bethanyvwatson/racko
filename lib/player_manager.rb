require_relative "../lib/player.rb"
require_relative "../lib/rack.rb"

class PlayerManager
  attr_reader :current_player, :players

  ACCEPTABLE_PLAYER_COUNTS = %w(2 3 4)
  AFFIRMATIVE = %w(1 y yes)
  NEGATIVE = %w(0 n no)
  CONFIRM_PLAYER_INPUTS = <<-PLAYER_INPUTS
  Confirm Players (#{AFFIRMATIVE.join('/')})
  Redo Players (#{NEGATIVE.join('/')})
  PLAYER_INPUTS

  def initialize(players = [])
    @current_player = nil
    @players = players
  end

  # get the names of each player
  # initialize player objects
  def get_player_info
    waiting_init_players = true
    while waiting_init_players

      # get num players
      waiting_for_player_num = true
      while waiting_for_player_num
        system('clear')
        @players = []
        
        puts "How many players? (#{ACCEPTABLE_PLAYER_COUNTS.join('/')})"
        num_players_response = gets.chomp.to_s

        if ACCEPTABLE_PLAYER_COUNTS.include?(num_players_response)
          waiting_for_player_num = false
          num_players = num_players_response.to_i
        else
          puts TEXT['no_comprende']
        end
      end 

      # init that many players
      num_players.times do |i|
        system('clear')

        print_roster
        puts "Enter a name for Player #{i + 1}:"
        name = gets.chomp

        @players << new_player(name)
      end

      # confirm players are correct
      waiting_confirm_players = true
      while waiting_confirm_players
        system('clear')
        print_roster
        puts "Are you ready to play with these players?"
        puts CONFIRM_PLAYER_INPUTS
        confirm_response = gets.chomp

        # if yes, ready to play
        if AFFIRMATIVE.include?(confirm_response)
          waiting_confirm_players = false
          waiting_init_players = false 

        # if no, restart player selection
        elsif NEGATIVE.include?(confirm_response)
          waiting_for_player_num = true 
          waiting_confirm_players = false
        else
          # ask again
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