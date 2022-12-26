
%move(GameState, InitialPos, FinalPos, -NewGameState)
move(game_state(Board, Player), pos(InitialRow, InitialColumn), pos(FinalRow, FinalColumn), game_state(NewBoard, NewPlayer)).


%valid_moviment(+InitialPosition, +FinalPosition, +Piece)
%Verifica se o movimento de um determinado animal é válido
valid_moviment(pos(InitialRow, InitialColumn), pos(InitialRow, FinalColumn), piece(mice,_)) :-
    dif(InitialColumn, FinalColumn),
    !.
valid_moviment(pos(InitialRow, InitialColumn), pos(FinalRow, InitialColumn), piece(mice,_)) :-
    dif(InitialRow, FinalRow),
    !.
valid_moviment(pos(InitialRow, InitialColumn), pos(FinalRow, FinalColumn), piece(lion,_)) :-
    DisplacementRow is FinalRow - InitialRow,
    DisplacementColumn is FinalColumn - InitialColumn,
    abs(DisplacementColumn) =:= abs(DisplacementRow),
    !.
valid_moviment(pos(InitialRow, InitialColumn), pos(InitialRow, FinalColumn), piece(elephant,_)) :-
    dif(InitialColumn, FinalColumn),
    !.
valid_moviment(pos(InitialRow, InitialColumn), pos(FinalRow, InitialColumn), piece(elephant,_)) :-
    dif(InitialRow, FinalRow),
    !.
valid_moviment(pos(InitialRow, InitialColumn), pos(FinalRow, FinalColumn), piece(elephant,_)) :-
    DisplacementRow is FinalRow - InitialRow,
    DisplacementColumn is FinalColumn - InitialColumn,
    abs(DisplacementColumn) =:= abs(DisplacementRow),
    !.
