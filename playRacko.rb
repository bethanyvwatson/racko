class PlayRacko
  require 'yaml'

  require_relative 'lib/deck.rb'
  require_relative 'lib/racko_deck.rb'
  require_relative 'lib/player.rb'
  require_relative 'lib/rack.rb'
  require_relative 'lib/card.rb'

  TEXT = YAML.load_file('text.yml')
  MAX_CARDS = 9

  def play
    # Greeting
    print TEXT['intro']['greeting']
    
    # Offer Rules
    go_over_the_rules
    
    # Get Player 1
    # Get Player 2
    init_players

    # Shuffle Cards
    init_decks
    # Deal Cards
    deal_cards

    # Begin Turns
    while @winning_player.nil?
      take_turn
      @current_player = @current_player == @player1 ? @player2 : @player1
    end

    puts "#{@current_player.name} wins!!!"
    puts TEXT['game_over']
    # Select a Deck to Draw From
    # Regular:
    # Draw Card. Choose discard or exchange. Discard.
    # Get Discarded: Exchange. Discard.
    # Check for win.
    # No Win:
    # End Turn. Next Player.
    # Win: Display winner. Display both hands.
  end

  def take_turn
    reset_turn
    ready_player
 
    show_state
 
    draw_card
    show_state

    use_card

    check_for_winner
  end

  def check_for_winner
    @winning_player = @current_player if @current_player.rack.is_ordered?
  end

  def reset_turn
    @selected_card = nil
    @drew_from_discard = false
  end

  private

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
        @current_player.rack.replace_card(@placement_response, @selected_card)
        waiting_to_confirm = false
      elsif ['no'].include? confirm_response
        waiting_to_use = true
      else
        puts TEXT['no_comprende']
      end
    end
  end

  def draw_card
    waiting = true
    while waiting
      puts TEXT['game_turn']['draw_card']
      response = gets.chomp
      if ['new card'].include? response
        @selected_card = @draw_pile.draw_card
        waiting = false
      elsif ['discarded card'].include? response
        @selected_card = @discard_pile.draw_card
        @drew_from_discard = true
        waiting = false
      else
        puts TEXT['no_comprende']
      end
    end
  end

  def show_state
    system("clear")

    puts <<-TABLE
    #{@discard_pile.cards.any? ? @discard_pile.cards.first.show : 'N/A'}          |*?*|
    TABLE
    print @current_player.printable_player

    puts "Newest Card: #{@selected_card.show} #{'* you cannot discard this card' if @drew_from_discard}" unless @selected_card.nil?
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

  def deal_cards
    #each player gets 9 cards. They are ordered in a rack. Cards are taken FROM the draw pile.
    MAX_CARDS.times do |d|
      @player1.rack.add_card(@draw_pile.draw_card)
      @player2.rack.add_card(@draw_pile.draw_card)
    end

    @discard_pile.add_to_deck(@draw_pile.draw_card)

    puts 'LETS SEE WHAT WE HAVE'
    @player1.rack.print_cards
    @player2.rack.print_cards
    @discard_pile.print_cards
    puts ''
  end

  def init_decks
    @draw_pile = RackoDeck.new
    @discard_pile = Deck.new

    print TEXT['time_to_shuffle']
    @draw_pile.print_cards
    @draw_pile.shuffle

    keep_shuffling = true
    while keep_shuffling
      puts ['Do you want to', 'Should we', 'Shall we'].sample + [' keep shuffling', ' shuffle'].sample + [' the cards',''].sample + [' again?', ' some more?', '?'].sample
      response = gets.chomp.downcase
      if ['yes'].include? response.downcase
        @draw_pile.shuffle
        @draw_pile.print_cards  
      elsif ['no'].include? response
        keep_shuffling = false
      else 
        print TEXT['no_comprende']
      end 
    end
    puts 'DONE'
    @draw_pile.print_cards
  end

  def init_players
    player1_name = ''
    player2_name = ''

    print TEXT['intro']['get_player_info']
    
    while player1_name.empty?
      print TEXT['intro']['player1']
      player1_name = gets.chomp
    end

    print "Nice to meet you, #{player1_name}.\n"

    while player2_name.empty?
      print TEXT['intro']['player2']
      player2_name = gets.chomp
    end

    print "Ok, #{player2_name}! Got it.\n"

    @player1 = Player.new(player1_name, Rack.new)
    @player2 = Player.new(player2_name, Rack.new)

    @current_player = @player1
    @winning_player = nil
  end

  def go_over_the_rules
    wants_rules = ''
    while !['yes', 'no'].include? wants_rules.downcase
      print TEXT['intro']['ask_rules']
      wants_rules = gets.chomp.downcase
      if ['yes'].include? wants_rules
        print TEXT['rules']
      elsif wants_rules == 'no'
      else 
        print TEXT['no_comprende']
      end 
    end
  end 

  PlayRacko.new.play
end 
