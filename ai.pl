%valid_moves(+GameState, -ListOfMoves)
%Unifica a variável ListOfMoves com a lista de todas as jogadas possíveis para o GameState
valid_moves(GameState, ListOfMoves) :-
   game_state(Board, _) = GameState,
   length(Board, LengthBoard),
   LengthBoard1 is LengthBoard - 1, 
   findall(pos(NRow,NColumn), (between(0, LengthBoard1,NRow), between(0, LengthBoard1, NColumn)), ListFinalMoves),
   findall(move_position(Initial, Final), (member(Final, ListFinalMoves), valid_move(GameState, move_position(Initial, Final))), ListOfMoves).

%choose_move(+GameState, +Level, -Move)
%Unifica a variável Move com uma jogada que o computador irá fazer.
choose_move(GameState, easy, Move) :-
    valid_moves(GameState, ListOfMoves),
    random_member(Move, ListOfMoves).

choose_move(GameState, difficult , Move) :-
   valid_moves(GameState, ListOfMoves),
   try_list_of_moves(GameState, ListOfMoves, Results),
   best_move(ListOfMoves, Results, Move).

try_list_of_moves(GameState, ListOfMoves, Results) :-
   try_moves(GameState, ListOfMoves, Results, []).

try_moves(_, [], Acc, Acc).
try_moves(GameState, [Move|Rest], Results, Acc) :-
   try_move(GameState, Move, Value),
   try_moves(GameState, Rest, Results, [Value|Acc]).

try_move(game_state(Board, Player), Move, Value) :-
   move(game_state(Board, Player), Move, NewGameState).
   value(NewGameState, Player, Value).

best_move(ListOfMoves, Results, BestMove) :-
    max_member(MaxResult, Results),
    findall(Index, nth0(Index, Results, MaxResult), Indices),
    length(Indices, NumIndices),
    random_member(Index, Indices),
    nth0(Index, ListOfMoves, BestMove).


coefficient(scared,-1).
coefficient(inWaterHole,0.98).
coefficient(trapped,-2).
coefficient(0.0, 2).
coefficient(Distance, Value):-
   Value is 1/Distance.
   
   %value(+GameState, +Player, -Value)
value(game_state(Board, Player), NPlayer, Value):-
   position_pieces(piece(_, NPlayer), Board, ListPositions),
   value_aux(Board, ListPositions,Value,0).
   
   %value_aux(+Board, +Positions, -Value, +Aux)
value_aux(_, [], Value, Aux):-
   Value is Aux/6.
   value_aux(Board, [Pos|Positions], Value, Aux):-
    findall(C, coefficient_at_position(Board, Pos, C), Coefficients),
    sum_list(Coefficients, CoefficientSum),
    NewAux is Aux + CoefficientSum,
    value_aux(Board, Positions, Value, NewAux).
   
list_of_distances(PositionMove, ListOfPositions, Results) :-
    distances(PositionMove, ListOfPositions, Results, []).
        
distances(PositionMove, [], Acc, Acc).
distances(PositionMove, [Position|Rest], Results, Acc) :-
    distance(PositionMove, Position, Value),
    distances(PositionMove, Rest, Results, [Value|Acc]).
        
distance(pos(NumRow1,NumCol1),pos(NumRow2,NumCol2),Distance):-
   DeltaX is NumRow2 - NumRow1,
   DeltaY is NumCol2 - NumCol1,
   Distance is sqrt(DeltaX * DeltaX + DeltaY * DeltaY).

coefficient_at_position(Board, Pos, C) :-
   find_water_holes(Board,ListWaterHoles),
   list_of_distances(Pos,ListWaterHoles, ListOfDistances),
   min_member(MinDistance, ListOfDistances),
   coefficient(MinDistance, C).
coefficient_at_position(Board, Pos, C) :-
   water_hole(Board, Pos),
   coefficient(inWaterHole, C).
coefficient_at_position(Board, Pos, C) :-
   trap_animal(Board, Pos),
   coefficient(trapped, C).
coefficient_at_position(Board, Pos, C) :-
   scared_animal(Board, Pos),
   coefficient(scared, C).
   