# create place_piece! method to place a piece depending on whose
# turn it is -> either the computer or the player

# create alternate_player to alternate between whose turn it is

# create first_player to determine who goes first

def go_first?
  prompt "Would you like to move first? (y/n)"
  answer = gets.chomp
  answer.downcase == 'y' || answer.downcase == 'yes'
end

def first_player
  if go_first?
    :player
  else
    :computer
  end
end

def alternate_player(player)
  if player == :player
    :computer
  else
    :player
  end
end

def place_piece!(player, brd)
  if player == :player
    player_places_piece!(brd)
  else
    computer_places_piece!(brd)
  end
end

def display_game_info(brd, scrbrd)
  display_board(brd)
  display_score(scrbrd)
end


loop do
  current_player = first_player
  score = initialize_scoreboard
  loop do
    board = initialize_board
    display_game_info(board, score)

    loop do
      place_piece!(current_player, board)
      current_player = alternate_player(current_player)
      break if someone_won?(board) || board_full?(board)
      display_game_info(board, score)
    end

    update_score!(score, board)
    display_game_info(board, score)
    display_outcome(board)
    break if match_over?(score)
    break unless play_again?
  end

  break unless another_match?
end
prompt "Thanks for playing Tic Tac Toe! Goodbye."