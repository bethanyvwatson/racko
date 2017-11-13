class ComputerPlayer < Player

  def initialize(name = 'Computer', rack)
    super
  end

  def exchange_or_discard(num_to_use, rack)
    discarded_card = num_to_use

    # take care of first and last edge cases
    if num_to_use == 60
      discarded_card = rack[8]
      rack[8] = num_to_use
    elsif num_to_use == 1
      discarded_card = rack[0]
      rack[0] = num_to_use
    else
      rack.each.with_index do |curr, i|
        if num_to_use <= max_for_i(i)
          # if the next index might be a more valuable fit
          if curr >= rack[i-1] && curr < num_to_use
            next
          else
            rack[i] = num_to_use
            discarded_card = curr
            break
          end
        end
      end
    end
    puts discarded_card
    puts rack.to_s
  end

  def max_for_i(i)
    (7 * ( i + 1) + 4)
  end
end