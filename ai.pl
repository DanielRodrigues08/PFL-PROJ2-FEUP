valid_moves(GameState, ListOfMoves) :-
   game_state(Board, _) = GameState,
   length(Board, LengthBoard),
   LengthBoard1 is LengthBoard - 1, 
   findall(pos(NRow,NColumn), (between(0, LengthBoard1,NRow), between(0, LengthBoard1, NColumn)), ListFinalMoves),
   findall(move_position(Initial, Final), (member(Final, ListFinalMoves), valid_move(GameState, move_position(Initial, Final))), ListOfMoves).

%computer_move(+GameState, +Level, -Move)
computer_move(GameState, easy, Move) :-
    valid_moves(GameState, ListOfMoves),
    random_member(Move, ListOfMoves).

    
%computer_move(+GameState, +Level, -Move)
computer_move(GameState, easy, Move) :-
    valid_moves(GameState, ListOfMoves),
    random_member(Move, ListOfMoves).

computer_move(GameState, difficult , Move) :-
   valid_moves(GameState, ListOfMoves),
   try_list_of_moves(GameState, ListOfMoves, Results),
   best_move(ListOfMoves, Results, Move).

try_list_of_moves(GameState, ListOfMoves, Results) :-
   try_moves(GameState, ListOfMoves, Results, []).

try_moves(_, [], Acc, Acc).
try_moves(GameState, [Move|Rest], Results, Acc) :-
   %try_move(GameState, Move, Value),
   try_moves(GameState, Rest, Results, [Value|Acc]).

try_move(game_state(Board, Player), Move, Value) :-
   move(game_state(Board, Player), Move, NewGameState),
   value(NewGameState, Player, Value).

/*best_move(ListOfMoves, Results, BestMove) :-
    max_member(MaxResult, Results),
    nth0(Index, Results, MaxResult),
    nth0(Index, ListOfMoves, BestMove).*/

best_move(ListOfMoves, Results, BestMove) :-
    max_member(MaxResult, Results),
    findall(Index, nth0(Index, Results, MaxResult), Indices),
    length(Indices, NumIndices),
    random_member(Index, Indices),
    nth0(Index, ListOfMoves, BestMove).