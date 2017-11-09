class RulesManager
  TEXT = YAML.load_file('text.yml')

  # player chooses if they want to see the rules
  def go_over_the_rules
    waiting_for_rules = true
    while waiting_for_rules
      print TEXT['intro']['ask_rules']
      print InputManager.display_options({ affirmative: 'Read Rules', negative: 'Skip Rules' })
      wants_rules = InputManager.get
      system('clear')
      if InputManager.affirmative?(wants_rules)
        print TEXT['rules']
        waiting_for_rules = false
        player_still_reading = true
        while player_still_reading
          puts InputManager.display_options({ affirmative: "Them's the rules! Ready to play?" })
          player_ready = InputManager.get
          player_still_reading = false if InputManager.affirmative?(player_ready)
        end
      elsif InputManager.negative?(wants_rules)
        waiting_for_rules = false
      else 
        print TEXT['no_comprende']
      end 
    end
  end 
end