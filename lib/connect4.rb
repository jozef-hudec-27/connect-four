require_relative 'player'
require_relative 'terminal'

class Connect4
  attr_reader :board, :rows, :cols, :player1, :player2

  def initialize(board = Array.new(6) { Array.new(7, nil) }, player1 = Player.new, player2 = Player.new)
    @board = board
    @rows = board.length
    @cols = board[0].length
    @player1 = player1
    @player2 = player2
    # play
  end

  def pretty_print_board
    pretty_row = ->(row) { row.map { |place| place.nil? ? '⬜' : place.circle } }

    pretty_board = [[], ['1️⃣', ' 2️⃣', ' 3️⃣', ' 4️⃣', ' 5️⃣', ' 6️⃣', ' 7️⃣']]
    pretty_board.concat(board.map { |row| pretty_row.call(row) })

    pretty_board.each { |row| puts row.join(' ') }
  end

  def play
    game_loop

    return puts TerminalMessages.game_tie_message if tie?

    puts TerminalMessages.game_winner_message(winner&.name)
  end

  def game_loop
    round = 0

    until winner || board_full?
      pretty_print_board
      current_player = [player1, player2][round % 2]
      position = player_position(current_player)
      return if position == 'quit'

      play_round(current_player, position)
      round += 1
    end

    pretty_print_board
  end

  def player_position(player)
    puts TerminalMessages.pick_position_message(player.name, player.circle)

    loop do
      position = gets.chomp
      return (position == 'quit' ? 'quit' : position.to_i) if position_valid?(position)

      puts TerminalMessages.invalid_position_message
    end
  end

  def position_valid?(position)
    return false unless position.to_i.between?(1, 7) || position == 'quit'

    board[0][position.to_i - 1].nil?
  end

  def play_round(player, position)
    col = position - 1
    row = available_row(col)
    board[row][col] = player
  end

  def available_row(col)
    (rows - 1).downto(0) do |row|
      return row if board[row][col].nil?
    end
  end

  def winner
    (rows - 1).downto(0) do |row|
      (cols - 1).downto(0) do |col|
        return board[row][col] if horizontal_winner?(row, col) || vertical_winner?(row, col) || diagonal_winner?(row, col)
      end
    end

    nil
  end

  def board_full?
    board.flatten.uniq.length == 2 && board[0][0]
  end

  def tie?
    board_full? && !winner
  end

  def horizontal_winner?(row, col)
    return if board[row][col].nil? || (col - 3).negative?

    current = board[row][col]
    left1, left2, left3 = board[row][col - 1], board[row][col - 2], board[row][col - 3]
    [current, left1, left2, left3].uniq.length == 1
  end

  def vertical_winner?(row, col)
    return if board[row][col].nil? || (row - 3).negative?

    current = board[row][col]
    up1, up2, up3 = board.dig(row - 1)&.dig(col), board.dig(row - 2)&.dig(col), board.dig(row - 3)&.dig(col)
    [current, up1, up2, up3].uniq.length == 1
  end

  def diagonal_winner?(row, col)
    current = board[row][col]
    left_diagonal_winner?(row, col, current) || right_diagonal_winner?(row, col, current)
  end

  def left_diagonal_winner?(row, col, current)
    return if current.nil? || (row - 3).negative? || (col - 3).negative?

    left_up1, left_up2, left_up3 = board[row - 1]&.dig(col - 1), board[row - 2]&.dig(col - 2), board[row - 3]&.dig(col - 3)
    [current, left_up1, left_up2, left_up3].uniq.length == 1
  end

  def right_diagonal_winner?(row, col, current)
    return if current.nil? || (row - 3).negative?

    right_up1, right_up2, right_up3 = board[row - 1]&.dig(col + 1), board[row - 2]&.dig(col + 2), board[row - 3]&.dig(col + 3)
    [current, right_up1, right_up2, right_up3].uniq.length == 1
  end
end
