require_relative "../lib/racko_turn.rb"

class ComputerPlayerRackoTurn < RackoTurn

  private

  # Player picks which pile they want to pick a card from: draw pile, or discard pile
  def draw_card
    DisplayManager.prepare_ingame_display
    choose_new_card
    show_state

    @drew_from_discard = false

    puts "#{@current_player.name} has drawn from the Draw Pile."
  end

  # ensure a safe handoff between the players
  # don't let the players see eachother's racks!
  def ready_player
    show_state
    puts "It's #{@current_player.name}'s turn."
    thinking(3)
    sleep(1.5)
  end

  # Give the player time to review their rack, then clear the screen
  def finish_turn
    invalid_confirmation = nil

    show_state
    puts "#{@current_player.name} is done! Ready to move on?"
    
    waiting_to_confirm_done = true
    puts InputManager.input_options({ affirmative: 'Hide Their Rack'}, invalid_confirmation)
    invalid_confirmation = nil
    
    response = InputManager.get

    if InputManager.affirmative?(response)
      waiting_to_confirm_done = false
    elsif InputManager.negative?(response)
      # do nothing, wait
    else
      invalid_confirmation = response
    end
  end

  # Make a display service?
  def show_state(anonymize = false)
    DisplayManager.prepare_ingame_display
    show_deck_state

    puts # blank line
    puts (anonymize ? "\tSwitching Turns" : "\t#{@current_player.name}'s Turn")

    show_rack(true)

    puts "#{@current_player.name} drew from the #{@drew_from_discard ? 'Discard' : 'Draw'} Pile." if @selected_card
    puts "They discarded #{@card_to_discard.to_s}." if @card_to_discard
  end

  def thinking(num_times)
    num_times.times do |not_used|
      puts %w(Thinking... Hmmm... Maybe... ...wait! Yeah.).sample
      sleep(rand + 0.4)
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

    save_and_discard(placement_indicator)
  end
end