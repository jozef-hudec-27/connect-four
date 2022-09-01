require_relative 'connect4'
require_relative 'player'
require_relative 'terminal'

loop do
  Connect4.new.play

  puts TerminalMessages.play_again_confirm_message
  break unless gets.chomp.downcase == 'y'

  Player.clear
end

puts TerminalMessages.end_message
