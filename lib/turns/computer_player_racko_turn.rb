require_relative "racko_turn"
require_relative "../players/computer_player_brain"

class ComputerPlayerRackoTurn < RackoTurn

  private

  # Player picks which pile they want to pick a card from: draw pile, or discard pile
  def draw_card
    DisplayManager.prepare_ingame_display
    show_state
    thinking(1)
    choose_draw_or_discard
    thinking(2)
    show_state
    puts "#{@current_player.name} has drawn from the #{@drew_from_discard ? 'Discard' : 'Draw'} Pile."
  end

  # ensure a safe handoff between the players
  # don't let the players see eachother's racks!
  def ready_player
    show_state
    puts "It's #{@current_player.name}'s turn."
  end

  # Give the player time to review their rack, then clear the screen
  def finish_turn
    invalid_confirmation = nil
    waiting_to_confirm_done = true

    while waiting_to_confirm_done
      DisplayManager.prepare_ingame_display
      show_state
      puts "#{@current_player.name} is done! Ready to move on?"
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
  end

  # Make a display service?
  def show_state(anonymize = false)
    DisplayManager.prepare_ingame_display
    show_deck_state

    puts # blank line
    puts (anonymize ? "\tSwitching Turns" : "\t#{@current_player.name}'s Turn")

    show_rack(true)

    if @selected_card
      draw_string = @drew_from_discard ? 
        "#{@current_player.name} drew #{@selected_card.to_s} from the Discard Pile." :
        "#{@current_player.name} drew a card from the Draw Pile."
      puts draw_string
    end

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
    # if we drew from the discard pile, 
    # we already know where we want to use the card
    if @drew_from_discard
      index_to_place = @place_for_top_discarded
    else
      index_to_place = @current_player.find_useful_rack_placement(@selected_card.number)
    end

    placement_indicator = nil

    # computer players will only draw the discarded card if they can use it
    # so there is no risk of them trying to discard the card
    if useful_placement?(index_to_place)
      placement_indicator = Rack::RACK_MARKERS[index_to_place]
      prep_place_card_in_rack(placement_indicator)
    else
      prep_discard_drawn_card
    end

    save_and_discard(placement_indicator)
  end

  def choose_draw_or_discard
    @place_for_top_discarded = -1# @current_player.find_useful_rack_placement(@discard_pile.cards.first.number)
    
    if useful_placement?(@place_for_top_discarded)
      choose_discard
    else
      choose_new_card
    end
  end

  def useful_placement?(index)
    index >= 0
  end

  # used only for simulations
  def test_take_turn(verbose = false)
    choose_draw_or_discard
    use_card
  end
end