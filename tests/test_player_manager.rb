require "test/unit"

require_relative "../lib/player_manager.rb"

class TestPlayerManager < Test::Unit::TestCase
  def setup
    @player1 = ::Player.new('One', ::Rack.new)
    @player2 = ::Player.new('Two', ::Rack.new)
    @manager = PlayerManager.new([@player1, @player2])
    @manager.send(:init_current_player)
  end

    def test_init_current_player
    # player 1 should start as the current player
    @manager.send(:init_current_player)
    assert_equal(@manager.current_player, @player1)

    # raise an error if players have not been initialized yet
    empty_manager = PlayerManager.new
    assert_raise(RuntimeError) {
     empty_manager.send(:init_current_player)
   }
  end

  def test_switch_players
    assert_equal(@manager.current_player, @player1)

    # player 2 should come after player 1
    @manager.switch_players
    assert_equal(@manager.current_player, @player2)

    # player 1 should come after player 2
    @manager.switch_players
    assert_equal(@manager.current_player, @player1)
  end
end