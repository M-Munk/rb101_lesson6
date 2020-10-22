def calculate_card_value(deck, player)
  hand = deck.select { |_, v| v == player }.keys
  values = hand.map { |card| card[0] }
  total = 0
  values.each do |value|
    if value == 'Ace'
      total += 11
    elsif value.to_i == 0
      total += FACE_CARD
    else
      total += value.to_i
    end
  end
  check_ace(values, total)
end

total += if value == 'Ace'
          11
         elsif value.to_i == 0
          FACE_CARD
         else
          value.to_i
          end