Problem:
Build a single player Tic Tac Toe game where a user can play against the computer

Description:
Tic Tac Toe is a 2 player game played on a 3x3 board. Each player takes a turn and
marks a square on the board. First player to reach 3 squares in a row, including diagonals,
wins. If all 9 squares are marked and no player has 3 squares in a row, then the game is a tie.

Flow:
1. Display the initial empty 3x3 board.
2. Ask the user to mark a square.
3. Computer marks a square.
4. Display the updated board state.
5. If winner, display winner.
6. If board is full, display tie.
7. If neither winner nor board is full, go to #2
8. Play again?
9. If yes, go to #1
10. Good bye!

this notion of a board permiates every decision point

data structure that represents the board state:
hash: {1 => 'X', 2 => 'O', 3 => ' '} where keys represent the space and values represent empty, X, or O

detect winner:
first see if there is the same marker going across
if so, that player whose markers are there wins
see if any vertical squares have the same marker
if so, that player whose markers are there wins
see if any diagonal squares have the same marker
if so, that player whose markers are there wins

winning conditions: 
1, 2, 3
4, 5, 6
7, 8, 9
1, 4, 7
2, 5, 8
4, 6, 9

1, 5, 9
3, 5, 7

