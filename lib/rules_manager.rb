class RulesManager
  TEXT = YAML.load_file('text.yml')

  # player chooses if they want to see the rules
  def go_over_the_rules
    waiting_for_rules = true
    invalid_rules = nil
    
    while waiting_for_rules
      DisplayManager.prepare_display
      puts "Before we start, do you want to read the rules for Ruby Racko?"
      puts InputManager.display_options({ affirmative: 'Read Rules', negative: 'Skip Rules' }, invalid_rules)
      invalid_rules = nil

      wants_rules = InputManager.get
      DisplayManager.prepare_display

      if InputManager.affirmative?(wants_rules)
        puts TEXT['rules']
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
        invalid_rules = wants_rules
      end 
    end
  end 
end