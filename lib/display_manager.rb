class DisplayManager
  TEXT = YAML.load_file('text.yml')
  
  def self.prepare_display
    system('clear')
    puts TEXT['racko']
  end
end