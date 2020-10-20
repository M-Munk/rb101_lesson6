require 'pry'

INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                [[1, 5, 9], [3, 5, 7]] # diagonals

def prompt(msg)
  puts "=> #{msg}"
end

# rubocop:disable Metrics/AbcSize
def display_board(brd)
  system 'clear'
  puts "    You are #{PLAYER_MARKER}"
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  puts "     |     |"
  puts ""
end
# rubocop:enable Metrics/AbcSize

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def joinor(empty, punctuation = ', ', ending = 'or')
  joined = ''
  len = empty.size

  empty.each.with_index do |word, index|
    case len
    when 1
      joined << word.to_s
      break
    when 2
      joined << "#{word} " unless index == len - 1
    else
      joined << "#{word}#{punctuation}" unless index == len - 1
    end
    joined << "#{ending} #{word}" if index == len - 1
  end
  joined
end

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Choose a square (#{joinor(empty_squares(brd))}): "
    square = gets.chomp.to_i
    if empty_squares(brd).include?(square)
      break
    else
      prompt "Sorry, that's not a valid choice."
    end
  end
  brd[square] = PLAYER_MARKER
end

def computer_choose_move(brd, marker)
  move_line = []
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(marker) == 2 &&
       brd.values_at(*line).count(INITIAL_MARKER) == 1
      move_line = line
      break
    end
  end
  return nil if move_line.empty?
  move_line.select { |num| brd[num] == ' ' }.join.to_i
end

def should_computer_attack?(brd)
  !!computer_choose_move(brd, COMPUTER_MARKER)
end

def should_computer_defend?(brd)
  !!computer_choose_move(brd, PLAYER_MARKER)
end

def middle_is_open?(brd)
  brd[5] == ' '
end

def computer_places_piece!(brd)
  square = if should_computer_attack?(brd)
             computer_choose_move(brd, COMPUTER_MARKER)
           elsif should_computer_defend?(brd)
             computer_choose_move(brd, PLAYER_MARKER)
           elsif middle_is_open?(brd)
             5
           else
             empty_squares(brd).sample
           end
  brd[square] = COMPUTER_MARKER
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

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

def display_outcome(brd)
  if someone_won?(brd)
    prompt "#{detect_winner(brd)} won!"
  else
    prompt "It's a tie!"
  end
end

def initialize_scoreboard
  { player: 0, computer: 0, ties: 0 }
end

def update_score!(scrbrd, brd)
  if someone_won?(brd)
    winner = detect_winner(brd).downcase.to_sym
    scrbrd[winner] += 1
  else
    scrbrd[:ties] += 1
  end
end

def display_score(scrbrd)
  puts "Match Score:"
  puts "Player: #{scrbrd[:player]}"
  puts "Computer: #{scrbrd[:computer]}"
  puts "Ties: #{scrbrd[:ties]}"
  display_match_winner(scrbrd) if match_over?(scrbrd)
  puts ""
end

def match_winner(scrbrd)
  if scrbrd[:player] == 5
    return 'Player'
  elsif scrbrd[:computer] == 5
    return 'Computer'
  end
  nil
end

def match_over?(scrbrd)
  !!match_winner(scrbrd)
end

def display_match_winner(scrbrd)
  puts "#{match_winner(scrbrd)} wins this match!"
end

def play_again?
  prompt "Play again? (y or n)"
  answer = gets.chomp
  answer.downcase == 'y' || answer.downcase == 'yes'
end

def another_match?
  prompt "Would you like to play another match? (y or n)"
  answer = gets.chomp
  answer.downcase == 'y' || answer.downcase == 'yes'
end

# Game Loop

loop do
  score = initialize_scoreboard
  loop do
    board = initialize_board
    display_board(board)
    display_score(score)

    loop do
      display_board(board)
      display_score(score)
      player_places_piece!(board)
      break if someone_won?(board) || board_full?(board)
      computer_places_piece!(board)
      break if someone_won?(board) || board_full?(board)
    end

    update_score!(score, board)
    display_board(board)
    display_score(score)
    display_outcome(board)
    break if match_over?(score)
    break unless play_again?
  end

  break unless another_match?
end
prompt "Thanks for playing Tic Tac Toe! Goodbye."
