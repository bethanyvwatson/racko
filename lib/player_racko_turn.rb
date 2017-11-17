require_relative "../lib/racko_turn.rb"

class PlayerRackoTurn < RackoTurn

  private

  # Player picks which pile they want to pick a card from: draw pile, or discard pile
  def draw_card
    waiting_to_pick_pile = true

    invalid_pile = nil
    while waiting_to_pick_pile
      DisplayManager.prepare_ingame_display
      show_state

      puts "Do you want to draw a new card, or use the top discarded card?"
      puts InputManager.input_options({ affirmative: 'Draw New Card', negative: 'Take Last Discarded Card' }, invalid_pile)
      invalid_pile = nil
      
      response = InputManager.get

      # If player picks the draw pile
      # draw the top card from that pile
      if InputManager.affirmative?(response)
        choose_new_card
        waiting_to_pick_pile = false

      # If player picks from discard pile
      # draw top card from that pile
      # player cannot discard this card
      elsif InputManager.negative?(response)
        choose_discard
        waiting_to_pick_pile = false
      else
        invalid_pile = response
      end
    end
  end

  # ensure a safe handoff between the players
  # don't let the players see eachother's racks!
  def ready_player
    waiting_for_next_player = true
    invalid_ready = nil

    while waiting_for_next_player
      DisplayManager.prepare_ingame_display
      show_state(true)
      puts "It's #{@current_player.name}'s turn! Are you #{@current_player.name}?"
      puts InputManager.input_options({ affirmative: 'Yes! Display my Rack'}, invalid_ready)
      invalid_ready = nil

      response = InputManager.get

      if InputManager.affirmative?(response)
        waiting_for_next_player = false
      elsif InputManager.negative?(response)
        # do nothing
      else
        invalid_ready = response
      end
    end 

    DisplayManager.prepare_ingame_display
  end

  # Give the player time to review their rack, then clear the screen
  def finish_turn
    waiting_to_confirm_done = true
    invalid_confirmation = nil

    while waiting_to_confirm_done
      DisplayManager.prepare_ingame_display
      show_state
      puts 'Done! Your turn is now over.'
      puts InputManager.input_options({ affirmative: 'Hide my Rack'}, invalid_confirmation)
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

    DisplayManager.prepare_ingame_display
  end

  def reset_turn
    @selected_card = nil
    @drew_from_discard = false
  end

  # Player has drawn their card. 
  # Now they decide where to put it in their rack.
  # They can discard it if the card was not drawn from the discard pile.
  def use_card
    waiting_to_confirm_placement = true
    waiting_to_use_card = true
    invalid_usage = nil
    invalid_confirmation = nil

    while waiting_to_confirm_placement
      while waiting_to_use_card
        DisplayManager.prepare_ingame_display
        show_state
        puts "Newest Card: #{@selected_card.to_s} #{'* you cannot discard this card' if @drew_from_discard}" unless @selected_card.nil?

        @card_to_replace = nil
        @card_to_discard = nil

        puts InputManager.input_options({ negative: 'Discard this Card', rack_positions: 'Switch With Card at Position' }, invalid_usage)
        invalid_usage = nil

        @placement_response = InputManager.get

        # If player chooses a location in their rack
        # Get ready to exchange those cards
        if InputManager::INPUTS[:rack_positions].include?(@placement_response)
          prep_place_card_in_rack(@placement_response)
          waiting_to_use_card = false

        # If player chooses to discard their card
        # get ready to discard their card
        # Disallow discard if card was drawn from the discard pile
        elsif InputManager.negative?(@placement_response)
          if @drew_from_discard
            puts "You cannot discard this card because you drew it from the discard pile."
          else
            prep_discard_drawn_card
            waiting_to_use_card = false
          end
        else
          invalid_usage = @placement_response
        end
      end

      DisplayManager.prepare_ingame_display
      show_state
      puts "Newest Card: #{@selected_card.to_s}"

      if @card_to_replace
        puts "You want to exchange #{@card_to_replace.to_s} with #{@selected_card.to_s}."
      else
        puts "You do not want to use #{@selected_card.to_s}."
      end

      puts "You are discarding #{@card_to_discard.to_s}."

      puts InputManager.input_options({ affirmative: 'Save and Complete Turn', negative: 'Do Something Different' }, invalid_confirmation)
      invalid_confirmation = nil
      confirm_response = InputManager.get

      # If player confirms their decision
      # persist their decision
      if InputManager.affirmative?(confirm_response)
        save_and_discard(@placement_response)
        waiting_to_confirm_placement = false
      
      # If player changes their mind
      # allow them to choose how to use their card again 
      elsif InputManager.negative?(confirm_response)
        waiting_to_use_card = true
      else
        invalid_confirmation = confirm_response
      end
    end
  end
end