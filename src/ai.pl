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

%try_list_of_moves(+GameState, +ListofMoves, -Results)
%Cria uma lista com todas as avaliações de todos os possíveis moves 
try_list_of_moves(GameState, ListOfMoves, Results) :-
   try_moves(GameState, ListOfMoves, Results, []).

%try_moves(+GameState, +ListOfMoves, +Results, +Acc)
%Realiza o predicado try_move em cada elemento da lista de moves
try_moves(_, [], Results, Acc):-
   reverse(Acc,Results).
try_moves(GameState, [Move|Rest], Results, Acc) :-
   try_move(GameState, Move, Value),
   try_moves(GameState, Rest, Results, [Value|Acc]).

%try_move(+GameState, +Move, -Value)
%Simula um move e calcula a avaliação do estado de jogo que esse move irá criar
try_move(game_state(Board, Player), Move, Value) :-
   move(game_state(Board, Player), Move, NewGameState),
   value(NewGameState, Player, Move, Value).

%best_move(+ListOfMoves, +Results, -BestMove)
%Escolhe o o move com a melhor avaliação
best_move(ListOfMoves, Results, BestMove) :-
    max_member(MaxResult, Results),
    findall(Index, nth0(Index, Results, MaxResult), Indices),
    random_member(Index, Indices),
    nth0(Index, ListOfMoves, BestMove).

%coefficient(+Type, -Value)
% Instanciação dos coeficientes
coefficient(scared,-1).
coefficient(inWaterHole,10000).
coefficient(trapped,-2).
coefficient(Distance, Value):-
   number(Distance),
   Distance > 0,
   Value is 1/Distance.
   
%value(+GameState, +Player, +Move, -Value)
%Formula uma avaliação de uma estado de jogo na perspetiva de um jogador
value(game_state(Board, _), NPlayer, Move, Value):-
   position_pieces(piece(_,NPlayer),Board,ListOfPositions),
   value_aux(Board,ListOfPositions,Move,Value,0).
   
% value_aux(+Board, +Positions, -Value, +Aux)
% Predicado auxiliar do predicado value
value_aux(_, [],_, Value, Aux):- 
   Value is Aux/6.
value_aux(Board, [Pos|Positions],Move, Value, Aux):-
    findall(C, coefficient_at_position(Board,Move, Pos, C), Coefficients),
    sum_list(Coefficients, CoefficientSum),
    NewAux is Aux + CoefficientSum,
    value_aux(Board, Positions, Move, Value, NewAux).

%list_of_distances(+PositionMove, +ListOfPositions, -Results)
%Cria uma lista das distâncias entre os pontos da lista e um ponto
list_of_distances(PositionMove, ListOfPositions, Results) :-
    distances(PositionMove, ListOfPositions, Results, []).

%distance(+PositionMove, +ListOfPositions, -Results, +Acc)
% Auxilia o predicado list_of_distances    
distances(_, [], Acc, Acc).
distances(PositionMove, [Position|Rest], Results, Acc) :-
    distance(PositionMove, Position, Value),
    distances(PositionMove, Rest, Results, [Value|Acc]).
        
distance(pos(NumRow1,NumCol1),pos(NumRow2,NumCol2),Distance):-
   DeltaX is NumRow2 - NumRow1,
   DeltaY is NumCol2 - NumCol1,
   Distance is sqrt(DeltaX * DeltaX + DeltaY * DeltaY).

%coefficient_at_position(+Board, +Move, +Pos, -Value)
% Determina o coeficiente em diferentes situações
coefficient_at_position(Board,move_position(IPos,_), _, -200) :-
   \+scared_animal(Board, IPos),
   water_hole(Board, IPos),!.
coefficient_at_position(Board,_, Pos, C) :-
   water_hole(Board, Pos),
   coefficient(inWaterHole, C).
coefficient_at_position(Board,_,Pos, C) :-
   find_water_holes(Board,ListWaterHoles),
   list_of_distances(Pos,ListWaterHoles, ListOfDistances),
   min_member(MinDistance, ListOfDistances),
   coefficient(MinDistance, C).
coefficient_at_position(Board,_, Pos, C) :-
   trap_animal(Board, Pos),
   coefficient(trapped, C).
coefficient_at_position(Board,_, Pos, C) :-
   scared_animal(Board, Pos),
   coefficient(scared, C).