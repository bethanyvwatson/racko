class PlayerManager
  attr_reader :current_player, :players

  ACCEPTABLE_PLAYER_COUNTS = %w(2 3 4)

  def initialize
    @current_player = nil
    @players = []
  end

  # get the names of each player
  # initialize player objects
  def init_players
    waiting_init_players = true

    while waiting_init_players

      # get num players
      waiting_for_player_num = true
      while waiting_for_player_num
        system('clear')
        @players = []
        
        puts "How many players? (#{ACCEPTABLE_PLAYER_COUNTS.to_s})"
        num_players_response = gets.chomp.to_s

        if ACCEPTABLE_PLAYER_COUNTS.include? num_players_response
          waiting_for_player_num = false
          num_players = num_players_response.to_i
        else
          puts TEXT['no_comprende']
        end
      end 

      # init that many players
      num_players.times do |i|
        system('clear')

        puts "Enter a name for Player #{i + 1}:"
        name = gets.chomp

        @players << new_player(name)
      end

      # confirm players are correct
      waiting_confirm_players = true

      while waiting_confirm_players
        system('clear')
        @players.each.with_index(1) { |p, i| puts "Player #{i}: #{p.name}" }
        puts "Is this correct? (yes or no)"

        confirm_response = gets.chomp
        if ['yes'].include? confirm_response
          waiting_confirm_players = false
          waiting_init_players = false 
        elsif ['no'].include? confirm_response
          waiting_for_player_num = true 
          waiting_confirm_players = false
        end
      end
    end

    @current_player = @players.first
  end

  def switch_players
    player_index = @players.index(@current_player)
    @current_player = @players[player_index + 1] || @players[0]
  end

  private

  def new_player(name)
    Player.new(name, Rack.new)
  end
end