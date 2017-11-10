class DisplayManager
  TEXT = YAML.load_file('text.yml')
  
  def self.prepare_pregame_display
    system('clear')
    puts TEXT['racko_pregame']
  end

  def self.prepare_ingame_display
    system('clear')
    puts TEXT['racko_ingame']
  end
end