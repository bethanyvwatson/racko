class InputManager
  require_relative "../lib/rack.rb"

  INPUTS = {
    affirmative: %w(1 y yes),
    exit: %w(qq quit),
    negative: %w(0 n no),
    player_counts: %w(2 3 4), # move into RackInputs subclass
    rack_positions: Rack::RACK_MARKERS
  }

  def self.affirmative?(response)
    INPUTS[:affirmative].include?(response)
  end

  def self.display_options(opts, invalid_input = nil)
    display = invalid_input ? "Invalid input: #{invalid_input}.\n" : ''
    opts.each { |key, text| display += format_opts(text, INPUTS[key]) }
    display += format_opts('Exit Game', INPUTS[:exit])
    display
  end

  def self.format_opts(text, inputs_array)
    "\t#{text} (#{inputs_array.join('/')})\n"
  end

  def self.get
    input = gets.chomp.to_s.downcase
    abort(TEXT['exit']) if INPUTS[:exit].include?(input)
    input
  end

  def self.negative?(response)
    INPUTS[:negative].include?(response)
  end
end