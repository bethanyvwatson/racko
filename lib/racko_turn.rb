class RackoTurn < GameTurn

  TEXT = YAML.load_file('text.yml')

  def initialize(current_player, draw_pile, discard_pile)
    @current_player = current_player
    @draw_pile = draw_pile
    @discard_pile = discard_pile

    @selected_card = nil
    @drew_from_discard = false
  end

  def take_turn
    reset_turn
    ready_player
 
    show_state
 
    draw_card
    show_state

    use_card

    finish_turn
  end

  private

  # Player picks which pile they want to pick a card from: draw pile, or discard pile
  def draw_card
    waiting_to_pick_pile = true
    while waiting_to_pick_pile
      puts TEXT['game_turn']['draw_card']
      response = gets.chomp
      if ['new card'].include? response
        @selected_card = @draw_pile.draw_card
        waiting_to_pick_pile = false
      elsif ['discarded card'].include? response
        @selected_card = @discard_pile.draw_card
        @drew_from_discard = true
        waiting_to_pick_pile = false
      else
        puts TEXT['no_comprende']
      end
    end
  end

  # ensure a safe handoff between the players
  # don't let the players see eachother's racks!
  def ready_player
    waiting_for_next_player = true
    puts "It's #{@current_player.name}'s turn!"

    while waiting_for_next_player
      print "Are you #{@current_player.name}?"
      response = gets.chomp
      if ['yes'].include? response
        waiting_for_next_player = false
      elsif ['no'].include? response
      else
        print TEXT['no_comprende']
      end
    end 

    system('clear')
  end

  # Give the player time to review their rack, then clear the screen
  def finish_turn
    waiting_to_confirm_done = true

    while waiting_to_confirm_done
      puts "Are you ready to finish your turn?"
      response = gets.chomp
      if ['yes'].include? response
        waiting_to_confirm_done = false
      elsif ['no'].include? response
      else
        print TEXT['no_comprende']
      end
    end 

    system('clear')
  end

  def reset_turn
    @selected_card = nil
    @drew_from_discard = false
  end

  def show_state
    puts <<-TABLE
    #{@discard_pile.cards.any? ? @discard_pile.cards.first.show : 'N/A'}          |*?*|
    TABLE
    print @current_player.printable_player

    puts "Newest Card: #{@selected_card.show} #{'* you cannot discard this card' if @drew_from_discard}" unless @selected_card.nil?
  end

  # Player has drawn their card. 
  # Now they decide where to put it in their rack.
  # They can discard it if the card was not drawn from the discard pile.
  def use_card
    waiting_to_confirm_placement = true
    waiting_to_use_card = true

    while waiting_to_confirm_placement
      while waiting_to_use_card
        @card_to_replace = nil
        @card_to_discard = nil

        puts TEXT['game_turn']['use_instructions']

        @placement_response = gets.chomp

        # If player chooses a location in their rack
        # Get ready to exchange those cards
        if Rack::RACK_MARKERS.include? @placement_response.upcase
          @card_to_replace = @current_player.rack.get_card(@placement_response)
          @card_to_discard = @card_to_replace

          waiting_to_use_card = false

        # If player chooses to discard their card
        # get ready to discard their card
        # Disallow discard if card was drawn from the discard pile
        elsif ['discard'].include? @placement_response
          if @drew_from_discard
            puts TEXT['game_turn']['drew_from_discard_cannot_discard']
          else
            @card_to_replace = nil
            @card_to_discard = @selected_card

            waiting_to_use_card = false
          end
        else
          puts TEXT['no_comprende']
        end
      end

      show_state

      if @card_to_replace
        puts "You want to exchange #{@card_to_replace.show} with #{@selected_card.show}."
      else
        puts "You do not want to use #{@selected_card.show}."
      end

      puts "You are discarding #{@card_to_discard.show}."

      puts TEXT['game_turn']['confirm']
      confirm_response = gets.chomp

      # If player confirms their decision
      # persist their decision
      if ['yes'].include? confirm_response
        @current_player.rack.replace_card(@placement_response, @selected_card) if @card_to_replace
        @discard_pile.add_to_deck(@card_to_discard)
        waiting_to_confirm_placement = false
      
      # If player changes their mind
      # allow them to choose how to use their card again 
      elsif ['no'].include? confirm_response
        waiting_to_use_card = true
      else
        puts TEXT['no_comprende']
      end
    end
  end
end