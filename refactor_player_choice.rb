# def player_places_piece!(brd)
#   square = ''
#   loop do
#     prompt "Choose a square (#{joinor(empty_squares(brd))}): "
#     square = gets.chomp.to_i
#     if empty_squares(brd).include?(square)
#       break
#     else
#       prompt "Sorry, that's not a valid choice."
#     end
#   end
#   brd[square] = PLAYER_MARKER
# end

def valid_space?(choice, brd)
  valid_choice = %w(1 2 3 4 5 6 7 8 9)
  valid_choice.include?(choice) && empty_squares(brd).include?(choice.to_i)
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Choose a square (#{joinor(empty_squares(brd))}): "
    square = gets.chomp
    break if valid_space?(square, brd)
    prompt "Sorry, that's not a valid choice."
  end
  brd[square.to_i] = PLAYER_MARKER
end
    