valid_moves(GameState, ListOfMoves) :-
   game_state(Board, _) = GameState,
   length(Board, LengthBoard),
   LengthBoard1 is LengthBoard - 1, 
   findall(pos(NRow,NColumn), (between(0, LengthBoard1,NRow), between(0, LengthBoard1, NColumn)), ListFinalMoves),
   findall(move_position(Initial, Final), (member(Final, ListFinalMoves), valid_move(GameState, move_position(Initial, Final))), ListOfMoves).


%computer_move(+GameState, +Level, -Move)
computer_move(GameState,easy, Move) :-
    valid_moves(GameState, ListOfMoves),
    random_member(Move, ListOfMoves).