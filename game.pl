
game_init(BoardSize) :-
    initial_state(BoardSize, GameState),
    display_game(GameState),
    game_loop(GameState).

game_loop(GameState) :-
    game_over(GameState, Winner), !.

game_loop(GameState) :-
    choose_move(GameState, InitialPosition ,FinalPosition),
    move(GameState, move_position(InitialPosition, FinalPosition), NewGameState),
    display_game(NewGameState),
    game_loop(NewGameState), !.

game_over(game_state(Board, _), Player) :-
    setof(pos(NRow, NColumn), (Sublist,Elem)^(nth0(NRow, Board, Sublist), member(Elem, Sublist), nth0(NColumn, Sublist, piece(_, Player)), water_hole(Board, pos(NRow, NColumn))), Positions),
    length(Positions, N),
    N > 2.
