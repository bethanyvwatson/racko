class RulesManager
  TEXT = YAML.load_file('text.yml')
  AFFIRMATIVE = %w(1 y yes)
  NEGATIVE = %w(0 n no)
  RULES_INPUTS = <<-RULES_INPUTS
  Read Rules (#{AFFIRMATIVE.join('/')}) 
  Play Now (#{NEGATIVE.join('/')})
  RULES_INPUTS

   # player chooses if they want to see the rules
  def go_over_the_rules
    waiting_for_rules = true
    while waiting_for_rules
      print TEXT['intro']['ask_rules']
      print RULES_INPUTS
      wants_rules = gets.chomp.to_s.downcase
      system('clear')
      if AFFIRMATIVE.include?(wants_rules)
        print TEXT['rules']
        waiting_for_rules = false
        player_still_reading = true
        while player_still_reading
          puts "Them's the rules! Ready to play? (#{AFFIRMATIVE.join('/')})"
          player_ready = gets.chomp.to_s.downcase
          player_still_reading = false if AFFIRMATIVE.include?(player_ready)
        end
      elsif NEGATIVE.include?(wants_rules)
        waiting_for_rules = false
      else 
        print TEXT['no_comprende']
      end 
    end
  end 
end