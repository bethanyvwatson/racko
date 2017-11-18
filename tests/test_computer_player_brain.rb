require "test/unit"

require_relative "../lib/computer_player_brain.rb"

class TestComputerPlayerBrain < Test::Unit::TestCase

  def setup
    @brain = ComputerPlayerBrain.new
    @random_array = (1..60).to_a.shuffle
  end

  def test_max_num_recommended_for_i
    assert_equal(true, @brain.max_num_recommended_for_i(8) <= 60)
    assert_equal(true, max_array.length == max_array.uniq.length)
    assert_equal(true, @brain.max_num_recommended_for_i(4) == (7 * ( 4 + 1) + 3))
  end

  def test_index_to_replace
    # edgecase decisions are hardcoded
    edgecases_1_60
    recommends_within_range
    allows_better_fit_within_range
  end

  private

  def edgecases_1_60
    assert_equal(0, @brain.index_to_replace(1, @random_array))
    assert_equal(8, @brain.index_to_replace(60, @random_array))
  end

  def recommends_within_range
    arr = [4, 12, 24, 44, 34, 46, 55, 58]
    target_i = 3


    min = (@brain.max_num_recommended_for_i(target_i -1))
    max = (@brain.max_num_recommended_for_i(target_i))

    #any number in this range should be recommended for index 3
    (min..max).to_a do |num|
      assert_equal(target_i, @brain.index_to_replace(num, arr))
    end

    # numbers outside of this range should not result in a 3 recommendation
    assert_not_equal(target_i, @brain.index_to_replace(min - 1, arr))
    assert_not_equal(target_i, @brain.index_to_replace(max + 1, arr))

    # it doesn't matter that the item at index 3 was out of order
    arr = [4, 12, 20, 24, 34, 46, 55, 58]

    # any number in this range should be recommended for index 3
    (min..max).to_a do |num|
      assert_equal(target_i, @brain.index_to_replace(num, arr))
    end
  end

  # we should check ahead for a better fit for a new number
  # if the current number at i works fine in sequence
  def allows_better_fit_within_range
    arr = [4, 12, 20, 30, 29, 46, 55, 58]
    best_fit_i = 4
    first_fit_i = 3

    newest_number = 31
    assert_equal(true, newest_number <= @brain.max_num_recommended_for_i(first_fit_i))
    assert_equal(best_fit_i, @brain.index_to_replace(newest_number, arr))
  end

  # 10, 17, 24, 31, 38, 45, 52, 59, 60 - Nov 13 2017
  def max_array
    (0..8).to_a.map {|i| @brain.max_num_recommended_for_i(i) }
  end
end