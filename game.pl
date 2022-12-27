
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

