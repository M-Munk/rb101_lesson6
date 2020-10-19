# Keep score of how many times the player and computer win.
# Don't use global or instance variables.
# Make it so that the first player to 5 wins the game.

# inputs: winner (player or computer)
# outputs: current match statistics: each player #games won

# data structure: hash with keys = players
# values = current games won

# Algorithm:
# game plays as normal
# when a winner is declared
# hash value increments by 1 for the appropriate player
# match ends after a player reaches 5 wins
# if the player exits out of the game before the match 
# is complete: display match statistics before final 
# thank you for playing.

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

def initialize_scoreboard
  { player: 0, computer: 0 }
end

def update_score!(scrbrd, brd)
  winner = detect_winner(brd).downcase.to_sym
  scrbrd[winner] += 1
end

def display_score(scrbrd)
  puts "Match Score:"
  puts "Player: #{scrbrd[:player]}"
  puts "Computer: #{scrbrd[:computer]}"
  display_match_winner(scrbrd) if match_over?(scrbrd)
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

# tests
score = initialize_scoreboard
p score
update_score!(score, {1 => 'X', 2 => 'X', 3 => 'X', 4 =>'O', 5 => 'X', 6 => 'O', 7 => 'O', 8 => ' ', 9 => 'O'})
p score
score = {player: 5, computer: 3}
display_score(score)