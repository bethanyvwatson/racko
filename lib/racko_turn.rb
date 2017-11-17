class RackoTurn

  def initialize(current_player, deck_manager)
    @current_player = current_player
    @draw_pile = deck_manager.draw_pile
    @discard_pile = deck_manager.discard_pile

    @selected_card = nil
    @drew_from_discard = false
  end

  def take_turn
    reset_turn
    ready_player
    draw_card
    use_card
    finish_turn
  end

  private

  def choose_new_card
    @selected_card = @draw_pile.draw_card
  end

  def choose_discard
    @selected_card = @discard_pile.draw_card
    @drew_from_discard = true
  end

  def prep_place_card_in_rack(placement_indicator)
    @card_to_replace = @current_player.rack.get_card(placement_response)
    @card_to_discard = @card_to_replace
  end

  def prep_discard_drawn_card
    @card_to_replace = nil
    @card_to_discard = @selected_card
  end

  def save_and_discard(placement_indicator)
    @current_player.rack.replace_card(placement_indicator, @selected_card) if @card_to_replace
    @discard_pile.add_to_deck(@card_to_discard)
  end

  def reset_turn
    @selected_card = nil
    @drew_from_discard = false
  end

  def show_deck_state
    puts "\t" + '-' * 50
    puts "\tDraw Pile: ??          Discard Pile: #{(@discard_pile.cards.first || 'N/A').to_s}"
    puts "\t" + '-' * 50
  end
end