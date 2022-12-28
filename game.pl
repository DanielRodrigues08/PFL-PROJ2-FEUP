
game_init(BoardSize) :-
    initial_state(BoardSize, GameState),
    display_game(GameState),
    game_loop(GameState).

game_loop(GameState) :-
    game_over(GameState, Winner), !.

game_loop(GameState) :-
    human_move(GameState, InitialPosition ,FinalPosition),
    move(GameState, move_position(InitialPosition, FinalPosition), NewGameState),
    display_game(NewGameState),
    game_loop(NewGameState), !.

game_loop(GameState) :-
    clear,
    display_game(GameState),
    write('Invalid move!'),
    game_loop(GameState), !.

game_over(game_state(Board, _), Player) :-
    setof(pos(NRow, NColumn), (Sublist,Elem)^(nth0(NRow, Board, Sublist), member(Elem, Sublist), nth0(NColumn, Sublist, piece(_, Player)), water_hole(Board, pos(NRow, NColumn))), Positions),
    length(Positions, N),
    N > 2.
