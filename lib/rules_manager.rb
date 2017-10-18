class RulesManager

  TEXT = YAML.load_file('text.yml')
  
   # player chooses if they want to see the rules
  def go_over_the_rules
    wants_rules = ''
    while !['yes', 'no'].include? wants_rules.downcase
      print TEXT['intro']['ask_rules']
      wants_rules = gets.chomp.downcase
      system('clear')
      if ['yes'].include? wants_rules
        print TEXT['rules']
        player_still_reading = true
        while player_still_reading
          puts 'Are you ready to play?'
          player_ready = gets.chomp.downcase
          player_still_reading = false if ['yes'].include?(player_ready)
        end
      elsif wants_rules == 'no'
      else 
        print TEXT['no_comprende']
      end 
    end
  end 
end