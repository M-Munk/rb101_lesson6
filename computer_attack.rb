def computer_attack_move(brd)
  move_line = []
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(COMPUTER_MARKER) == 2 &&
       brd.values_at(*line).count(INITIAL_MARKER) == 1
      move_line = line
      break
    end
  end
  return nil if move_line.empty?
  move_line.select { |num| brd[num] == ' ' }.join.to_i
end

def should_computer_attack?(brd)
  !!computer_attack_move(brd)
end

def computer_places_piece!(brd)
  square = if should_computer_attack?(brd)
             computer_attack_move(brd)
           elsif should_computer_defend?(brd)
             computer_defense_move(brd)
           else
             empty_squares(brd).sample
           end
  brd[square] = COMPUTER_MARKER
end