valid_moves(GameState, ListOfMoves) :-
    game_state(Board, _) = GameState,
    valid_initial_positions(GameState, ValidInitialPositions),
    length(Board, LengthBoard),
    between(0, 9, NRow),
    between(0, 9, NColumn),
    member(InitialPosition, ValidInitialPositions),
    valid_move(GameState, move_position(InitialPosition, pos(NRow, NColumn))).
   % findall(move_position(InitialPosition, pos(NRow, NColumn)),(member(InitialPosition, ValidInitialPositions), valid_move(GameState, move_position(InitialPosition, pos(NRow, NColumn)))),ListOfMoves).

%computer_move(+GameState, +Level, -Move)
computer_move(GameState,easy, Move) :-
    valid_moves(GameState, ListOfMoves),
    random_member(Move, ListOfMoves).
