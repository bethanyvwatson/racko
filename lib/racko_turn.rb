class RackoTurn < GameTurn

  TEXT = YAML.load_file('text.yml')

  def initialize(current_player, draw_pile, discard_pile)
    @current_player = current_player
    @draw_pile = draw_pile
    @discard_pile = discard_pile

    @selected_card = nil
    @drew_from_discard = false
  end

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

  def ready_player
    waiting = true
    puts "It's #{@current_player.name}'s turn!"
    while waiting
      print TEXT['game_turn']['is_player_ready']
      response = gets.chomp
      if ['yes'].include? response
        waiting = false
      elsif ['no'].include? response
      else
        print TEXT['no_comprende']
      end
    end 
  end

  def reset_turn
    @selected_card = nil
    @drew_from_discard = false
  end

  def show_state
    system("clear")

    puts <<-TABLE
    #{@discard_pile.cards.any? ? @discard_pile.cards.first.show : 'N/A'}          |*?*|
    TABLE
    print @current_player.printable_player

    puts "Newest Card: #{@selected_card.show} #{'* you cannot discard this card' if @drew_from_discard}" unless @selected_card.nil?
  end

  def take_turn
    reset_turn
    ready_player
 
    show_state
 
    draw_card
    show_state

    use_card
  end

  def use_card
    waiting_to_confirm = true
    waiting_to_use = true
    while waiting_to_confirm
      while waiting_to_use
        @card_to_replace = nil
        @card_to_discard = nil

        puts TEXT['game_turn']['use_instructions']

        @placement_response = gets.chomp

        if Rack::RACK_MARKERS.include? @placement_response.upcase
          @card_to_replace = @current_player.rack.get_card(@placement_response)
          @card_to_discard = @card_to_replace

          waiting_to_use = false
        elsif ['discard'].include? @placement_response
          @card_to_replace = nil
          @card_to_discard = @selected_card

          waiting_to_use = false
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

      if ['yes'].include? confirm_response
        @current_player.rack.replace_card(@placement_response, @selected_card) if @card_to_replace
        @discard_pile.add_to_deck(@card_to_discard)
        waiting_to_confirm = false
      elsif ['no'].include? confirm_response
        waiting_to_use = true
      else
        puts TEXT['no_comprende']
      end
    end
  end
end