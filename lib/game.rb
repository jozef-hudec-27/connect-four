class Connect4
  attr_reader :board, :rows, :cols

  def initialize(board = Array.new(6) { Array.new(7, nil) }, player1 = Player.new, player2 = Player.new)
    @board = board
    @rows = board.length
    @cols = board[0].length
    @player1 = player1
    @player2 = player2
  end

  def pretty_print_board
    pretty_board = [['1️⃣', ' 2️⃣', ' 3️⃣', ' 4️⃣', ' 5️⃣', ' 6️⃣', ' 7️⃣']]

    rows.times do |row|
      pretty_board << []

      cols.times do |col|
        current = board[row][col]
        pretty_board[-1].push(current.nil? ? '⬜' : current.circle)
      end
    end

    pretty_board.each do |row|
      puts row.join(' ')
    end
  end

  def play
    current_round = 0

    until winner
      pretty_print_board
      current_player = [player1, player2][current_round % 2]
      play_round(current_player, player_position(current_player))
      current_round += 1
    end
  end

  def player_position(player)
    puts "It's #{player.name}'s turn! Pick your position."

    loop do
      position = gets.chomp
      return position.to_i if position_valid?(position)

      puts 'Invalid position! Please try again.'
    end
  end

  def position_valid?(position)
    return false if position.to_i.between?(1, 7)

    boarrd[0][position.to_i - 1].nil?
  end

  def play_round(player, position)
  end

  def winner
    (rows - 1).downto(0) do |row|
      (cols - 1).downto(0) do |col|
        return board[row][col] if horizontal_winner?(row, col) || vertical_winner?(row, col) || diagonal_winner?(row, col)
      end
    end

    nil
  end

  def horizontal_winner?(row, col)
    return if board[row][col].nil?

    current = board[row][col]
    left1, left2, left3 = board[row][col - 1], board[row][col - 2], board[row][col - 3]
    [current, left1, left2, left3].uniq.length == 1
  end

  def vertical_winner?(row, col)
    return if board[row][col].nil?

    current = board[row][col]
    up1, up2, up3 = board.dig(row - 1)&.dig(col), board.dig(row - 2)&.dig(col), board.dig(row - 3)&.dig(col)
    [current, up1, up2, up3].uniq.length == 1
  end

  def diagonal_winner?(row, col)
    return if board[row][col].nil?

    current = board[row][col]
    left_diagonal_winner?(row, col, current) || right_diagonal_winner?(row, col, current)
  end

  def left_diagonal_winner?(row, col, current)
    left_up1, left_up2, left_up3 = board[row - 1]&.dig(col - 1), board[row - 2]&.dig(col - 2), board[row - 3]&.dig(col - 3)
    [current, left_up1, left_up2, left_up3].uniq.length == 1
  end

  def right_diagonal_winner?(row, col, current)
    right_up1, right_up2, right_up3 = board[row - 1]&.dig(col + 1), board[row - 2]&.dig(col + 2), board[row - 3]&.dig(col + 3)
    [current, right_up1, right_up2, right_up3].uniq.length == 1
  end
end

class Player
  attr_reader :name, :circle

  @@players = []
  @@available_circles = { WHITE: '⚪', BLACK: '⚫', RED: '🔴', BLUE: '🔵', GREEN: '🟢', ORANGE: '🟠', YELLOW: '🟡',
                          PURPLE: '🟣' }

  def initialize
    # @name = Player.player_name
    # @circle = @@available_circles[Player.player_circle_sym]
    @name = "Player #{@@players.length + 1}"
    @circle = @@available_circles.values.sample
    @@players << self
    make_my_circle_unavailable
  end

  def self.player_name
    puts "Choose name for player #{@@players.length + 1}"

    loop do
      name = gets.chomp.strip
      return name if Player.player_name_valid?(name)

      puts 'Invalid name! Please try again.'
    end
  end

  def self.player_name_valid?(name)
    name && !@@players.map(&:name).include?(name) && !name.length.zero?
  end

  def self.player_circle_sym
    puts 'Choose your circle: '
    Player.print_available_circles

    loop do
      circle = gets.chomp.strip
      return circle.upcase.to_sym if Player.circle_valid?(circle)

      puts 'Invalid circle! Please try again.'
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

  def make_my_circle_unavailable
    @@available_circles.each do |k, v|
      @@available_circles.delete(k) if v == circle
    end
  end
end

pl1 = Player.new
pl2 = Player.new
b = [
  [nil, nil, nil, nil, nil, nil, pl2],
  [nil, nil, nil, nil, nil, nil, pl1],
  [nil, nil, nil, nil, nil, nil, pl2],
  [nil, pl2, nil, nil, nil, nil, pl1],
  [nil, pl1, nil, nil, nil, nil, pl2],
  [nil, pl1, pl2, nil, nil, nil, pl1]
]
c4 = Connect4.new(b, pl1, pl2)
c4.pretty_print_board