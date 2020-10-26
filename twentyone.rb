SUITS = %w(Hearts Spades Clubs Diamonds)
CARD_VALUES = %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace)
PLAYER = :player
DEALER = :dealer
DEALER_MUST_STAY = 17
HIGHEST_HAND = 21
FACE_CARD = 10

def prompt(msg)
  puts "==> #{msg}"
end

def build_deck
  new_deck = Hash.new
  deck = CARD_VALUES.product(SUITS).shuffle
  deck.each { |card| new_deck[card] = :deck }
  new_deck
end

def deal_card!(deck, player)
  card = deck.select { |_, v| v == :deck }.keys.sample
  update_deck!(deck, card, player)
end

def update_deck!(deck, card, player)
  deck[card] = player
end

def display_hand(deck, player)
  puts "    #{player == :player ? 'Your' : 'The dealer\'s'} cards are: "
  puts "+---------------------------+"
  hand = deck.select { |_, v| v == player }.keys
  hand.each do |card|
    puts "     #{card[0]} of #{card[1]}"
  end
  puts ""
  prompt("  Total: #{calculate_card_value(deck, player)}")
  puts ""
end

def display_dealer_initial_hand(deck)
  puts "    The dealer's cards are: "
  puts "+---------------------------+"
  hand = deck.select { |_, v| v == DEALER }.keys
  puts "  #{hand[0][0]} of #{hand[0][1]}"
  puts "  the second card is face down."
  puts ""
end

def deal_initial_hands(deck, player, dealer)
  2.times do
    deal_card!(deck, player)
    deal_card!(deck, dealer)
  end
end

def player_hit?
  answer = ''
  prompt("Would you like to hit or stay? (h -> hit, s -> stay)")
  loop do
    answer = gets.chomp
    break if valid_choice?(answer)
    prompt("I'm sorry, I don't understand...")
  end
  %w(h hit).include?(answer)
end

def valid_choice?(answer)
  %w(h hit s stay).include?(answer)
end

def calculate_card_value(deck, player)
  hand = deck.select { |_, v| v == player }.keys
  values = hand.map { |card| card[0] }
  total = 0
  values.each do |value|
    total += if value == 'Ace'
               11
             elsif value.to_i == 0
               FACE_CARD
             else
               value.to_i
             end
  end
  check_ace(values, total)
end

def check_ace(card_values, sum)
  card_values.select { |value| value == 'Ace' }.count.times do
    sum -= 10 if sum > HIGHEST_HAND
  end
  sum
end

def player_bust?(deck)
  calculate_card_value(deck, PLAYER) > HIGHEST_HAND
end

def dealer_hit?(deck)
  calculate_card_value(deck, DEALER) < DEALER_MUST_STAY
end

def calculate_winner(deck) # needs to check if player or dealer bust
  player_total = calculate_card_value(deck, PLAYER)
  dealer_total = calculate_card_value(deck, DEALER)
  if dealer_total > HIGHEST_HAND || player_total >= dealer_total
    'Player'
  else
    'Dealer'
  end
end

def display_outcome(deck)
  puts "+---------------------------+"
  puts "    The winner is: #{calculate_winner(deck)}"
  puts "+---------------------------+"
  display_hand(deck, PLAYER)
  display_hand(deck, DEALER)
end

def play_again?
  prompt("  Would you like to play again? (y/n)")
  answer = ''
  loop do
    answer = gets.chomp
    break if valid_answer?(answer)
    prompt("I'm sorry, I don't understand.")
  end
  valid_yes?(answer)
end

def valid_answer?(ans)
  %w(yes y no n).include?(ans)
end

def valid_yes?(ans)
  %w(yes y).include?(ans)
end

def display_welcome
  system 'clear'
  prompt("Welcome to Twenty-One: A Simplified Black Jack Game")
  puts "+---------------------------------------------------+"
  prompt("The Player with the highest value of cards")
  prompt("without going over 21 wins.")
  prompt("Good Luck!")
  prompt("Please press any key and enter to continue")
  gets
  system 'clear'
end

# ----------- program loop ----------- #
display_welcome
loop do
  system 'clear'
  deck = build_deck
  deal_initial_hands(deck, PLAYER, DEALER)
  display_hand(deck, PLAYER)
  display_dealer_initial_hand(deck)

  loop do # player loop
    break unless player_hit?
    deal_card!(deck, PLAYER)
    display_hand(deck, PLAYER)
    break if player_bust?(deck)
  end

  unless player_bust?(deck)
    loop do # dealer loop
      break unless dealer_hit?(deck)
      deal_card!(deck, DEALER)
    end
  end

  display_outcome(deck)
  break unless play_again?
end
