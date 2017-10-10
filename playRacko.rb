class PlayRacko
  require 'yaml'

  require_relative 'lib/player.rb'
  require_relative 'lib/rack.rb'

  TEXT = YAML.load_file('text.yml')
  
  def play
    # Greeting
    print TEXT['intro']['greeting']
    
    # Offer Rules
    go_over_the_rules
    
    # Get Player 1
    # Get Player 2

    # Shuffle Cards
    # Deal Cards
    # Init Discard Pile

    # Begin Turns
    # Select a Deck to Draw From
    # Regular:
    # Draw Card. Choose discard or exchange. Discard.
    # Get Discarded: Exchange. Discard.
    # Check for win.
    # No Win:
    # End Turn. Next Player.
    # Win: Display winner. Display both hands.
    puts "Bye bye!"
  end

  private

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
