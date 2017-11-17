class ComputerPlayerBrain
  HIGH_NO_BRAINERS = (58..60).to_a
  LOW_NO_BRAINERS = (1..3).to_a

  # returns index for recommended placement, or -1 to discard
  def index_to_replace(newest_number, rack_numbers)
    if HIGH_NO_BRAINERS.include?(newest_number)
      return rack_numbers.length - 1
    elsif LOW_NO_BRAINERS.include?(newest_number)
      return 0
    else
      rack_numbers.each.with_index do |curr, i|
        if newest_number <= max_num_recommended_for_i(i)
          if current_number_is_better_fit?(curr, i, rack_numbers, newest_number)
            # newest number could be used for next index
            next
          else
            # recommend current index to switch
            return i
            break
          end
        end
      end
    end

    # decide to discard the newest_card
    return -1
  end

  private

  # is the current number larger than the previous and smaller than the newest?
  def current_number_is_better_fit?(curr, i, rack_numbers, newest_number)
    prev_index = [i-1, 0].max

    curr > rack_numbers[prev_index] && curr < newest_number
  end

  def max_num_recommended_for_i(i)
    i == 9 ? 60 : (6 * ( i + 1) + 3)
  end
end