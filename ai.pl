valid_moves(GameState, ListOfMoves) :-
   findall(Move, valid_move(GameState, Move), ListOfMoves).

%computer_move(+GameState, +Level, -Move)
computer_move(GameState,easy, Move) :-
    valid_moves(GameState, ListOfMoves),
    random_member(Move, ListOfMoves).
