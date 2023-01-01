ame_init(BoardSize, Mode) :-
    initial_state(BoardSize, GameState),
    display_game(GameState),
    game_loop(GameState, Mode).

game_loop(GameState, _) :-
    game_over(GameState, Winner),
    !.
    
% Human - Human
game_loop(GameState, 1) :-
    human_move(GameState, InitialPosition ,FinalPosition),
    move(GameState, move_position(InitialPosition, FinalPosition), NewGameState),
    display_game(NewGameState),
    game_loop(NewGameState, 1), 
    !.


% Human - Computer - Easy

game_loop(game_state(Board, player1), 2) :-
    GameState = game_state(Board, player1),
    human_move(GameState, InitialPosition ,FinalPosition),
    move(GameState, move_position(InitialPosition, FinalPosition), NewGameState),
    display_game(NewGameState),
    game_loop(NewGameState, 2),
    !.

game_loop(game_state(Board, player2), 2) :-
    GameState = game_state(Board, player2),
    choose_move(GameState, easy , Move),
    move(GameState, Move, NewGameState),
    display_game(NewGameState),
    game_loop(NewGameState, 2),
    !.

% Computer - Human - Easy

game_loop(game_state(Board, player1), 3) :-
    GameState = game_state(Board, player1),
    choose_move(GameState, easy , Move),
    move(GameState, Move, NewGameState),
    display_game(NewGameState),
    game_loop(NewGameState,3),!.

game_loop(game_state(Board, player2), 3) :-
    GameState = game_state(Board, player2),
    human_move(GameState, InitialPosition ,FinalPosition),
    move(GameState, move_position(InitialPosition, FinalPosition), NewGameState),
    display_game(NewGameState),
    game_loop(NewGameState,3),!.


% Human - Computer - Difficult

game_loop(game_state(Board, player1), 4) :-
    GameState = game_state(Board, player1),
    human_move(GameState, InitialPosition ,FinalPosition),
    move(GameState, move_position(InitialPosition, FinalPosition), NewGameState),
    display_game(NewGameState),
    game_loop(NewGameState, 4),
    !.

game_loop(game_state(Board, player2), 4) :-
    GameState = game_state(Board, player2),
    choose_move(GameState, difficult , Move),
    move(GameState, Move, NewGameState),
    display_game(NewGameState),
    game_loop(NewGameState, 4),
    !.
    

% Computer - Human - Difficult

game_loop(game_state(Board, player1), 5) :-
    GameState = game_state(Board, player1),
    choose_move(GameState, difficult , Move),
    move(GameState, Move, NewGameState),
    display_game(NewGameState),
    game_loop(NewGameState, 5),!.

game_loop(game_state(Board, player2), 5) :-
    GameState = game_state(Board, player2),
    human_move(GameState, InitialPosition ,FinalPosition),
    move(GameState, move_position(InitialPosition, FinalPosition), NewGameState),
    display_game(NewGameState),
    game_loop(NewGameState, 5),!.



% Computer - Computer

game_loop(GameState,6) :-
    choose_move(GameState, difficult, Move),
    move(GameState, Move, NewGameState),
    display_game(NewGameState),
    sleep(3),
    game_loop(NewGameState,6),!.

game_loop(GameState,Mode) :-
    clear,
    display_game(GameState),
    write('Invalid move!'),
    game_loop(GameState,Mode),!.

game_over(game_state(Board, _), Player) :-
    setof(pos(NRow, NColumn), (Sublist,Elem)^(nth0(NRow, Board, Sublist), member(Elem, Sublist), nth0(NColumn, Sublist, piece(_, Player)), water_hole(Board, pos(NRow, NColumn))), Positions),
    length(Positions, N),
    N > 2.
