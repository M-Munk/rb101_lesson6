# Problem: the computer currently picks a square at random
# That's not very interesting.
# Make the computer defensive minded.
# If there is an immediate threat, then it will defend
# the third square.
# Consider an immediate threat to be 2 squares marked
# by the opponent in a row.
# if there is no immediate threat, then it will 
# pick a random square.

INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                [[1, 5, 9], [3, 5, 7]] # diagonals

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

def computer_defense_move(brd)
  move_line = []
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 2 &&
       brd.values_at(*line).count(INITIAL_MARKER) == 1
      move_line = line
      break
    end
  end
  return nil if move_line.empty?
  move_line_select { |num| brd[num] == ' ' }.join.to_i
end

def should_computer_defend?(brd)
  !!computer_defense_move(brd)
end

def computer_places_piece!(brd)
  square = if should_computer_defend?(brd)
             computer_defense_move(brd)
           else
             empty_squares(brd).sample
           end
  brd[square] = COMPUTER_MARKER
end
