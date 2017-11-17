require '../lib/racko_turn.rb'

class ComputerPlayerRackoTurn < RackoTurn

  private

  # Player picks which pile they want to pick a card from: draw pile, or discard pile
  def draw_card
    DisplayManager.prepare_ingame_display
    choose_new_card
    show_state
    puts "#{@current_player.name} has drawn from the Draw Pile."
  end

  # ensure a safe handoff between the players
  # don't let the players see eachother's racks!
  def ready_player
    DisplayManager.prepare_ingame_display
    puts "It's #{@current_player.name}'s turn."
    sleep(2.5)
    thinking(3)
  end

  # Give the player time to review their rack, then clear the screen
  def finish_turn
    show_state
    puts "#{@current_player.name} is done!"
    puts "Hiding their rack..."
    sleep(3)
  end

  # Make a display service?
  def show_state(anonymize = false)
    DisplayManager.prepare_ingame_display
    show_deck_state

    if anonymize
      puts
      puts "\tSwitching Turns"
    else 
      puts
      puts "\t#{@current_player.name}'s Turn"
    end
    puts "\t" + @current_player.rack.to_placeholder
    puts "\t " + @current_player.rack.formatted_markers
  end

  def thinking(num_times)
    num_times.times do 
      %w(Thinking... Hmmm... Maybe... ...wait! Yeah.).sample
      sleep(.75)
    end
  end

  # Player has drawn their card. 
  # Now they decide where to put it in their rack.
  # They can discard it if the card was not drawn from the discard pile.
  def use_card
    index_to_place = @current_player.evaluate_number_placement(@selected_card.number)
    placement_indicator = nil

    if index_to_place >= 0
      placement_indicator = Rack::RACK_MARKERS[index_to_place]
      prep_place_card_in_rack(placement_indicator)
    else
      prep_discard_drawn_card
    end

    save_and_discard(indicator)
  end
end