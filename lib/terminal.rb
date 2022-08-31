module TerminalMessages
  def self.choose_name_message(n)
    "\nChoose name for player #{n}"
  end

  def self.choose_circle_message
    "\nChoose your circle: "
  end

  def self.invalid_name_message
    '⛔ Invalid name! Please try again.'
  end

  def self.invalid_circle_message
    '⛔ Invalid circle! Please try again.'
  end

  def self.invalid_position_message
    '⛔ Invalid position! Please try again.'
  end

  def self.game_winner_message(name)
    "🎊 #{name} wins the game! 🎊"
  end

  def self.game_tie_message
    "The board is full. It's a tie!"
  end

  def self.pick_position_message(name, circle)
    "It's #{name}'s (#{circle}) turn! Pick your position."
  end
end
