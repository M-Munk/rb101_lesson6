# if square 5 is available, the computer should pick that 
# when it does not need to attack or defend

def middle_is_open?(brd)
  brd[5] == ' '
end

def computer_places_piece!(brd)
  square = if should_computer_attack?(brd)
             computer_attack_move(brd)
           elsif should_computer_defend?(brd)
             computer_defense_move(brd)
           elsif middle_is_open?(brd)
             5
           else
             empty_squares(brd).sample
           end
  brd[square] = COMPUTER_MARKER
end