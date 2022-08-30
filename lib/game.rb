class Connect4
  attr_accessor :board

  def initialize(board = Array.new(6) { Array.new(7, nil) })
    @board = board
  end

  def play_round(player, position)
  end
end

class Player
  attr_reader :name, :circle

  @@players = []
  @@available_circles = { WHITE: '⚪', BLACK: '⚫', RED: '🔴', BLUE: '🔵', GREEN: '🟢', ORANGE: '🟠', YELLOW: '🟡',
                          PURPLE: '🟣' }

  def initialize
    @name = player_name
    @circle = @@available_circles[player_circle_sym]
    @@players << self
    Player.remove_available_circle(circle)
  end

  def player_name
    name = nil

    until player_name_valid?(name)
      puts "Choose name for player #{@@players.length + 1}"
      name = gets.chomp.strip
    end

    name
  end

  def player_name_valid?(name)
    name && !@@players.map(&:name).include?(name) && !name.length.zero?
  end

  def player_circle_sym
    circle = nil

    until circle_valid?(circle)
      puts 'Choose your circle: '
      Player.print_available_circles
      circle = gets.chomp.strip
    end

    circle.upcase.to_sym
  end

  def circle_valid?(circle)
    return false unless circle

    @@available_circles.keys.map.include?(circle.upcase.to_sym)
  end

  def self.print_available_circles
    circles_array = Player.available_circles_array
    puts circles_array.join('   ')
  end

  def self.available_circles_array
    hash = @@available_circles
    hash.keys.reduce([]) { |arr, c| arr + ["#{c} #{hash[c]}"] }
  end

  def self.remove_available_circle(circle)
    @@available_circles.each do |k, v|
      @@available_circles.delete(k) if v == circle
    end
  end
end

p1 = Player.new
p2 = Player.new
