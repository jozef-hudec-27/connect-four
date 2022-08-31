require_relative 'terminal'

class Player
  attr_reader :name, :circle

  @@players = []
  @@available_circles = { BLACK: '⚫', RED: '🔴', BLUE: '🔵', GREEN: '🟢', ORANGE: '🟠', YELLOW: '🟡', PURPLE: '🟣' }

  def initialize
    @name = Player.player_name
    @circle = @@available_circles[Player.player_circle_sym]
    @@players << self
    make_my_circle_unavailable
  end

  def self.player_name
    puts TerminalMessages.choose_name_message(@@players.length + 1)
    invalid_name_message = TerminalMessages.invalid_name_message

    loop do
      name = gets.chomp.strip
      return name if Player.player_name_valid?(name)

      puts @@players.length.zero? ? invalid_name_message : "#{invalid_name_message} Make sure your name is unique."
    end
  end

  def self.player_name_valid?(name)
    name && !@@players.map(&:name).include?(name) && !name.length.zero?
  end

  def self.player_circle_sym
    puts TerminalMessages.choose_circle_message
    Player.print_available_circles

    loop do
      circle = gets.chomp.strip
      return circle.upcase.to_sym if Player.circle_valid?(circle)

      puts TerminalMessages.invalid_circle_message
    end
  end

  def self.circle_valid?(circle)
    return false unless circle

    @@available_circles.keys.map.include?(circle.upcase.to_sym)
  end

  def self.print_available_circles
    circles_array = Player.available_circles_array
    puts circles_array.join('   ')
  end

  def self.available_circles
    @@available_circles
  end

  def self.available_circles_array
    hash = @@available_circles
    hash.keys.reduce([]) { |arr, c| arr + ["#{c} #{hash[c]}"] }
  end

  def self.clear
    @@players = []
    @@available_circles = { BLACK: '⚫', RED: '🔴', BLUE: '🔵', GREEN: '🟢', ORANGE: '🟠', YELLOW: '🟡', PURPLE: '🟣' }
  end

  def make_my_circle_unavailable
    @@available_circles.each do |k, v|
      @@available_circles.delete(k) if v == circle
    end
  end
end
