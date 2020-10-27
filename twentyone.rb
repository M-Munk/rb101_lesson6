SUITS = %w(Hearts Spades Clubs Diamonds)
CARD_VALUES = %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace)
PLAYER = :player
DEALER = :dealer
DEALER_MUST_STAY = 17
HIGHEST_HAND = 21
FACE_CARD = 10
LINE = "+---------------------------+"
WINNING_SCORE = 5
INITIAL_HAND_SIZE = 2

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

def display_hand(deck, player, total)
  puts "    #{player == :player ? 'Your' : 'The Dealer\'s'} cards are: "
  puts LINE
  hand = deck.select { |_, v| v == player }.keys
  hand.each do |card|
    puts "     #{card[0]} of #{card[1]}"
  end
  puts ""
  prompt("  Total: #{total}")
  puts ""
end

def display_dealer_initial_hand(deck)
  puts "    The dealer's cards are: "
  puts LINE
  hand = deck.select { |_, v| v == DEALER }.keys
  puts "  #{hand[0][0]} of #{hand[0][1]}"
  puts "  the second card is face down."
  puts ""
end

def deal_initial_hands(deck, player, dealer)
  INITIAL_HAND_SIZE.times do
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

def bust?(card_value)
  card_value > HIGHEST_HAND
end

def dealer_hit?(total)
  total < DEALER_MUST_STAY
end

def calculate_winner(player_total, dealer_total)
  if (!bust?(player_total) && player_total >= dealer_total) ||
     bust?(dealer_total)
    'Player'
  else
    'Dealer'
  end
end

def display_outcome(deck, player_total, dealer_total)
  puts LINE
  puts "    The winner is: #{calculate_winner(player_total, dealer_total)}"
  puts "    You Busted!" if bust?(player_total)
  puts "    The Dealer Busted!" if bust?(dealer_total)
  puts LINE
  puts ""
  display_hand(deck, PLAYER, player_total)
  display_hand(deck, DEALER, dealer_total)
end

def play_again?
  prompt("Would you like to play again? (y/n)")
  answer = user_answer
  valid_yes?(answer)
end

def valid_answer?(ans)
  %w(yes y no n).include?(ans)
end

def valid_yes?(ans)
  %w(yes y).include?(ans)
end

def display_welcome
  clear_screen
  prompt("Welcome to Twenty-One: A Simplified Black Jack Game")
  puts "+---------------------------------------------------+"
  prompt("The Player with the highest value of cards")
  prompt("without going over #{HIGHEST_HAND} wins.")
  prompt("The Player will win any ties.")
  prompt("The first player to win #{WINNING_SCORE} hands wins the round!")
  prompt("Good Luck!")
  prompt("Please press enter to continue")
  gets
  clear_screen
end

def display_goodbye
  prompt("Thank you for playing Twenty-One!")
  prompt("Goodbye!")
end

def display_dealer_play
  prompt("The Dealer hits!")
  puts ''
end

def initialize_scoreboard
  { player: 0, dealer: 0 }
end

def update_score!(scrbrd, player_total, dealer_total)
  winner = calculate_winner(player_total, dealer_total).downcase.to_sym
  scrbrd[winner] += 1
end

def display_score(scrbrd)
  puts LINE
  puts "Match Score:"
  puts "Player: #{scrbrd[PLAYER]}"
  puts "Dealer: #{scrbrd[DEALER]}"
  puts LINE
  puts ""
end

def match_winner(scrbrd)
  if scrbrd[PLAYER] == WINNING_SCORE
    return 'Player'
  elsif scrbrd[DEALER] == WINNING_SCORE
    return 'Dealer'
  end
  nil
end

def winner?(scrbrd)
  !!match_winner(scrbrd)
end

def another_match?
  prompt("Would you like to play another match? (y/n)")
  answer = user_answer
  valid_yes?(answer)
end

def user_answer
  loop do
    answer = gets.chomp
    return answer if valid_answer?(answer)
    prompt "I'm sorry, I don't understand your answer."
  end
end

def clear_screen
  system 'clear'
end

def display_match_winner(scrbrd)
  prompt("#{match_winner(scrbrd)} wins the match!")
end

# ----------- program loop ----------- #

display_welcome

loop do # main loop - match
  score = initialize_scoreboard
  clear_screen

  loop do # hand loop
    deck = build_deck
    deal_initial_hands(deck, PLAYER, DEALER)
    player_score = calculate_card_value(deck, PLAYER)
    dealer_score = calculate_card_value(deck, DEALER)
    display_hand(deck, PLAYER, player_score)
    display_dealer_initial_hand(deck)

    loop do # player loop
      break unless player_hit?
      deal_card!(deck, PLAYER)
      player_score = calculate_card_value(deck, PLAYER)
      display_hand(deck, PLAYER, player_score)
      break if bust?(player_score)
    end

    unless bust?(player_score)
      loop do # dealer loop
        break unless dealer_hit?(dealer_score)
        display_dealer_play
        deal_card!(deck, DEALER)
        dealer_score = calculate_card_value(deck, DEALER)
        display_hand(deck, DEALER, dealer_score)
      end
    end

    display_outcome(deck, player_score, dealer_score)
    update_score!(score, player_score, dealer_score)
    display_score(score)
    break if winner?(score)
    break unless play_again?
    clear_screen
  end

  display_match_winner(score)
  break unless another_match?
end

display_goodbye
